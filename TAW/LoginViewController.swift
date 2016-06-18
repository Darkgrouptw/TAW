//
//  ViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/1.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit
import CryptoSwift

class LoginViewController: UIViewController
{
    // 跟 POST 相關
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/AccountManager/TokenRequest.php")!
    let loginurl: NSURL = NSURL(string: "http://140.118.175.73/TAW/AccountManager/Login.php")!
    var key: String!
    var iv: String!
    
    var loginSuccess: Bool = false
    
    // 存起來的檔案
    var LoginData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var AccountText: UITextField!
    @IBOutlet var PasswordText: UITextField!
    @IBOutlet var ResponseText: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "LoginToMenu"
        {
            NSThread.sleepForTimeInterval(1)
            return loginSuccess
        }
        return true
    }
    
    @IBAction func LoginButtonPress(sender: AnyObject)
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
        
        self.ResponseText.text = "登入中"
        let request =  NSMutableURLRequest(URL: loginurl)
        request.HTTPMethod = "POST"
        let ParamsAccount: String = try! AccountText.text!.encrypt(AES(key: key, iv: iv)).toBase64()!
        let ParamsPassword: String = try! PasswordText.text!.encrypt(AES(key: key, iv: iv)).toBase64()!
        let ParamsTime: String = try! FunctionSet.GetTimeToString().encrypt(AES(key: key, iv: iv)).toBase64()!
        let params: String = "Account=" + ParamsAccount + "&Password=" + ParamsPassword + "&Time=" + ParamsTime
        
        
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
            var data = responseString!.componentsSeparatedByString("\n")
            data[0] = data[0].stringByReplacingOccurrencesOfString("Type: ", withString: "")
            
            print("\(responseString)")
            switch data[0]
            {
            case "00":
                self.LoginData.setObject(data[2].stringByReplacingOccurrencesOfString("Token: ", withString: ""), forKey: "Token")
                print("登入成功！！")
                dispatch_async(dispatch_get_main_queue()) {
                    self.loginSuccess = true
                }

            case "01":
                FunctionSet.AlertMessageShow("時間有誤，請使用正確時間", targetViewController: self)
                
            case "02":
                FunctionSet.AlertMessageShow("Server異常，請重新開始", targetViewController: self)
                
            case "03":
                FunctionSet.AlertMessageShow("帳號密碼錯誤", targetViewController: self)
            default:
                break
            }
            self.ResponseText.text = ""
        }
        task.resume()
    }
    
    @IBAction func CanelButtonClick(sender: AnyObject)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func AllKeyBoardExit(sender: AnyObject)
    {
        AccountText.resignFirstResponder()
        PasswordText.resignFirstResponder()
    }
    @IBAction func KeyBoardFinishExit(sender: AnyObject)
    {
        sender.resignFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

