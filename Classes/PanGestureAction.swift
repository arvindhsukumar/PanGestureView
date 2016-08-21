//
//  PanGestureAction.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

public class PanGestureAction: NSObject {
    public var swipeDirection: PanGestureViewSwipeDirection!
    public var backgroundColor: UIColor?
    public var tintColor: UIColor?
    public var image:UIImage?
    public var isActive:Bool = false
    public var didTriggerBlock: ((swipeDirection: PanGestureViewSwipeDirection) -> ())?
    
    public convenience init(swipeDirection: PanGestureViewSwipeDirection, image:UIImage?) {
        self.init()
        self.swipeDirection = swipeDirection
        self.image = image
    }
}
