//
//  ViewController.swift
//  WiFI_Login
//
//  Created by Feng Li on 9/27/15.
//  Copyright © 2015 Feng Li. All rights reserved.
//

import UIKit
import Foundation
//import SafariServices

//class ViewController: UIViewController, SFSafariViewControllerDelegate {
class ViewController: UIViewController {
    var password:String = ""
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwdText: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextFieldTopCons: NSLayoutConstraint!
    
    func getPassword() {
        let url = NSURL(string: "http://52.68.197.47:81/pass.php")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue()) {
                self.passwdText.text = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
            }
        }
        task!.resume()
    }
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: <#T##NSCoder#>)
//    }
//    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:" as Selector,
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:" as Selector,
            name: UIKeyboardWillHideNotification,
            object: nil)
        getPassword()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        usernameTextFieldTopCons.constant = 30
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()})
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        self.usernameTextFieldTopCons.constant = 250
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()})
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.userText.resignFirstResponder()
        self.passwdText.resignFirstResponder()
    }
    
    @IBAction func login(sender: AnyObject) {
        print("login (\(userText.text!),\(passwdText.text!))")
        dispatch_async(dispatch_get_main_queue()) {
            self.resultLabel.text = "登录中，请稍候"
        }
        loginButton.enabled = false
        var rst:String?
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: configuration)
        
        
//        --data "buttonClicked=4&err_flag=0&err_msg=&info_flag=0&info_msg=&redirect_url=&network_name=Guest+Network&username=guest&password=pidyM8T8"
//        let params:[String: AnyObject] = [
//            "email" : self.userText.text!,
//            "userPwd" : self.passwdText.text!
//        ]
        let data = "buttonClicked=4&err_flag=0&err_msg=&info_flag=0&info_msg=&redirect_url=&network_name=Guest+Network&username=\(self.userText.text!)&password=\(self.passwdText.text!)"
        
        let url = NSURL(string:"https://webauth-redirect.oracle.com/login.html")
//        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestReloadIgnoringLocalCacheData, timeoutInterval: 10)
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 10
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("https://webauth-redirect.oracle.com/login.html",forHTTPHeaderField: "Referer")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)

        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
//                rst = "Login Success: \(response)"
                rst = "登录成功"
                dispatch_async(dispatch_get_main_queue()) {
                    self.resultLabel.text = rst
                }
                UIApplication.sharedApplication().openURL(NSURL(string:"http://baidu.com")!)
//                let url = NSURL(string: "http://baidu.com")!
//                let webViewController = SFSafariViewController(URL: url)
//                webViewController.delegate = self
//                self.presentViewController(webViewController, animated: true, completion: nil)
            }
            
            if (error != nil) {
                rst = "error submitting request: \(error)"
                dispatch_async(dispatch_get_main_queue()) {
                    self.resultLabel.text = rst
                }
                print(rst)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.loginButton.enabled = true
            }

//            // handle the data of the successful response here
//            var result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary

        }
        task!.resume()
    }
    
//    func safariViewControllerDidFinish(controller: SFSafariViewController) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

