//
//  EventCell.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 1/3/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

   
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            // Make it card-like
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowRadius = 2
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            containerView.backgroundColor = #colorLiteral(red: 0.6180580258, green: 0.1074862555, blue: 0.1912124157, alpha: 1)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    // MARK: - Event Cell Set Up

   func setUpEventCell(event: Event){
    titleLabel.text = event.name
    titleLabel.textColor = .white
    descriptionLabel?.text = event.description
    descriptionLabel.textColor = .white
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM yyyy HH:mm"
    timeLabel?.text = formatter.string(from: event.timeStamp)
    timeLabel.textColor = .white
    
    
        
    }
    
    
    
}
