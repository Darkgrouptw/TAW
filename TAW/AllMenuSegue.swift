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
    
    var circle: UIView?
    
    var circleColor: UIColor?
    
    var origin = CGPointZero
    
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
            //sourceVC.view.layer.masksToBounds = true
            circle!.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.clipsToBounds = true
            circle!.center = origin
            
            // 把它縮小
            circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            destinationVC.view.transform = CGAffineTransformMakeScale(0.001, 0.001)
            destinationVC.view.clipsToBounds = true
            
            // 使用它原本的顏色
            circle!.backgroundColor = self.circleColor
            
            sourceVC.view.addSubview(destinationVC.view)
            
            //UIView.anit
            
            UIView.animateWithDuration(presentDuration, animations: {
                self.circle!.transform = CGAffineTransformMakeScale(1, 1)
                destinationVC.view.transform = CGAffineTransformMakeScale(1, 1)
                destinationVC.view.center = originCenter
                }, completion: { (_) -> Void in
                    /*destinationVC.view.removeFromSuperview()
                    
                    
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
                    
                    dispatch_after(time, dispatch_get_main_queue()) {
                        
                        sourceVC.presentViewController(destinationVC, animated: false, completion: nil)}*/
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
