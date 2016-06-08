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
    
    var circle: UIView!
    
    var circleColor: UIColor?
    
    var origin: CGPoint = CGPointZero
    
    let presentDuration = 0.5
    let dismissDuration = 0.3

    
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
            
            sourceVC.view.addSubview(circle)
            
            //UIView.anit
            
            UIView.animateWithDuration(presentDuration, animations: {
                self.circle!.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (_) -> Void in
                    // 把原本的 scene 加上去，再把 circle 刪除
                    self.sourceViewController.presentViewController(self.destinationViewController
                        , animated: false, completion:{(_) -> Void in
                            self.circle.removeFromSuperview()})
                })
        }
        else
        {
            let originCenter = destinationVC.view.center
            let originSize = destinationVC.view.frame.size
            
            circle = UIView(frame: frameFromCircle(originCenter, size: originSize, start: origin))
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.transform = CGAffineTransformMakeScale(1, 1)

            circle!.center = origin
            
            self.destinationViewController.view.addSubview(circle)
            self.sourceViewController.dismissViewControllerAnimated(false, completion: { (_) -> Void in
                UIView.animateWithDuration(self.dismissDuration, animations: {
                    self.circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                    self.circle.alpha = 0
                    }, completion: { (_) -> Void in
                        self.circle!.removeFromSuperview()
                })
            })
            
            
        }
        /*
         
         let returnView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
         let originCenter = returnView.center
         let originSize = returnView.frame.size
         
         
         circle = UIView(frame: frameFromCircle(originCenter, size: originSize, start: origin))
         circle!.layer.cornerRadius = circle!.frame.size.height / 2
         circle!.center = origin
         
         UIView.animateWithDuration(presentDuration, animations: {
         self.circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
         returnView.transform = CGAffineTransformMakeScale(0.001, 0.001)
         returnView.center = originCenter
         returnView.alpha = 0
         }, completion: { (Bool) in
         returnView.removeFromSuperview()
         self.circle!.removeFromSuperview()
         transitionContext.completeTransition(true)
         return
         })

 */
    }
}
