//
//  MissionViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/7.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class MissionViewController: UIViewController
{
    var OriginButtonCenter = CGPointZero
    var OriginButtonColor: UIColor?
    
    
    var qrScanner: QRScanner!
    
    @IBOutlet weak var QRViewBar: UIToolbar!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var LoadingImage: UIImageView!
    
    var IsStart: Bool = false
    
    // Mission url
    var MissionURL:NSURL = NSURL(string: "http://140.118.175.73/TAW/Missions/")!
    
    
    // 還沒拿到任務之前，都是 False
    var MissionGET: Bool = false
    
    // 看有沒有上一個任務還沒完成
    var LastData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var selectIndex: Int!           // 選擇第幾個任務
    var StepNext: Int!              // 下一個到第幾步
    var MissionToken: String!       // 要破關的 token
    
    // Get All Data
    var DataFromServer: Array<String>!
    var ButtonFromData: Array<UIButton> = Array<UIButton>()
    var LabelFromData: Array<UILabel> = Array<UILabel>()
    var Timer: NSTimer!
    var TimerIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        LoadingImage.image = UIImage.gifWithName("ButtonImages/Fireworks")
        
        LoadingImage.image = UIImage.gifWithName("ButtonImages/loading")
        
        qrScanner = QRScanner(view: view!,inputLabel:  messageLabel, QRBar: QRViewBar)
        
        let lastMission: String? = LastData.stringForKey("LastMission")
        if(lastMission == nil)
        {
            // 代表上一個任務沒有執行果
            let request = NSMutableURLRequest(URL: MissionURL)
            request.HTTPMethod = "GET"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                self.OperationToDataFromServer(responseString as! String, type: 0)
                
            }
            task.resume()
            Timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(DynamicAddMenuButton), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func TestForQRCode(sender: AnyObject)
    {
        if !IsStart
        {
            IsStart = true
            qrScanner.Start(view)
            Timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(DynamicCheckIfGetToken), userInfo: nil, repeats: true)
        }
    }

    @IBAction func QRCodeStopEvent(sender: AnyObject)
    {
        IsStart = false
        qrScanner.Stop(view)
        Timer.invalidate()
    }
    
    
    // 開始要動態的產生， UILabel，讓他有泡泡飄上來的感覺
    func DynamicAddMenuButton()
    {
        if(TimerIndex < DataFromServer.count)
        {
            // Gif hidden
            if !LoadingImage.hidden {
                LoadingImage.hidden = true
            }
            
            let TempButton = UIButton(frame: ItemRect())
            let TempCenter = TempButton.center
            TempButton.setBackgroundImage(UIImage(named: "ButtonImages/MissionButton.png"), forState: .Normal)
            TempButton.alpha = 0
            TempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            TempButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            TempButton.setTitle(DataFromServer[TimerIndex], forState: .Normal)
            
            // 使用動畫
            TempButton.transform = CGAffineTransformMakeScale(0.01, 0.01)
            TempButton.center = CGPoint(x: self.view.frame.width / 2 ,y: self.view.frame.height)
            
            UIView.animateWithDuration(1, animations: {
                TempButton.transform = CGAffineTransformMakeScale(1, 1)
                TempButton.center = TempCenter
                TempButton.alpha = 1
            })
            
            self.view.addSubview(TempButton)
            ButtonFromData.append(TempButton)
            TimerIndex += 1
        }
        else if(MissionGET)
        {
            for(var i = 0; i < ButtonFromData.count; i++)
            {
                ButtonFromData[i].addTarget(self, action: #selector(ButtonPressEvent), forControlEvents: .TouchUpInside)
            }
            TimerIndex = 0
            Timer.invalidate()
        }
    }
    func DynamicAddMenuLabel()
    {
        if(TimerIndex < DataFromServer.count)
        {
            // Gif hidden
            if !LoadingImage.hidden {
                LoadingImage.hidden = true
            }
            
            let TempLabel = UILabel(frame: ItemRect())
            var TempCenter = TempLabel.center
            TempLabel.alpha = 0
            TempLabel.textAlignment = NSTextAlignment.Center
            TempLabel.text = DataFromServer[TimerIndex]
            TempLabel.font.fontWithSize(30)
            TempLabel.adjustsFontSizeToFitWidth = true
            if StepNext == -1 {
                TempLabel.textColor = UIColor.whiteColor()
                
                LoadingImage.image = UIImage.gifWithName("ButtonImages/Fireworks")
                TempCenter = CGPoint(x: TempCenter.x, y: TempCenter.y - 150)
                LoadingImage.hidden = false
                LoadingImage.transform = CGAffineTransformMake(7, 0, 0, 7, 0, 130)
            }
            
            // 使用動畫
            TempLabel.transform = CGAffineTransformMakeScale(0.01, 0.01)
            TempLabel.center = CGPoint(x: self.view.frame.width / 2 ,y: self.view.frame.height)
            
            UIView.animateWithDuration(1, animations: {
                TempLabel.transform = CGAffineTransformMakeScale(1, 1)
                TempLabel.center = TempCenter
                TempLabel.alpha = 1
            })
            
            self.view.addSubview(TempLabel)
            LabelFromData.append(TempLabel)
            TimerIndex += 1
        }
        else if(MissionGET)
        {
            // Show Camera Button
            CameraButton.hidden = false
            
            TimerIndex = 0
            Timer.invalidate()
        }
    }
    // 確定 qrCode有沒有拿到
    func DynamicCheckIfGetToken()
    {
        if qrScanner.CheckToken(MissionToken)
        {
            self.CameraButton.hidden = true
            FunctionSet.AlertMessageShow("完成任務！！", targetViewController: self)
            UIView.animateWithDuration(1, animations: {
                for(var i = 0; i < self.LabelFromData.count; i++)
                {
                    self.LabelFromData[i].center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height + 100)
                    self.LabelFromData[i].transform = CGAffineTransformMakeScale(0.001, 0.001)
                    self.LabelFromData[i].alpha = 0
                }
                }, completion: { (_) -> Void in
                    for(var i = 0; i < self.LabelFromData.count; i++)
                    {
                        self.LabelFromData[i].removeFromSuperview()
                    }
                    
                    // 清除 Label
                    self.LabelFromData.removeAll()
            })
            QRCodeStopEvent(self)
            
            // 開 Thread 拿 http 資料囉
            let params: String = "Mission=" + String(selectIndex) + "&Step=" + String(StepNext)
            let request = NSMutableURLRequest(URL: NSURL(string: "http://140.118.175.73/TAW/Missions/?"+params)!)
            request.HTTPMethod = "GET"
            
            print("======================================")
            print("Params => " + params)
            print("======================================")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
                }
                
                //  將東西清空
                self.DataFromServer.removeAll()
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                self.OperationToDataFromServer(responseString as! String, type: 1)
            }
            task.resume()
            TimerIndex = 0
            Timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(DynamicAddMenuLabel), userInfo: nil, repeats: true)
        }
    }
    
    // 處理從 Server 來的資料 (Mission => 0, Type => 1)
    func OperationToDataFromServer(str: String, type: Int)
    {
        print("=========== Data From Server ===========")
        DataFromServer = str.componentsSeparatedByString("\n")
        if(DataFromServer.last! == "")
        {
            DataFromServer.removeLast()
        }
        for(var i = 0; i < DataFromServer.count; i++){
            print(DataFromServer[i])
        }
        switch type {
        case 0:
            print("Mission => " + String(DataFromServer.count))
        case 1:
            StepNext = Int(DataFromServer.last!)!
            DataFromServer.removeLast()
            if StepNext != -1
            {
                // 正常的 Step
                MissionToken = DataFromServer.last!
                DataFromServer.removeLast()
            }
            else
            {
                self.CameraButton.hidden = true
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(1, animations: {
                        self.view.backgroundColor = UIColor.blackColor()
                    })
                }
            }
            print("Step => " + String(DataFromServer.count))
        default:
            break
        }
        print("========================================")
        
        
        MissionGET = true
    }

    
    func ButtonPressEvent(sender: AnyObject)
    {
        let btn = sender as! UIButton
        print(btn.currentTitle!)
        for(var i = 0; i < DataFromServer.count; i++)
        {
            if(DataFromServer[i] == btn.currentTitle)
            {
                selectIndex = i
                break
            }
        }
        print("Button Press Event => \(selectIndex)")
        
        // 讓按鈕消失
        if  selectIndex != -1
        {
            UIView.animateWithDuration(1, animations: {
                for(var i = 0; i < self.ButtonFromData.count; i++)
                {
                    self.ButtonFromData[i].center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height + 100)
                    self.ButtonFromData[i].transform = CGAffineTransformMakeScale(0.001, 0.001)
                    self.ButtonFromData[i].alpha = 0
                }
                }, completion: { (_) -> Void in
                    for(var i = 0; i < self.ButtonFromData.count; i++)
                    {
                        self.ButtonFromData[i].removeFromSuperview()
                    }
                    
                    // 清除 Button
                    self.ButtonFromData.removeAll()
            })
        }
        
        // 動態顯示 label
        LoadingImage.hidden = false
        
        MissionGET = false
        
        // 開一個 Thread 去接 step 0,1,2
        let params: String = "Mission=" + String(selectIndex)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://140.118.175.73/TAW/Missions/?"+params)!)
        request.HTTPMethod = "GET"
        
        print("======================================")
        print("Params => " + params)
        print("======================================")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                //print("網路異常，請重新開始")
                FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                FunctionSet.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
            }
            
            //  將東西清空
            self.DataFromServer.removeAll()
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.OperationToDataFromServer(responseString as! String, type: 1)
        }
        task.resume()
        TimerIndex = 0
        Timer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(DynamicAddMenuLabel), userInfo: nil, repeats: true)
    }
    
    func ItemRect() -> CGRect
    {
        let screenWidth = self.view.frame.size.width
        let ButtonHeight: CGFloat = 100
        let Scale: CGFloat = 0.9
        
        let LocationX: CGFloat = self.view.frame.size.width/2 - screenWidth * Scale / 2
        var LocationY: CGFloat = 0
        
        // 奇數偶數的不同
        if TimerIndex % 2 == 1
        {
            LocationY = self.view.frame.size.height / 2 - ((CGFloat(DataFromServer.count) - 1) / 2 + 0.5) * ButtonHeight + CGFloat(TimerIndex) * ButtonHeight
        }
        else
        {
            LocationY = self.view.frame.size.height / 2 - (CGFloat(DataFromServer.count)) / 2 * ButtonHeight + CGFloat(TimerIndex) * ButtonHeight
        }
        return CGRectMake(LocationX, LocationY, screenWidth * Scale, ButtonHeight * Scale)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let seg = segue as! AllMenuSegue
        seg.Mode = .Dismiss
        seg.origin = OriginButtonCenter
        seg.circleColor = OriginButtonColor
    }
}
