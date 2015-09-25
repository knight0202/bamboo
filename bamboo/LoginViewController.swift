//
//  LoginViewController.swift
//  bamboo
//
//  Created by knight on 2015. 9. 18..
//  Copyright (c) 2015년 knight. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var pwText: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("!!!!")
        
        self.emailText.delegate = self
        self.pwText.delegate = self
        
        self.actInd.center = self.view.center
        
        self.actInd.hidesWhenStopped = true
        
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //----------------------------------textField 관련----------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("start")
        animateViewMoving(true, moveValue: 200)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("end")
        animateViewMoving(false, moveValue: 200)
    }

    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    //-----------------------------------textField관련 끝--------------------------------------
    
    
    @IBAction func loginAction(sender: AnyObject) {
        let username = self.emailText.text
        let password = self.pwText.text
        
        self.actInd.startAnimating()
        
        PFUser.logInWithUsernameInBackground(username!, password: password!){
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("success")
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
}