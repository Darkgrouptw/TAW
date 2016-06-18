//
//  ExpandSegue.swift
//  TAW
//
//  Created by Graphics on 2016/6/18.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class ExpandSegue: UIStoryboardSegue
{
    enum ExpandTransitionMode: Int {
        case Present, Dismiss
    }
    
    let presentDuration = 0.4
    let dismissDuration = 0.15
    
    var openingFrame: CGRect!
    var transitionMode: ExpandTransitionMode = .Present
    
    var topView: UIView!
    var bottomView: UIView!
    
    
    override func perform()
    {
        let fromVC = self.sourceViewController
        let fromViewFrame = fromVC.view.frame
        
        let toVC = self.destinationViewController
        let containerView = fromVC.view!
        
        if transitionMode == .Present {
            // 拿按鈕以上的 View ，截圖下來
            topView = fromVC.view.resizableSnapshotViewFromRect(fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(openingFrame.origin.y, 0, 0, 0))
            topView.frame = CGRectMake(0, 0, fromViewFrame.width, openingFrame.origin.y)
            
            // Add view to container
            containerView.addSubview(topView)
            
            
            // 拿 Buttom 的 view，截圖下來
            bottomView = fromVC.view.resizableSnapshotViewFromRect(fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, fromViewFrame.height - openingFrame.origin.y - openingFrame.height, 0))
            bottomView.frame = CGRectMake(0, openingFrame.origin.y + openingFrame.height, fromViewFrame.width, fromViewFrame.height - openingFrame.origin.y - openingFrame.height)
            
            // Add view to container
            containerView.addSubview(bottomView)
            
            let snapshotView: UIView = UIView() //toVC.viewresizableSnapshotViewFromRect(fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
            snapshotView.backgroundColor = toVC.view.backgroundColor
            snapshotView.frame = openingFrame
            containerView.addSubview(snapshotView)
            
            toVC.view.alpha = 0.0
            containerView.addSubview(toVC.view)
            
            UIView.animateWithDuration(presentDuration, animations: { () -> Void in
                self.topView.frame = CGRectMake(0, -self.topView.frame.height, self.topView.frame.width, self.topView.frame.height)
                self.bottomView.frame = CGRectMake(0, fromViewFrame.height, self.bottomView.frame.width, self.bottomView.frame.height)
                // 將整個擴展開來
                snapshotView.frame = toVC.view.frame
                }, completion: { (_) -> Void in
                    snapshotView.removeFromSuperview()
                    toVC.view.alpha = 1
                    fromVC.navigationController!.pushViewController(toVC, animated: false)
            })
        }
        else
        {
            fromVC.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
