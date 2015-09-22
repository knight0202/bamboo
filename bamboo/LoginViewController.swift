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
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            self.actInd.stopAnimating()
            
            if user != nil {
                // Do stuff after successful login.
                
                let alert = UIAlertController(title: "알림", message:"로그인되었습니다.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "로그인창으로", style: UIAlertActionStyle.Default , handler: {(alert: UIAlertAction!) in
                    
                    print("login success, move to main page")
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // The login failed. Check error to see why.
                
                let alert = UIAlertController(title: "오류", message:"로그인이 실패했습니다. 아이디와 비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "로그인창으로", style: UIAlertActionStyle.Default , handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }
        }
    }
}