//
//  RegisterViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/1.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    let url: NSURL = NSURL(string: "http://140.118.175.73/TAW/Register.php")!
    var key: String!
    
    @IBOutlet weak var AccountText: UITextField!
    @IBOutlet weak var PaaswordText: UITextField!
    
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
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
    }
}