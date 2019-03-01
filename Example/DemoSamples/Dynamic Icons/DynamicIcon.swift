//
//  DynamicIcon.swift
//  Demos
//
//  Created by Daniel Nielsen on 16/08/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit

class DynamicIcon: UIView {

    @IBOutlet var label:UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> DynamicIcon {
        return UINib(nibName: "DynamicIcon", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DynamicIcon
    }

}
