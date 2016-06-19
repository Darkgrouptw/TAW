//
//  MenuToAll.swift
//  TAW
//
//  Created by Graphics on 2016/6/7.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class AllMenuSegue: UIStoryboardSegue
{
    enum PopMode {
        case Present, Dismiss
    }
    
    var Mode: PopMode = .Present
    
    // 是背景，為了讓使用者看不出來是方形，所以外面再多包一層圓
    var circle: UIView!
    
    var circleColor: UIColor?
    
    var origin: CGPoint = CGPointZero
    
    let presentDuration = 0.5
    let dismissDuration = 0.3 * 10

    
    // 要找最大的圓的 size 能 fit 整個 screen
    func frameFromCircle(center: CGPoint, size: CGSize, start: CGPoint) -> CGRect
    {
        let lengthX = fmax(start.x, size.width - start.x)
        let lengthY = fmax(start.y, size.height - start.y)
        let offset = sqrt(lengthX * lengthX  + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPointZero, size: size)
    }
    
    override func perform()
    {
        let sourceVC = self.sourceViewController
        let destinationVC = self.destinationViewController

        if Mode == .Present
        {
            let originCenter = destinationVC.view.center
            let originSize = destinationVC.view.frame.size

            circle = UIView(frame: frameFromCircle(originCenter, size: originSize, start: origin))
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center = origin
            
            // 把它縮小
            circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            
            // 使用它原本的顏色
            circle!.backgroundColor = self.circleColor
            
            circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            
            destinationVC.view.transform = CGAffineTransformMakeScale(0.001, 0.001)
            destinationVC.view.center = origin
            
            sourceVC.view.addSubview(circle)
            sourceVC.view.addSubview(destinationVC.view)
            
            // UIView 動畫
            UIView.animateWithDuration(presentDuration, animations: {
                self.circle!.transform = CGAffineTransformMakeScale(1, 1)
                destinationVC.view.transform = CGAffineTransformMakeScale(1, 1)
                destinationVC.view.center = originCenter
                }, completion: { (_) -> Void in
                    self.circle.removeFromSuperview()
                    self.sourceViewController.navigationController!.pushViewController(self.destinationViewController, animated: false)
            })
        }
        else
        {
            sourceVC.navigationController!.popViewControllerAnimated(true)
        }
    }
}
