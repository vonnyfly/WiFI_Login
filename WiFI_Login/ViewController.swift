//
//  ViewController.swift
//  WiFI_Login
//
//  Created by Feng Li on 9/27/15.
//  Copyright © 2015 Feng Li. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var password:String = ""
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwdText: UITextField!
    
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

