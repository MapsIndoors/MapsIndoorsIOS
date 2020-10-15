//
//  BagdedImage.swift
//  MapsIndoors
//
//  Created by Daniel Nielsen on 12/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//
import UIKit
import Foundation

/// Image helper class that can render a badge on top of another image.
@objcMembers
public class BagdedIcon : NSObject {
    
    /// Renders a new image with a circular or pill shaped text badge on top of it with given configuration.
    /// - Parameter config: The configuration to use for the badge.
    /// - Returns: The rendered image with a badge.
    public static func bagdedIcon(config:BagdedIconConfiguration) -> UIImage? {
        guard let source = config.originalIcon.cgImage else {
            return nil
        }
        
        let sourceSize = CGSize(width: source.width, height: source.height)
        
        let bagdePosOffset = CGPoint(x: 0.9, y: 0.1)
        
        let scale = UIScreen.main.scale
        let padding = config.badgePadding * 2.0
        let unscaledBadgeSize = (config.badgeText as NSString).size(withAttributes: [NSAttributedString.Key.font : config.badgeFont])
        let badgeSize = CGSize(width: (unscaledBadgeSize.width + padding) * scale, height: (unscaledBadgeSize.height + padding) * scale)
        
        let badgeWidthFraction = badgeSize.width / sourceSize.width
        let badgeHeightFraction = badgeSize.height / sourceSize.height
        
        let widthFactor: CGFloat = max(bagdePosOffset.x, 1 - bagdePosOffset.x) + badgeWidthFraction / 2.0
        let heightFactor: CGFloat = max(bagdePosOffset.y, 1 - bagdePosOffset.y) + badgeHeightFraction / 2.0
        
        var newWidth: CGFloat = 1.0
        var newHeight: CGFloat = 1.0
        
        if widthFactor > 1 {
            newWidth = (widthFactor * 2 - 1) * sourceSize.width
        }
        if heightFactor > 1 {
            newHeight = (heightFactor * 2 - 1) * sourceSize.height
        }
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let imagePos = CGPoint(
            x: (newWidth - sourceSize.width) / 2,
            y: (newHeight - sourceSize.height) / 2
        )

        // start drawing
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()

        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: imagePos.x, y: imagePos.y, width: sourceSize.width, height: sourceSize.height)
        context.draw(source, in: rect)
        
        context.restoreGState()
        
        let badgeRect = CGRect(
            x: imagePos.x + sourceSize.width * bagdePosOffset.x - badgeSize.width / 2.0,
            y: imagePos.y + sourceSize.height * bagdePosOffset.y - badgeSize.height / 2.0,
            width: badgeSize.width,
            height: badgeSize.height
        )
        
        let cornerRadius = min(badgeRect.height, badgeRect.width) / 2.0;

        drawRect(rect: badgeRect, cornerRadius: cornerRadius, color: config.badgeBackgroundColor, ctx: context)
        drawText(text: config.badgeText, textColor:config.badgeTextColor, font:config.badgeFont, rect: badgeRect, padding:config.badgePadding, ctx: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return image
        
    }
    
    private static func drawRect(rect : CGRect, cornerRadius:CGFloat, color: UIColor, ctx: CGContext)
    {
        ctx.saveGState()
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath

        ctx.addPath(clipPath)
        ctx.setFillColor(color.cgColor)

        ctx.closePath()
        ctx.fillPath()
        ctx.restoreGState()
    }

    private static func drawText(text: String, textColor:UIColor, font:UIFont, rect: CGRect, padding:CGFloat, ctx: CGContext) {
        ctx.saveGState()

        let scale = UIScreen.main.scale
        let scaledPadding = padding * scale
        let scaledPaddingX2 = scaledPadding * 2
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let scaledFont = UIFont.init(descriptor: font.fontDescriptor, size: font.pointSize * scale)
        let textRect = CGRect(x: rect.minX + scaledPadding, y: rect.minY + scaledPadding, width: rect.width - scaledPaddingX2, height: rect.height - scaledPaddingX2)
        let textFontAttributes = [
            NSAttributedString.Key.font: scaledFont,
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        ctx.restoreGState()
        
    }

    
}
