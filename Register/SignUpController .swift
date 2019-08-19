//
//  SignUpController .swift
//  Register
//
//  Created by sendy on 13/08/2019.
//  Copyright © 2019 sendy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase


class SignUpController : UIViewController {
    // SignUpcontroller properties
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "sendy")
        return iv
    }()
    
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView (view: view, image: #imageLiteral(resourceName: "email"), textField: emailTextField)
    }()
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView (view: view,image: #imageLiteral(resourceName: "user1") , textField: usernameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView (view: view,image: #imageLiteral(resourceName: "Image") , textField: passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        return tf
    }()
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        return tf
    }()
    
    //the login button
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    //the dont have an account button
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Got an account?", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Login", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getting a database reference
        //var ref: DatabaseReference!
        
        
        // calling the configuration view components
        configureViewComponents ()
    }
    
    //Handling signUp
    @objc func handleSignUp(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let username = usernameTextField.text else{return}
        
        //calling our create user function
        createUser(withEmail: email, username: username, password: password)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //Declaration and handling of the App's APIs
    func createUser (withEmail email: String, username: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            //handling error
            if let error = error{
                print ("user was not signed up", error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else {
                return
                
            }
            let values = ["email":email, "username":username]
            
            //var ref = firebase.database().ref()
            _ = Database.database().reference().child(uid).updateChildValues(values, withCompletionBlock: {error, ref in
                if let error = error{
                    print ("Failed to update data with error", error.localizedDescription)
                    return
                }
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {return}
                
                guard let controller = navController.viewControllers[0]as? HomeController else {return}
                
                controller.configureViewComponents()
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    //the helper functions and app constraints
    func configureViewComponents (){
        view.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: -32, width: 0, height: 50)
        view.addSubview(usernameContainerView)
        usernameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 32, paddingBottom: 0, paddingRight: -32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: -32, width: 0, height:
            50)
        
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 124, paddingLeft: 90, paddingBottom: 0, paddingRight: -90, width: 0, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: -32, width: 0, height: 50)
    }
}


