//
//  SignUpViewController.swift
//  bamboo
//
//  Created by knight on 2015. 9. 18..
//  Copyright (c) 2015년 knight. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var su_name: UITextField!
    @IBOutlet weak var su_nick: UITextField!
    @IBOutlet weak var su_em: UITextField!
    @IBOutlet weak var confirmText: UILabel!
    @IBOutlet weak var su_pw: UITextField!
    @IBOutlet weak var su_pw2: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.su_name.delegate = self
        self.su_em.delegate = self
        self.su_nick.delegate = self
        self.su_pw.delegate = self
        self.su_pw2.delegate = self
        
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
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
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

    
    
    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    //------------------------------이메일(아이디) 중복 검사 함수 시작--------------------------------
   
    
    @IBAction func ConfirmAction(sender: AnyObject) {
        //var ConfirmQuery = PFQuery(className: "User")
        if su_em.text != "" {
            let ConfirmQuery = PFUser.query()
            ConfirmQuery?.whereKey("username", equalTo: su_em.text!)
            var confirmCount: Int = 0
            backgroundThread(background:{
                let confirm = ConfirmQuery?.findObjects()
                confirmCount = confirm!.count
                },completion:{
                    if confirmCount == 0 {
                        self.confirmText.text = "확인완료"
                        self.confirmText.textColor = UIColor.blueColor()
                    } else if confirmCount > 0 {
                        self.confirmText.text = "중복계정"
                        self.confirmText.textColor = UIColor.redColor()
                    }
            })
        }else{
            let alert = UIAlertController(title: "오류", message:"이메일을 입력 후 중복검사 해주세요", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    //-----------------------------이메일(아이디) 중복 검사 함수 끝------------------------------------
    
    
    
    
    //-------------------------------------회원가입 함수 시작---------------------------------------
   
    @IBAction func SignUpAction(sender: AnyObject) {
        if su_pw.text != su_pw2.text {
            /*var alert = UIAlertView(title: "오류", message: "비밀번호가 일치하지 않습니다!", delegate: self, cancelButtonTitle: "확인")
            alert.show()*/
            
            let alert = UIAlertController(title: "오류", message:"비밀번호가 일치하지 않습니다!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default , handler: {(alert: UIAlertAction!) in
                self.su_pw.text = ""
                self.su_pw2.text = ""
            }))
            self.presentViewController(alert, animated: true, completion: nil )
        }else if confirmText.text != "확인완료" {
            let alert = UIAlertController(title: "오류", message:"아이디 중복검사를 해주세요", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
            let user = PFUser()
            user.username = su_em.text
            user.password = su_pw.text
            user.email = su_em.text
            user["nickName"] = su_nick.text
            user["name"] = su_name.text
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    let alert = UIAlertController(title: "오류", message:"회원가입이 실패했습니다. 다시 시도해주세요", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.Default , handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "알림", message:"축하드립니다. 회원가입이 성공했습니다. ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "로그인창으로", style: UIAlertActionStyle.Default , handler: {(alert: UIAlertAction!) in
                        self.dismissViewControllerAnimated(true, completion: nil);
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    //--------------------------------------회원가입 함수 끝----------------------------------------
    
    
    
    @IBAction func BackAction(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil);
        
    }
}



//-----change at 10:50pm
