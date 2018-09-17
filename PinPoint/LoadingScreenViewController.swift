//
//  LoadingScreenViewController.swift
//  PinPoint
//
//  Created by Grant Maloney on 8/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var logoHeightTop: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    let alert = UIAlertController(title: "Error", message: "This is an alert.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailInput.alpha = 0
        self.passwordInput.alpha = 0
        self.loginButton.alpha = 0
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(update), userInfo: nil, repeats: false)
        
        emailInput.leftViewMode = .always
        passwordInput.leftViewMode = .always
        emailInput.placeholder = "Enter Email"
        passwordInput.placeholder = "Enter Password"
        //Hide the password with *'s
        emailInput.leftView = UIImageView(image: UIImage(named: "Email2")?.resized(toWidth: 20.0))
        passwordInput.leftView = UIImageView(image: UIImage(named: "Password")?.resized(toWidth: 25.0))
        loginButton.layer.cornerRadius = 5.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        var failed: Bool = false
        
        if let email = emailInput.text {
            if email.isEmpty {
                alert.message = "You must enter an email!"
                failed = true
            }
        }
        
        if let password = passwordInput.text {
            if password.isEmpty {
                alert.message = "You must enter a password!"
                failed = true
            }
        }
        
        if failed {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Performing segue!")
            self.performSegue(withIdentifier: "mapView", sender: nil)
        }
    }
    
    @objc
    func update() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseIn, animations: {
            self.logoImage.center.y -= 120
            self.emailInput.alpha = 100
            self.passwordInput.alpha = 100
            self.loginButton.alpha = 100
        }, completion: { finished in
            self.logoHeight.constant += 120;
            self.logoHeightTop.constant -= 120;
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
