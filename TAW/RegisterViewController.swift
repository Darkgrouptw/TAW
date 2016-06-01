//
//  RegisterViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/1.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterViewController: UIViewController {
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/Register.php")!
    var key: String!
    var iv: String!
    
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Register Page Get Key => " + key)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func RegisterButtonEvent(sender: AnyObject)
    {
        if(AccountText.text?.characters.count < 6)
        {
            LoginViewController.AlertMessageShow("帳號大於６個字",  targetViewController: self)
            return
        }
        if(PasswordText.text?.characters.count < 6)
        {
            LoginViewController.AlertMessageShow("密碼大於６個字", targetViewController: self)
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let params: String = "Time="+LoginViewController.GetTimeToString()
        
        print("======================================")
        print("Params => " + params)
        print("======================================")
    }
}