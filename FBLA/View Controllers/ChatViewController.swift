//
//  ChatViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 5/19/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
//import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    
    var currentUser: User = Auth.auth().currentUser!
    
    var user2Name: String? = "Student"
    var user2ImgUrl: String? = ""
    var user2UID: String? = ""
    var status:Bool?
    private var docReference: DocumentReference?
    let db = Firestore.firestore()
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user2Name ?? "Chat"
        print(getAllUsers())
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.systemBlue, for: .normal)
        messageInputBar.delegate = self

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
    }
      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
       
       
        db.collection("users").document(self.currentUser.uid).getDocument { (document, error) in
                           if let error = error
                           {
                               print(error)
                            
                           }
                           else {
                               //Gets user information from the firebase database and sets the UI elements to the data
                               if let document = document, document.exists{
                                   let teacherStatus:Bool = document.get("teacherStatus") as! Bool
                                if(teacherStatus){
                                    self.becomeFirstResponder()
                                }
                                
                                
                                
                                 
                               }
                                
                           }
                       }
            
        
          
      }
    func getDisplayName(uuid: String) -> String{
               var name = ""
        
                db.collection("users").document(uuid).getDocument { (document, error) in
                   if let error = error
                   {
                       print(error)
                   }
                   else {
                       //Gets user information from the firebase database and sets the UI elements to the data
                       if let document = document, document.exists{
                        
                           let firstName:String = document.get("firstName") as! String
                           let lastName:String = document.get("lastName") as! String
                           
                            name = firstName + " " + lastName
                           print(name)
                       }
                        
                   }
               }
               print(name)
               return name
           
           }
    func getAllUsers() -> [String]{
        var users:[String] = []
        db.collection("users").getDocuments() { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
               
                for document in snapshot!.documents {
                    print(document.documentID)
                    users.append(document.documentID)
                }
            }
        }
        print(users)
        return users
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
                                    "users":users
                                ]
                                
                        let db = Firestore.firestore().collection("Chats")
                        print(data)
                        db.addDocument(data: data) { (error) in
                            if let error = error {
                            print("Unable to create chat! \(error)")
                            return
                            }
                            else {
                                self.loadChat()
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
    func disableInput(){
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument() { (document, error) in

            if let error = error {

                print(error.localizedDescription)

            } else {

              if let document = document, document.exists {
              let tempTeacherStatus = document.get("teacherStatus") as! Bool
              let hideStatus = tempTeacherStatus
             //If the user is a teacher certain elements are hidden and certain elements are displayed
              if !hideStatus{
                 
                self.messageInputBar.isHidden = true
                
              }
              else{
                
                self.messageInputBar.isHidden = false
         

                 }
             
              
                }
            }
        }
    }
    
    func loadChat() {
        
             
           
           //Fetch all the chats which has current user in it
           let db = Firestore.firestore().collection("Chats")
                   .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
           
           
           db.getDocuments { (chatQuerySnap, error) in
               
               if let error = error {
                   print("Error: \(error)")
                   return
               } else {
                   
                   //Count the no. of documents returned
                   guard let queryCount = chatQuerySnap?.documents.count else {
                       return
                   }
                   
                   if queryCount == 0 {
                       //If documents count is zero that means there is no chat available and we need to create a new instance
                       self.createNewChat()
                   }
                   else if queryCount >= 1 {
                       //Chat(s) found for currentUser
                       for doc in chatQuerySnap!.documents {
                           
                           let chat = Chat(dictionary: doc.data())
                           //Get the chat which has user2 id
                        if(chat?.isAnnouncement == true && self.user2UID == "Announcements"){
                            self.disableInput()
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                        print("Data: \(msg?.content ?? "No message found")")
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom(animated: true)
                            }
                            })
                            return
                        }
                        else{
                        
                            if ((chat?.users.contains(self.user2UID!))! && chat?.users.count == 2) {
                               
                               self.docReference = doc.reference
                               //fetch it's thread collection
                                doc.reference.collection("thread")
                                   .order(by: "created", descending: false)
                                   .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                               if let error = error {
                                   print("Error: \(error)")
                                   return
                               } else {
                                   self.messages.removeAll()
                                       for message in threadQuery!.documents {

                                           let msg = Message(dictionary: message.data())
                                           self.messages.append(msg!)
                                           print("Data: \(msg?.content ?? "No message found")")
                                       }
                                   self.messagesCollectionView.reloadData()
                                   self.messagesCollectionView.scrollToBottom(animated: true)
                               }
                               })
                               return
                           }
                        }//end of if
                       } //end of for
                       self.createNewChat()
                   } else {
                      
                   }
               }
           }
       }
    // MARK: - InputBarAccessoryViewDelegate
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
            
        })
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //print(getDisplayName(uuid: currentUser.uid))
        db.collection("users").document(currentUser.uid).getDocument { (document, error) in
            if let error = error
            {
                print(error)
            }
            else {
                //Gets user information from the firebase database and sets the UI elements to the data
                if let document = document, document.exists{
                 
                    let firstName:String = document.get("firstName") as! String
                    let lastName:String = document.get("lastName") as! String
                    
                    // name = firstName + " " + lastName
                   // print(name)
                    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: self.currentUser.uid, senderName:  firstName + " " + lastName)
                           print(message)
                                   
                                     //messages.append(message)
                    self.insertNewMessage(message)
                    self.save(message)
                       
                                     inputBar.inputTextView.text = ""
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                    
                }
                 
            }
        }
        /*let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: getDisplayName(uuid: currentUser.uid))
        print(message)
                
                  //messages.append(message)
                  insertNewMessage(message)
                  save(message)
    
                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                  messagesCollectionView.scrollToBottom(animated: true)*/
    }
    func currentSender() -> SenderType {
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
         if messages.count == 0 {
                   print("No messages to display")
                   return 0
               } else {
                   return messages.count
               }
        
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 0.10, green: 0.51, blue: 0.99, alpha: 1.00): UIColor(red: 0.89, green: 0.90, blue: 0.91, alpha: 1.00)
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
       /* if message.sender.senderId == currentUser.uid {
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }*/
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }

}
