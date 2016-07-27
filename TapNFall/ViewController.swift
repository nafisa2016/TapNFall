//
//  ViewController.swift
//  TapNFall
//
//  Created on: 03-June-2016
//      Author: Nafisa Rahman
//
//  LICENSE:-
//  The MIT License (MIT)
//  Copyright (c) 2016 Nafisa Rahman
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom
//  the Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall
//  be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
//  OR OTHER DEALINGS IN THE SOFTWARE.
//


import UIKit

class ViewController: UIViewController {
    
    //MARK:- properties
    var animator: UIDynamicAnimator?
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor =  UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        
        //tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFallAction(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tap to let the blurred view fall
    func tapFallAction(sender: UITapGestureRecognizer){
        
        //remove subview with tag 100
        if  self.view.viewWithTag(100) != nil {
            self.view.viewWithTag(100)?.removeFromSuperview()
        }
        
        
        //UIVisualEffect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0,0,self.view.frame.width,self.view.frame.height - UIApplication.sharedApplication().statusBarFrame.size.height)
        
        blurView.transform = CGAffineTransformMakeTranslation(0, 10 * (-self.view.frame.height))
        blurView.tag = 100
        
        self.view.addSubview(blurView)
        
        //vibrancy can only be used with blur effect
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect:blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = blurView.bounds
        
        // text with vibrancy effect
        let vibrancyEffectLabel = UILabel()
        vibrancyEffectLabel.text = "Message"
        vibrancyEffectLabel.center = self.view.center
        vibrancyEffectLabel.font = UIFont.systemFontOfSize(32.0)
        vibrancyEffectLabel.sizeToFit()
        
        // Add label to the vibrancy view
        vibrancyView.contentView.addSubview(vibrancyEffectLabel)
        
        // Add the vibrancy view to the blur view
        blurView.contentView.addSubview(vibrancyView)        
        
        //remove existing behaviors
        animator?.removeAllBehaviors()
        
        //reference view
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //add gravity behavior
        let gravity = UIGravityBehavior(items: [blurView])
        let vector = CGVectorMake(0.5,0.5)
        gravity.gravityDirection = vector
        animator!.addBehavior(gravity)
        
        
        //add collision behavior
        let collision = UICollisionBehavior(items: [blurView])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionMode = UICollisionBehaviorMode.Everything
        animator!.addBehavior(collision)
        
        //add item behavior
        let behavior = UIDynamicItemBehavior(items: [blurView])
        behavior.elasticity = 1.0
        behavior.density = 0.00000001
        animator?.addBehavior(behavior)
        
        //add tap gesture to the fallen blurred view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapMoveUpAction(_:)))
        blurView.addGestureRecognizer(tap)
    }
    
    //MARK: tap to move up the blurred view
    func tapMoveUpAction(sender: UITapGestureRecognizer){
        
        guard let fallenView =  self.view.viewWithTag(100) else{
            print("no such view exists")
            return
        }
        
        animator?.removeAllBehaviors()
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //gravity
        let gravityUp = UIGravityBehavior(items: [fallenView])
        let vector = CGVectorMake(0.0,-1.0)
        gravityUp.gravityDirection = vector
        animator!.addBehavior(gravityUp)
        
        
        //item behaviour
        let behaviorUp = UIDynamicItemBehavior(items: [fallenView])
        behaviorUp.elasticity = 1.0
        behaviorUp.density = 0.00000001
        behaviorUp.friction = 0.9
        animator?.addBehavior(behaviorUp)
        
    }
    
    //MARK: restrict auto rotation
    override func shouldAutorotate() -> Bool {
        
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            return true
        default:
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return [ UIInterfaceOrientationMask.Portrait]
        
    }
    
    
    
}

