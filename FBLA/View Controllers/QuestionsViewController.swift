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

    
    @IBOutlet weak var faqView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [FAQItem(question: "How do I join Lambert FBLA?", answer: "a) We are glad that you are interested in joining Lambert FBLA! To join you must first click the profile icon located in the top right on the “Home” page. Then click the “Join Lambert FBLA” button. A reminder will pop-up reminding you to pay club dues on MyPaymentsPlus. Now you have one last step to do, go on MyPaymentsPlus and pay the appropriate club fees.b) Congrats! You are now an official Lambert FBLA member!"),
                    FAQItem(question: "What are the different levels of competitive events?", answer: "a)FBLA has 2 or 3 levels of competitive events depending on which event you are doing. b)Regional Leadership Conference - This is the most regional level of competition and you are divided by region in which you are competing against. You can go to the FBLA website to learn more about the Regional Leadership Conference, the type of events you can partake in as well as how the regions are divided. The top competitors that place at the Regional Leadership Conference will move on to the State Leadership Conference. c)State Leadership Conference - These are competitive events that occur at the state level. Even though there are numerous events that take place, some of them require qualification at the Regional level. Make sure to check the official FBLA website to learn more about which events require regional qualification and which events are straight to state.  The top competitors that place at State Leadership Conference will move on to the National Leadership Conference. d)National Leadership Conference - This is the highest level of competition amongst the FBLA community. At NLC you will be competing against top performers around the country in your respective event. Make sure to check the FBLA website to learn more about the National Leadership Conference. Hope to see you there!")]

       let faqView = FAQView(frame: view.frame, title: " ", items: items)
       self.faqView.addSubview(faqView)
       faqView.viewBackgroundColor = UIColor.white

      //  faqView.translatesAutoresizingMaskIntoConstraints = false
        
        

        
    }
    

   
    // MARK: - Issue Button

    //Creates an Alert that allows user to input any issues which are saved in the Firebase Database
   
   /* @IBAction func issueButtonTapped(_ sender: Any) {
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
        
        }*/
    }
    
    


