//
//  MainViewController.swift
//  bamboo
//
//  Created by knight on 2015. 9. 18..
//  Copyright (c) 2015년 knight. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil {
            let loginAlertController = UIAlertController(title: "Sign up / login", message: "please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlertController.addTextFieldWithConfigurationHandler({
                textfField in
                textfField.placeholder = "Your username"
            })
            
            loginAlertController.addTextFieldWithConfigurationHandler({
                textfField in
                textfField.placeholder = "Your password"
                textfField.secureTextEntry = true
            })
            
            //            MARK: login action in the array
            loginAlertController.addAction(UIAlertAction(title: "Login Action", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields : NSArray = loginAlertController.textFields!
                let usernameTextField : UITextField = textFields[0] as! UITextField
                let passwordTextField : UITextField = textFields[1] as! UITextField
                
                //MARK: Parse login problem - 15:39
                PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!){
                    (user: PFUser?, error: NSError?) -> Void in
                    
                    if user != nil {
                        print("login success!")
                    } else {
                        print("login failed!")
                    }
                }
            }))
            
            //            MARK: sign up action in the array
            loginAlertController.addAction(UIAlertAction(title: "Sign up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields : NSArray = loginAlertController.textFields!
                let usernameTextField : UITextField = textFields[0] as! UITextField
                let passwordTextField : UITextField = textFields[1] as! UITextField
                
                let sweeter = PFUser() //16:42
                sweeter.username = usernameTextField.text
                sweeter.password = passwordTextField.text
                
                sweeter.signUpInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("sign up successful")
                    } else {
                        let errorString = error!.userInfo["error"] as! String
                        print(errorString)
                    }
                })
                
            }))
            
            
            self.presentViewController(loginAlertController, animated: true, completion: nil)
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
