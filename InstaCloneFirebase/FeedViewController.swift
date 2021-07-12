//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Sinan Kulen on 10.06.2021.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var userArray = [String]()
    var userCommentArray = [String]()
    var userEmailArray = [String]()
    var userlikeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirebase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userLikeLabel.text = String(userlikeArray[indexPath.row])
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    
    func getDataFromFirebase(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                   
                    self.userlikeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                                             
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.userlikeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }

}
