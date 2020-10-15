//
//  BagdedImageConfiguration.swift
//  MapsIndoors
//
//  Created by Daniel Nielsen on 13/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//
import UIKit
import Foundation


/// Badge position model. Use the static getters to get positions for top right, top left, bottom left and bottom right.
@objcMembers
public class BagdePosition : NSObject {
    /// Static getter a top right position value.
    public static let topRight = BagdePosition(x: 0.9, y: 0.1)
    /// Static getter a top left position value.
    public static let topLeft = BagdePosition(x: 0.1, y: 0.1)
    /// Static getter a bottom right position value.
    public static let bottomRight = BagdePosition(x: 0.9, y: 0.9)
    /// Static getter a bottom left position value.
    public static let bottomLeft = BagdePosition(x: 0.1, y: 0.9)
    let point: CGPoint
    
    @objc public init(x:CGFloat, y:CGFloat) {
        point = CGPoint(x: x, y: y)
    }
}

/// Badge icon configuration model.
@objcMembers
public class BagdedIconConfiguration : NSObject {
    /// The source icon image.
    public let originalIcon:UIImage
    /// The badge text that should be rendered inside the badge.
    public let badgeText:String
    /// Set the badge text color.
    public var badgeTextColor:UIColor
    /// Set the padding between the badge text and the edge of the badge. Default is 2 points.
    public var badgePadding:CGFloat
    /// Set the background color for the badge. Default is DarkGray.
    public var badgeBackgroundColor:UIColor
    /// Set the font that should be used when rendering the badge text. Default is system font with size 16.
    public var badgeFont:UIFont
    /// Set the position of the badge. Default is top right.
    public var bagdePosition:BagdePosition
    
    /// Badge icon configuration initialiser.
    /// - Parameters:
    ///   - originalIcon: The original icon image on which a badge must be added.
    ///   - badgeText: The badge text string.
    public init(originalIcon:UIImage, badgeText:String) {
        self.originalIcon = originalIcon
        self.badgeText = badgeText
        self.badgeTextColor = .white
        self.badgePadding = 2
        self.badgeBackgroundColor = .darkGray
        self.badgeFont = .systemFont(ofSize: 16)
        self.bagdePosition = BagdePosition.topRight
    }
    
}
