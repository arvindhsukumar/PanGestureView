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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = UILabel(frame: CGRectMake(0,0,200,30))
        label.text = "Test"
        label.textAlignment = NSTextAlignment.Center
        label.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        swipeView.contentView.addSubview(label)
        label.center = swipeView.contentView.center
        
        swipeView.contentView.backgroundColor = UIColor.greenColor()
        
        let action = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Right)
        action.backgroundColor = UIColor.blueColor()
        action.didTriggerBlock = {
            direction in
            
            label.text = "\(direction)"
        }
        swipeView.addAction(action)
        
        let action2 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Left)
        action2.backgroundColor = UIColor.redColor()
        swipeView.addAction(action2)
        
        let action4 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Up)
        action4.backgroundColor = UIColor.orangeColor()
        swipeView.addAction(action4)
        
        let action5 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.Down)
        action5.backgroundColor = UIColor.yellowColor()
        action5.didTriggerBlock = {
            direction in
            
            print(direction)
        }
        swipeView.addAction(action5)



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

