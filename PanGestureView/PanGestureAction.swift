//
//  PanGestureAction.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

class PanGestureAction: NSObject {
    var swipeDirection: PanGestureViewSwipeDirection!
    var backgroundColor: UIColor!
    var isActive:Bool = false
    var didTriggerBlock: ((swipeDirection: PanGestureViewSwipeDirection) -> ())?
    
    convenience init(swipeDirection: PanGestureViewSwipeDirection) {
        self.init()
        self.swipeDirection = swipeDirection
    }
}
