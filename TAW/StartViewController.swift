//
//  StartViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/17.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIViewControllerTransitioningDelegate
{
    // 跟 POST 相關 => 拿 key
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/AccountManager/TokenRequest.php")!
    let loginurl: NSURL = NSURL(string: "http://140.118.175.73/TAW/AccountManager/Login.php")!
    var key: String = ""
    var iv: String = "9947142102698591"
    
    // 存起來的檔案
    var LoginData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var ResponseText: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let params: String = "Time=" + FunctionSet.GetTimeToString()
        print("======================================")
        print("Params => " + params)
        print("======================================")
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                FunctionSet.AlertMessageShow("請連上網路，請重新開始", targetViewController: self)
                return
            }
        
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200
            {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
            }
        
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(responseString)
            var data = responseString!.componentsSeparatedByString("\n")
            data[0] = data[0].stringByReplacingOccurrencesOfString("Type: ", withString: "")
        
            switch data[0]
            {
                case "00":
                    self.key = data[1].stringByReplacingOccurrencesOfString("Key: ", withString: "")
                    print("Key => " + self.key)
        
                case "01":
                    FunctionSet.AlertMessageShow("時間有誤，請使用正確時間", targetViewController: self)
        
                case "02":
                    FunctionSet.AlertMessageShow("Server異常，請重新開始", targetViewController: self)
                default:
                    break
            }
        }
        task.resume()
        
        
        /*let token: String? = LoginData.objectForKey("Token") as! String?
        if(token != nil)
        {
        // 直接傳送 Token
        
        }*/

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let seg = segue as! ExpandSegue
        let btn = sender as! UIButton
        seg.openingFrame = btn.frame
        
        switch segue.identifier!
        {
        case "StartToLogin":
            let loginVC = segue.destinationViewController as! LoginViewController
            loginVC.key = self.key
            loginVC.iv = self.iv
            self.ResponseText.text = ""
        case "StartToRegister":
            let registerController = segue.destinationViewController as! RegisterViewController
            registerController.key = self.key
            registerController.iv = self.iv
            registerController.ResponseLabel = self.ResponseText
        default:
            break
        }

    }
    
    
    // 要讓上面那一條不見
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
