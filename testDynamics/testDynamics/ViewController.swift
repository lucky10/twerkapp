//
//  AttachViewController.swift
//  Dynamics Demo
//
//  Created by Joyce Echessa on 8/26/14.
//  Copyright (c) 2014 Joyce Echessa. All rights reserved.
//

import UIKit

class AttachViewController: UIViewController {
    
    //var squareView: UIView!
    //var snap: UISnapBehavior!
    //var animator: UIDynamicAnimator!
    
    var snapForLeftAss: UISnapBehavior!
    var animatorForLeftAss: UIDynamicAnimator!
    var snapForRightAss: UISnapBehavior!
    var animatorForRightAss: UIDynamicAnimator!
    
    var ifAnimation: Bool!
    
    
    var leftAssCenter: CGPoint!
    var rightAssCenter: CGPoint!
    
    var leftAssSize: CGSize!
    var rightAssSize: CGSize!
    
    @IBOutlet weak var leftAssImg: UIImageView!
    @IBOutlet weak var rightAssImg: UIImageView!
    
    @IBAction func MyPanHandler(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .began){
            if (snapForLeftAss != nil) {
                animatorForLeftAss.removeBehavior(snapForLeftAss)
            }
            if (snapForRightAss != nil) {
                animatorForRightAss.removeBehavior(snapForRightAss)
            }
            
            leftAssImg.center = leftAssCenter
            rightAssImg.center = rightAssCenter
        }
        
        let delta_Y = CGFloat(100)
        let delta_X = CGFloat(50)
        let location = sender.location(in: self.view)
        let translation = sender.translation(in: self.view)
        
        let multyplierForShift = CGFloat(0.5)
        
        leftAssImg.center.x = leftAssCenter.x - (leftAssCenter.x - location.x)*multyplierForShift
        leftAssImg.center.y = leftAssCenter.y - (leftAssCenter.y - location.y)*multyplierForShift
        rightAssImg.center.x = rightAssCenter.x - (rightAssCenter.x - location.x)*multyplierForShift
        rightAssImg.center.y = rightAssCenter.y - (rightAssCenter.y - location.y)*multyplierForShift
        
        /*if (abs(location.x - leftAssCenter.x) < delta_X && abs(location.y - leftAssCenter.y) < delta_Y){
            leftAssImg.center.x += translation.x
            rightAssImg.center.x += translation.x
            leftAssImg.center.y += translation.y
            rightAssImg.center.y += translation.y
        }*/
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if (sender.state == .ended){
            if (snapForLeftAss != nil) {
                animatorForLeftAss.removeBehavior(snapForLeftAss)
            }
            if (snapForRightAss != nil) {
                animatorForRightAss.removeBehavior(snapForRightAss)
            }
            
            snapForLeftAss = UISnapBehavior(item: leftAssImg, snapTo: leftAssCenter)
            snapForLeftAss.damping = 0.15
            animatorForLeftAss.addBehavior(snapForLeftAss)
            
            snapForRightAss = UISnapBehavior(item: rightAssImg, snapTo: rightAssCenter)
            snapForRightAss.damping = 0.15
            animatorForRightAss.addBehavior(snapForRightAss)
            
            //MyAssAniamation()
        }
    }
    
    func MyAssAniamation() {
        if(!ifAnimation){
            return
        }
        ifAnimation = false
        let delta = 0.07
        var cur_duration = 0.0
        var cur_delay = delta
        for curNumOfAnimation in 0...2 {
            UIView.animate(withDuration: cur_duration, delay: cur_delay, options: .curveEaseInOut, animations: {
                self.leftAssImg.frame.size.width = self.leftAssSize.width * 0.8
                self.leftAssImg.frame.size.height = self.leftAssSize.height * 0.8
                self.rightAssImg.frame.size.width = self.rightAssSize.width * 0.8
                self.rightAssImg.frame.size.height = self.rightAssSize.height * 0.8
            }, completion: nil)
            cur_duration += delta
            cur_delay += delta
            UIView.animate(withDuration: cur_duration, delay: cur_delay, options: .curveEaseInOut, animations: {
                self.leftAssImg.frame.size.width = self.leftAssSize.width
                self.leftAssImg.frame.size.height = self.leftAssSize.height
                self.rightAssImg.frame.size.width = self.rightAssSize.width
                self.rightAssImg.frame.size.height = self.rightAssSize.height
            }, completion: { (finished: Bool) in
                if(curNumOfAnimation == 2){
                    self.ifAnimation = true
                }
            })
            cur_duration += delta
            cur_delay += delta
        }
    }
    
    @IBAction func MyHandleTap(_ sender: UITapGestureRecognizer) {
        /*let tapPoint: CGPoint = sender.location(in: view)
        
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        print(tapPoint)
        snap = UISnapBehavior(item: squareView, snapTo: tapPoint)
        animator.addBehavior(snap)*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ifAnimation = true
        
        //запоминаем где была жопа
        leftAssCenter = leftAssImg.center
        leftAssSize = leftAssImg.frame.size
        rightAssCenter = rightAssImg.center
        rightAssSize = rightAssImg.frame.size
        
        
        // Do any additional setup after loading the view.
        
        /*squareView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        squareView.backgroundColor = UIColor.blue
        view.addSubview(squareView)
        
        animator = UIDynamicAnimator(referenceView: view)*/
        
        animatorForLeftAss = UIDynamicAnimator(referenceView: self.view)
        animatorForRightAss = UIDynamicAnimator(referenceView: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    var squareView: UIView!
    var anchorView: UIView!
    var attachment: UIAttachmentBehavior!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    

    @IBAction func a(_ sender: UIPanGestureRecognizer) {
        attachment.anchorPoint = sender.location(in: self.view)
        anchorView.center = sender.location(in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        squareView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        squareView.backgroundColor = UIColor.blue
        view.addSubview(squareView)
        
        anchorView = UIView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        anchorView.backgroundColor = UIColor.red
        view.addSubview(anchorView)
        
        attachment = UIAttachmentBehavior(item: squareView, attachedToAnchor: anchorView.center)
        
        
        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(attachment)
        
        gravity = UIGravityBehavior(items: [squareView])
        animator.addBehavior(gravity)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
}
