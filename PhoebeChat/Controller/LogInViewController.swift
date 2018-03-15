//
//  LogInViewController.swift
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.text = "a@b.com"
        passwordTextfield.text = "123456"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            SVProgressHUD.show()
            if error != nil{
                print(error!)
            }else{
                print("Login OK")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "showToChat", sender: self)
            }
        }
        
    }
    


    
}  
