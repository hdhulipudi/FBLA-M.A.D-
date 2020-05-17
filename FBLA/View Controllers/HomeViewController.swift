//
//  HomeViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        //view.layer.addSublayer(gradientLayer)

    }
    
    //When button is tapped using the storyboard segues the user will be sent to the user viewcontroller



}
