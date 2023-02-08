//
//  uploadViewController.swift
//  workshop_swift_ig_clone
//
//  Created by Levent Kantaroğlu on 5.02.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(chooseImage)
        )
        imageView.addGestureRecognizer(gestureRecognizer)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }

    @IBOutlet var commentText: UITextField!
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var uploadButton: UIButton!

    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")

        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid: String = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data) { _, error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    imageRef.downloadURL { url, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            let imageUrl = url?.absoluteString
                            let firestore = Firestore.firestore()
                            let firestorePost: [String: Any] =
                                [
                                    "imageUrl": imageUrl!,
                                    "postedBy": Auth.auth().currentUser!.email!,
                                    "comment": self.commentText.text!,
                                    "date": FieldValue.serverTimestamp(),
                                    "likes": 0
                                ]
                            // let firestoreRef: DocumentReference =
                            firestore.collection("Posts").addDocument(data: firestorePost) { error in
                                if error != nil {
                                    print(error!.localizedDescription)
                                } else {
                                    self.imageView.image = UIImage(systemName: "tray.fill")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
