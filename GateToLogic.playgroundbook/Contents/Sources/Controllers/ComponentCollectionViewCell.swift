//
//  ComponentCollectionViewCell.swift
//  GateToLogic
//
//  Created by Steffen Ryll on 26.03.18.
//  Copyright © 2018 Steffen Ryll. All rights reserved.
//

#if os(iOS)

    import UIKit

    public final class ComponentCollectionViewCell : UICollectionViewCell {
        static let reuseIdentifier = "ComponentCollectionViewCell"

        // MARK: - Life Cycle

        var component: Composable!

        // MARK: - User Interface

        @IBOutlet var titleLabel: UILabel!
    }

#endif
