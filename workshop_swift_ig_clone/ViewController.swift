//
//  ViewController.swift
//  workshop_swift_ig_clone
//
//  Created by Levent Kantaroğlu on 31.01.2023.
//

import FirebaseAuth
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        emailText.text = "@mail.com"
        passwordText.text = "123456"
    }

    @IBOutlet var emailText: UITextField!

    @IBOutlet var passwordText: UITextField!

    @IBAction func signInClicked(_ sender: Any) {
        // performSegue(withIdentifier: "toFeedVc", sender: nil)
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { _, error in
                if error != nil {
                    self.displayAlert(
                        title: "Auth Error",
                        message: error?.localizedDescription ?? "No Data"
                    )
                } else {
                    self.performSegue(withIdentifier: "toFeedVc", sender: nil)
                }
            }
        } else {
            displayAlert(
                title: "Form Error",
                message: "Email or Password can't be empty"
            )
        }
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { _, error in
                if error != nil {
                    self.displayAlert(
                        title: "Auth Error",
                        message: error?.localizedDescription ?? "No Data"
                    )
                } else {
                    self.performSegue(withIdentifier: "toFeedVc", sender: nil)
                }
            }
        } else {
            displayAlert(
                title: "Form Error",
                message: "Email or Password can't be empty"
            )
        }
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )

        let alertOkButton = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default
        )
        alert.addAction(alertOkButton)
        present(alert, animated: true)
    }
}
