//
//  ContactUsViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 2/4/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Links
    //Sets all the buttons to their appropriate links

    @IBAction func tappedLink(_ sender: Any) {
        //UIApplication.shared.openURL(NSURL(string: "https://lambertfbla.org")! as URL)
        UIApplication.shared.open(NSURL(string: "https://lambertfbla.org")! as URL)

    }
    @IBAction func tappedLink2(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.fbla-pbl.org")! as URL)
    }
    @IBAction func twitterTapped(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://twitter.com/FBLA_National?s=20")! as URL)
    }
    @IBAction func instagramTapped(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.instagram.com/fbla_pbl/?hl=en")! as URL)
    }
    @IBAction func phoneTapped(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "tel://\( 8003252946)")! as URL)
    }
   

}
