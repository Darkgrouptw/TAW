//
//  BackToLogin.swift
//  TAW
//
//  Created by Graphics on 2016/6/1.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class BackToLogin: UIStoryboardSegue
{
    override func perform()
    {
        self.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
