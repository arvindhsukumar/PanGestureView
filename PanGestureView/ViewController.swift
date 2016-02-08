//
//  ViewController.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var swipeView: PanGestureView!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupViews()
        setupActions()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupActions(){
        
        let action = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Right, image: UIImage(named: "chevron-left")!)
        action.backgroundColor = UIColor(red:0.25, green:0.74, blue:0.55, alpha:1)
        action.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action)
        }
        swipeView.addAction(action)
        
        let action2 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Left, image: UIImage(named: "chevron-right")!)
        action2.backgroundColor = UIColor(red:0.31, green:0.59, blue:0.7, alpha:1)
        action2.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action2)
            
        }
        swipeView.addAction(action2)
        
        let action3 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Up, image: UIImage(named: "chevron-down")!)
        action3.backgroundColor = UIColor(red:0.57, green:0.56, blue:0.95, alpha:1)
        action3.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action3)
            
        }
        
        swipeView.addAction(action3)
        
        let action4 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Down, image: UIImage(named: "chevron-up")!)
        action4.backgroundColor = UIColor(red:0.96, green:0.7, blue:0.31, alpha:1)
        action4.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action4)
            
        }
        swipeView.addAction(action4)
    }
    
    private func setupViews(){
        let container = UIView(frame: CGRectMake(0,0,200,200))
        container.backgroundColor = UIColor(white: 0.9, alpha: 1)
        container.layer.cornerRadius = 100
        container.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        
        label = UILabel(frame: CGRectMake(0,0,140,30))
        label.text = "Pan Anywhere"
        label.textAlignment = NSTextAlignment.Center
        label.center = container.center
        
        container.addSubview(label)
        
        swipeView.contentView.addSubview(container)
        container.center = swipeView.contentView.center
        
        
       
        print(container.center)
    }
    
    private func actionDidTrigger(action: PanGestureAction){
        
        let container = self.label.superview!
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            container.backgroundColor = action.backgroundColor
            self.label.text = "Panned \(action.swipeDirection)"
            self.label.textColor = UIColor.whiteColor()

        }
        
    }

}

