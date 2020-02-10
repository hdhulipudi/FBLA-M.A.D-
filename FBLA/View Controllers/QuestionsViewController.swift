//
//  QuestionsViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 1/10/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase

class QuestionsViewController: UIViewController {

    
    
    @IBOutlet weak var issueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
    }
    

   
    // MARK: - Issue Button

    //Creates an Alert that allows user to input any issues which are saved in the Firebase Database
   
    @IBAction func issueButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let alert = UIAlertController(title: "Enter issue:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { issueField in
            issueField.placeholder = "Input your issue here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let issue = alert.textFields?.first?.text {
                db.collection("issues").document().setData(["issue":issue])
                
            }
        }))

        self.present(alert, animated: true)
        
        }
    }
    
    


