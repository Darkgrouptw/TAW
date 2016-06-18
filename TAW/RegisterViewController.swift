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
    
    weak var ResponseLabel: UILabel?        // 從 Login 來的 UILabel
    
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/Register.php")!
    var key: String!
    var iv: String!
    
    
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Register Page Get Key => " + key + "\n" + iv)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func RegisterButtonEvent(sender: AnyObject)
    {
        if(AccountText.text?.characters.count < 6)
        {
            FunctionSet.AlertMessageShow("帳號大於６個字",  targetViewController: self)
            return
        }
        if(PasswordText.text?.characters.count < 6)
        {
            FunctionSet.AlertMessageShow("密碼大於６個字", targetViewController: self)
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let ParamsUser: String = try! AccountText.text!.encrypt(AES(key: key, iv: iv)).toBase64()!
        let ParamsPass: String = try! PasswordText.text!.encrypt(AES(key: key, iv: iv)).toBase64()!
        let ParamsTime: String = try! FunctionSet.GetTimeToString().encrypt(AES(key: key, iv: iv)).toBase64()!
        let params: String = "Account=" + ParamsUser + "&Password=" + ParamsPass + "&Time=" + ParamsTime
        print("======================================")
        print("Params => " + params)
        print("======================================")
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            var data = responseString!.componentsSeparatedByString("\n")
            data[0] = data[0].stringByReplacingOccurrencesOfString("Type: ", withString: "")
            
            switch data[0]
            {
            case "00":
                self.dismissViewControllerAnimated(true, completion: {() in self.SendSuccessMessageToLogin()})
        
            case "01":
                FunctionSet.AlertMessageShow("時間有誤，請使用正確時間", targetViewController: self)
                
            case "02":
                FunctionSet.AlertMessageShow("Server異常，請重新開始", targetViewController: self)
            
            case "03":
                FunctionSet.AlertMessageShow("帳號註冊過了", targetViewController: self)
                
            default:
                print(responseString)
                break
            }
        }
        task.resume()
    }
    
    
    @IBAction func AllKeyBoradExit(sender: AnyObject)
    {
        AccountText.resignFirstResponder()
        PasswordText.resignFirstResponder()
    }
    @IBAction func KeyBoardFinishExit(sender: AnyObject)
    {
        sender.resignFirstResponder()
    }
    
    
    func SendSuccessMessageToLogin()
    {
        self.ResponseLabel?.text = "註冊成功！！"
    }
}