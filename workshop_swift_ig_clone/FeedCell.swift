//
//  FeedCell.swift
//  workshop_swift_ig_clone
//
//  Created by Levent Kantaroğlu on 7.02.2023.
//

import FirebaseFirestore
import UIKit

class FeedCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var docIdLabel: UILabel!

    @IBOutlet var emailLabel: UILabel!

    @IBOutlet var userImageLabel: UIImageView!

    @IBOutlet var commentLabel: UILabel!

    @IBOutlet var likeLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        var firestoreDb = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeKeyValue = ["likes": likeCount + 1] as [String: Any]
            firestoreDb.collection("Posts")
                .document(docIdLabel.text!)
                .setData(likeKeyValue, merge: true)
        }
    }
}
