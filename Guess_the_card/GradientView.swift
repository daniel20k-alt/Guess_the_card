//
//  GradientView.swift
//  Guess_the_card
//
//  Created by DDDD on 08/11/2020.
//

import UIKit

@IBDesignable class GradientView: UIView { //IBDesignable draws inside Interface Builder when changes are made

    //IBInspectable for makes the class property editable in Interface Builder
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
