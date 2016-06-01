//
//  ViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/1.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/TokenRequest.php")!
    var key: String!
    var iv: String = "9947142102698591"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 要傳 post 時間（Ymd-His）給 server，時間正確就拿到 key 回來
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let params: String = "Time=" + LoginViewController.GetTimeToString()
        print("======================================")
        print("Params => " + params)
        print("======================================")
        
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                LoginViewController.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                LoginViewController.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            var data = responseString!.componentsSeparatedByString("\n")
            data[0] = data[0].stringByReplacingOccurrencesOfString("Type: ", withString: "")
            
            switch data[0]
            {
            case "00":
                self.key = data[1].stringByReplacingOccurrencesOfString("Key: ", withString: "")
                print("Key => " + self.key)
                
            case "01":
                LoginViewController.AlertMessageShow("時間有誤，請使用正確時間", targetViewController: self)
                
            case "02":
                LoginViewController.AlertMessageShow("Server異常，請重新開始", targetViewController: self)
            default:
                break
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // 要將 key 傳給 Reigster 頁面
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //switch
        switch segue.identifier!
        {
        case "LoginToRegister":
            let registerController = segue.destinationViewController as! RegisterViewController
            registerController.key = self.key
            registerController.iv = self.iv
        default:
            break
        }
    }
    


    static func GetTimeToString() -> String
    {
        // 拿現在時間
        let date: NSDate = NSDate()
        
        //將時間 fomat 成某個形式
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_TW")
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    static func AlertMessageShow(msg: String, targetViewController: UIViewController)
    {
        let question: UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let buttonAction: UIAlertAction = UIAlertAction(title: "離開", style: .Default, handler: nil)
        question.addAction(buttonAction)
        targetViewController.presentViewController(question, animated: true, completion: nil)
    }
}

