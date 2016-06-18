//
//  AlartView.swift
//  TAW
//
//  Created by Graphics on 2016/6/18.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class FunctionSet: NSObject {
    static func AlertMessageShow(msg: String, targetViewController: UIViewController)
    {
        let question: UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
        let buttonAction: UIAlertAction = UIAlertAction(title: "離開", style: .Default, handler: nil)
        question.addAction(buttonAction)
        targetViewController.presentViewController(question, animated: true, completion: nil)
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
}
