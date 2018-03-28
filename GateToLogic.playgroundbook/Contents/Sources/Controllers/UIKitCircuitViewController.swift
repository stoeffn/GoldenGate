//
//  UIKitCircuitViewController.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import SceneKit
    import UIKit

    public final class UIKitCircuitViewController : CircuitViewController {

        // MARK: - Life Cycle

        public override func viewDidLoad() {
            super.viewDidLoad()

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
        }

        public override var circuit: Circuit? {
            get { return super.circuit }
            set {
                super.circuit = newValue
                circuitSceneViewController?.view.addInteraction(UIDragInteraction(delegate: self))
                circuitSceneViewController?.view.addInteraction(UIDropInteraction(delegate: self))
                view.sendSubview(toBack: previewSceneView)
            }
        }

        // MARK: - User Interface

        override public var prefersStatusBarHidden: Bool {
            return true
        }

        private(set) lazy var componentsBackgroundView: UIVisualEffectView = {
            let frame = CGRect(x: 0, y: self.view.bounds.height - 240, width: self.view.bounds.width, height: 240)
            let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            view.frame = frame
            return view
        }()

        private(set) lazy var componentsHairlineView: UIView = {
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5)
            let view = UIView(frame: frame)
            view.autoresizingMask = [.flexibleWidth]
            view.backgroundColor = .lightGray
            return view
        }()

        private(set) lazy var componentsCollectionViewLayout: UICollectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 128, height: 160)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            return layout
        }()

        private(set) lazy var componentsCollectionView: UICollectionView = {
            let view = UICollectionView(frame: .zero, collectionViewLayout: componentsCollectionViewLayout)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.dataSource = self
            view.dragDelegate = self
            view.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: ComponentCollectionViewCell.reuseIdentifier)
            view.backgroundColor = .clear
            view.clipsToBounds = false
            return view
        }()

        private(set) lazy var previewSceneView: SCNView = {
            let frame = CGRect(x: 0, y: 0, width: 128, height: 128)
            let view = SCNView(frame: frame)
            view.backgroundColor = .clear
            return view
        }()

        let availableComponents: [(title: String, component: Composable)] = [
            (title: "Constant", component: Constant(value: true)),
            (title: "Inverter", component: Inverter()),
            (title: "And", component: Gate(operator: .and)),
            (title: "Or", component: Gate(operator: .or)),
            (title: "Led", component: Led()),
            (title: "Wire", component: Wire(orientations: [.left, .right])),
            (title: "Wire", component: Wire(orientations: [.left, .top])),
            (title: "Wire", component: Wire(orientations: [.left, .top, .right])),
            (title: "Wire", component: Wire(orientations: [.left, .top, .right, .bottom]))
        ]

        private func preparePreviewScene(for component: Composable, at location: CGPoint) {
            previewSceneView.center = location
            previewSceneView.scene = SCNScene(named: componentPreviewSceneName)
            previewSceneView.scene?.rootNode.addChildNode(nodeController(for: component).node)
        }

        // MARK: - User Interaction

        @IBAction
        func didTap(_ sender: UIGestureRecognizer) {
            guard let position = circuitSceneViewController?.position(at: sender.location(in: view)) else { return }
            circuitSceneViewController?.circuit[position]?.trigger()
        }

        @IBAction
        func didLongPress(_ sender: UIGestureRecognizer) {
            guard
                let position = circuitSceneViewController?.position(at: sender.location(in: view)),
                let component = circuitSceneViewController?.circuit[position],
                !component.isLocked
            else { return }
            circuitSceneViewController?.circuit[position] = nil
        }
    }

    // MARK: - Tool Bar Data Source

    extension UIKitCircuitViewController : UICollectionViewDataSource {
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return availableComponents.count
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComponentCollectionViewCell.reuseIdentifier, for: indexPath)
            (cell as? ComponentCollectionViewCell)?.titleLabel.text = availableComponents[indexPath.row].title
            (cell as? ComponentCollectionViewCell)?.component = availableComponents[indexPath.row].component
            return cell
        }
    }

    // MARK: - Dragging Components from the Tool Bar

    extension UIKitCircuitViewController : UICollectionViewDragDelegate {
        public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                                   at indexPath: IndexPath) -> [UIDragItem] {
            let itemProvider = availableComponents[indexPath.row].component.itemProvider()
            return [UIDragItem(itemProvider: itemProvider)]
        }

        public func collectionView(_ collectionView: UICollectionView,
                                   dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            let parameters = UIDragPreviewParameters()
            parameters.visiblePath = UIBezierPath(rect: previewSceneView.bounds)
            return parameters
        }
    }

    // MARK: - Dragging Components from the Scene

    extension UIKitCircuitViewController : UIDragInteractionDelegate {
        public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                let component = circuitSceneViewController?.circuit[position],
                !component.isLocked
            else { return [] }
            let itemProvider = component.itemProvider(at: position)
            return [UIDragItem(itemProvider: itemProvider)]
        }

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidTransferItems session: UIDragSession) {
            session.items.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier) { (data, _) in
                guard
                    let data = data,
                    let anyPositionedComponent = try? JSONDecoder().decode(AnyPositionedComponent.self, from: data),
                    let previousPosition = anyPositionedComponent.position
                else { return }
                self.circuitSceneViewController?.circuit[previousPosition] = nil
            }
        }

        public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem,
                                    session: UIDragSession) -> UITargetedDragPreview? {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                let component = circuitSceneViewController?.circuit[position]
            else { return nil }
            preparePreviewScene(for: component, at: session.location(in: view))
            return UITargetedDragPreview(view: previewSceneView)
        }

        public func dragInteraction(_ interaction: UIDragInteraction, prefersFullSizePreviewsFor session: UIDragSession) -> Bool {
            return true
        }

        public func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
            view.sendSubview(toBack: previewSceneView)
        }
    }

    // MARK: - Dropping Components to the Scene

    extension UIKitCircuitViewController : UIDropInteractionDelegate {
        public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
            return session.hasItemsConforming(toTypeIdentifiers: [AnyPositionedComponent.identifier])
        }

        public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
            guard
                let position = circuitSceneViewController?.position(at: session.location(in: view)),
                circuitSceneViewController?.circuit[position] == nil
            else { return UIDropProposal(operation: .cancel) }
            return UIDropProposal(operation: .move)
        }

        public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
            session.items.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: AnyPositionedComponent.identifier) { (data, _) in
                guard
                    let data = data,
                    let component = try? JSONDecoder().decode(AnyPositionedComponent.self, from: data).component,
                    let position = self.circuitSceneViewController?.position(at: session.location(in: self.view))
                else { return }
                self.circuitSceneViewController?.circuit[position] = component
            }
        }
    }

#endif
