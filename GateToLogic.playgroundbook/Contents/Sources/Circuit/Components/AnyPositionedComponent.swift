//
//  AnyPositionedComponent.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 24.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

struct AnyPositionedComponent {
    static let identifier = "AnyPositionedComponent"

    let entity: ComponentEntity

    let component: Composable

    let position: GridPoint?

    init?(component: Composable, position: GridPoint? = nil) {
        guard let entity = ComponentEntity(component: component) else { return nil }
        self.entity = entity
        self.component = component
        self.position = position
    }
}

extension AnyPositionedComponent : Codable {
    enum CodingKeys : String, CodingKey {
        case entity, component, position
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entity = try container.decode(ComponentEntity.self, forKey: .entity)
        position = try container.decodeIfPresent(GridPoint.self, forKey: .position)

        switch entity {
        case .constant: component = try container.decode(Constant.self, forKey: .component)
        case .gate: component = try container.decode(Gate.self, forKey: .component)
        case .inverter: component = try container.decode(Inverter.self, forKey: .component)
        case .led: component = try container.decode(Led.self, forKey: .component)
        case .wire: component = try container.decode(Wire.self, forKey: .component)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entity, forKey: .entity)
        try position?.encode(to: container.superEncoder(forKey: .position))
        try component.encode(to: container.superEncoder(forKey: .component))
    }
}
