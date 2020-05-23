//
//  ChatListTableViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 5/23/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatListTableViewController: UITableViewController {
    var chatNames:[String] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
       
        super.viewDidLoad()
      
        //print("hi")
    
        //print(chatNames)
        //getChats()
        loadData()

    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if #available(iOS 11.0, *) {
             navigationItem.largeTitleDisplayMode = .always
                 navigationController?.navigationBar.prefersLargeTitles = true
             }
         }
    @IBAction func addButtonClicked(_ sender: Any) {
        createNewChat()
    }
    func loadData() {
        
        db.collection("Chats").whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1").getDocuments() { (snapshot, error) in

               if let error = error {

                   print(error.localizedDescription)

               } else {

                   if let snapshot = snapshot {

                       for document in snapshot.documents {
                           let data = Chat(dictionary: document.data())
                          
                           print(data)
                        
                           if(data!.users.count > 2){
                            self.chatNames.append("Announcements")
                           }
                           else{
                            for user in data!.users{
                                if(user != Auth.auth().currentUser?.uid){
                                    self.chatNames.append(user)
                                }
                            }
                          }
                           
                           
                          // self.chatNames = array
                       }
                       self.tableView.reloadData()
                   }
               }
           }
       
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // var chatNames:[String] = []
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = chatNames[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      
        //When clicked on the user is sent to the UserDetailsView
        let chatViewController = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        //Sends the user name value of the cell clicked to the user details controller
        chatViewController.user2UID = chatNames[indexPath.row]
        
       
        
        //Instantiates the view using an animation
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
        func createNewChat() {
       // let users = [self.currentUser.uid, self.user2UID]
        var users:[String] = []
               db.collection("users").getDocuments() { (snapshot, error) in
                   if let error = error {
                       print("Error getting documents: \(error)")
                   } else {
                      
                       for document in snapshot!.documents {
                           print(document.documentID)
                           users.append(document.documentID)
                       }
                        let data: [String: Any] = [
                                    "users":users,
                            "isAnnouncement":true
                                ]
                                
                        let db = Firestore.firestore().collection("Chats")
                        print(data)
                        db.addDocument(data: data) { (error) in
                            if let error = error {
                            print("Unable to create chat! \(error)")
                            return
                            }
                            else {
                                //self.loadChat()
                                self.chatNames.removeAll()
                                self.loadData()
                                }
                        }
                    
                }
            }
            
        
        
         /*let data: [String: Any] = [
             "users":users
         ]
         
         let db = Firestore.firestore().collection("Chats")
        print(data)
         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }*/
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}