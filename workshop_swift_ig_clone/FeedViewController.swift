//
//  FeedViewController.swift
//  workshop_swift_ig_clone
//
//  Created by Levent Kantaroğlu on 5.02.2023.
//

import FirebaseFirestore
import SDWebImage
import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var docIdArray = [String]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.docIdLabel.text = docIdArray[indexPath.row]
        cell.userImageLabel.sd_setImage(
            with: URL(string: userImageArray[indexPath.row])
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    func getDataFromFirebase() {
        let firestore = Firestore.firestore()
        firestore.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.userImageArray.removeAll()
                self.userEmailArray.removeAll()
                self.userCommentArray.removeAll()
                self.docIdArray.removeAll()
                self.likeArray.removeAll()
                for document: QueryDocumentSnapshot in snapshot!.documents {
                    if let postedBy = document.get("postedBy") as? String {
                        self.userEmailArray.append(postedBy)
                    }
                    if let postComment = document.get("comment") as? String {
                        self.userCommentArray.append(postComment)
                    }
                    if let likeCount = document.get("likes") as? Int {
                        self.likeArray.append(likeCount)
                    }
                    if let imageUrl = document.get("imageUrl") as? String {
                        self.userImageArray.append(imageUrl)
                    }
                    if let docID = document.documentID as? String {
                        self.docIdArray.append(docID)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirebase()
    }

    @IBOutlet var tableView: UITableView!
}
