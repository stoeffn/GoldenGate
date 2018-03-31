//
//  CircuitEditorViewController.swift
//  GoldenGate
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

import SceneKit

public class CircuitEditorViewController : ViewController {

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
            view.addSubview(componentsBackgroundView)
            componentsBackgroundView.contentView.addSubview(componentsHairlineView)
            componentsBackgroundView.contentView.addSubview(componentsCollectionView)
            componentsCollectionView.leftAnchor.constraint(equalTo: componentsBackgroundView.contentView.leftAnchor).isActive = true
            componentsCollectionView.topAnchor.constraint(equalTo: componentsBackgroundView.contentView.topAnchor).isActive = true
            componentsCollectionView.rightAnchor.constraint(equalTo: componentsBackgroundView.contentView.rightAnchor).isActive = true
            componentsCollectionView.heightAnchor.constraint(equalToConstant: 160).isActive = true

            view.addSubview(previewSceneView)

            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
            view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))))
        #endif
    }

    #if os(iOS)

        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            updateComponentRotations()
        }

    #endif

    // MARK: - Circuit Management

    private(set) var circuitSceneViewController: CircuitSceneViewController?

    public var circuit: Circuit? {
        get { return circuitSceneViewController?.circuit }
        set {
            circuitSceneViewController?.view.removeFromSuperview()

            guard let circuit = newValue else { return }
            let controller = CircuitSceneViewController(circuit: circuit)
            circuitSceneViewController = controller

            #if os(iOS)
                view.insertSubview(controller.view, at: 0)
                circuitSceneViewController?.view.addInteraction(UIDragInteraction(delegate: self))
                circuitSceneViewController?.view.addInteraction(UIDropInteraction(delegate: self))
                view.sendSubview(toBack: previewSceneView)
            #else
                view.addSubview(controller.view)
            #endif

            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }

    // MARK: - AppKit User Interface

    #if os(OSX)

    @IBOutlet var componentDescriptionMenuItem: NSMenuItem!

    @IBOutlet var componentIsLockedMenuItem: NSMenuItem!

    #endif

    // MARK: - Handling AppKit Events

    #if os(OSX)

        var currentComponentPosition: GridPoint?

        @IBOutlet var addComponentMenu: NSMenu!

        @IBOutlet var componentContextMenu: NSMenu!

        override public func mouseDown(with event: NSEvent) {
            super.mouseDown(with: event)

            currentComponentPosition = circuitSceneViewController?.position(at: view.convert(event.locationInWindow, to: nil))
            guard let position = currentComponentPosition else { return }

            guard circuitSceneViewController?.circuit[position] != nil else { return}

            circuitSceneViewController?.circuit[position]?.trigger()
        }

        override public func rightMouseDown(with event: NSEvent) {
            super.rightMouseDown(with: event)

            currentComponentPosition = circuitSceneViewController?.position(at: view.convert(event.locationInWindow, to: nil))
            guard let position = currentComponentPosition else { return }

            guard let component = circuitSceneViewController?.circuit[position] else {
                return NSMenu.popUpContextMenu(addComponentMenu, with: event, for: view)
            }

            componentDescriptionMenuItem.title = String(reflecting: component)
            componentIsLockedMenuItem.state = component.isLocked ? .on : .off
            NSMenu.popUpContextMenu(componentContextMenu, with: event, for: view)
        }

    #endif

    // MARK: - UIKit User Interface

    #if os(iOS)

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        lazy var componentsBackgroundView: UIVisualEffectView = {
            let frame = CGRect(x: 0, y: self.view.bounds.height - 240, width: self.view.bounds.width, height: 240)
            let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            view.frame = frame
            return view
        }()

        lazy var componentsHairlineView: UIView = {
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5)
            let view = UIView(frame: frame)
            view.autoresizingMask = [.flexibleWidth]
            view.backgroundColor = .lightGray
            return view
        }()

        lazy var componentsCollectionViewLayout: UICollectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 128, height: 160)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            return layout
        }()

        lazy var componentsCollectionView: UICollectionView = {
            let view = UICollectionView(frame: .zero, collectionViewLayout: componentsCollectionViewLayout)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            view.dataSource = self
            view.dragDelegate = self
            view.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.reuseIdentifier)
            view.backgroundColor = .clear
            view.alwaysBounceHorizontal = true
            view.clipsToBounds = false
            return view
        }()

        lazy var previewSceneView: SCNView = {
            let frame = CGRect(x: 0, y: 0, width: 128, height: 128)
            let view = SCNView(frame: frame)
            view.backgroundColor = .clear
            return view
        }()

        func preparePreviewScene(for component: Composable, at location: CGPoint) {
            previewSceneView.center = location
            previewSceneView.scene = SCNScene(named: componentPreviewSceneName)
            previewSceneView.scene?.rootNode.addChildNode(nodeController(for: component).node)
        }

        let availableComponents: [(title: String, component: Composable)] = [
            (title: "Switch", component: Constant(isOn: false)),
            (title: "Inverter", component: Inverter()),
            (title: "And", component: Gate(operator: .and)),
            (title: "Or", component: Gate(operator: .or)),
            (title: "Led", component: Led()),
            (title: "Wire", component: Wire(orientations: [.left, .right])),
            (title: "Wire", component: Wire(orientations: [.left, .top])),
            (title: "Wire", component: Wire(orientations: [.left, .top, .right])),
            (title: "Wire", component: Wire(orientations: [.left, .top, .right, .bottom]))
        ]

    #endif

    // MARK: - Assertion Management

    public var didAssertCircuit: ((Bool) -> Void)?

    public func assertCircuit() {
        didAssertCircuit?(self.circuitSceneViewController?.circuit.meetsAssertions ?? false)
    }
}
