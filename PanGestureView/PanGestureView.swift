//
//  PanGestureView.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

enum PanGestureViewSwipeDirection {
    case None
    case Down
    case Left
    case Up
    case Right
}

let horizontalSwipeDirections = [PanGestureViewSwipeDirection.Left, PanGestureViewSwipeDirection.Right]

class PanGestureView: UIView {

    var contentView: UIView!
    private var actions: [PanGestureViewSwipeDirection:PanGestureAction] = [:]
    private var actionViews: [PanGestureViewSwipeDirection:PanGestureActionView] = [:]
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var swipeDirection: PanGestureViewSwipeDirection!
    private var originalContentViewConstraints: [PanGestureViewSwipeDirection:[NSLayoutConstraint]] = [:]
    private var actionContentViewConstraints: [PanGestureViewSwipeDirection:[NSLayoutConstraint]] = [:]

    
    override init(frame:CGRect){
        super.init(frame:frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView(){
        addContentView()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    private func addContentView(){
        contentView = UIView(frame: self.bounds)
        contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
        
        

    }
    func addAction(action:PanGestureAction){
        
        let direction = action.swipeDirection
        
        actions[direction] = action
        
        if let existingActionView = actionViews[direction]{
            existingActionView.removeFromSuperview()
        }
        
        let view = PanGestureActionView(frame: CGRectMake(0,0,0,0),action:action)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        addConstraintsToActionView(view, direction: direction)
        
        actionViews[direction] = view
    }
    
    func addConstraintsToActionView(actionView:PanGestureActionView, direction:PanGestureViewSwipeDirection) {
        
        if let existingConstraints = originalContentViewConstraints[direction] {
            NSLayoutConstraint.deactivateConstraints(existingConstraints)
            self.removeConstraints(existingConstraints)
        }
        let views = ["view":actionView,"contentView":contentView]
        
        let orientation1 = (horizontalSwipeDirections.contains(direction)) ? "H" : "V"
        let orientation2 = (orientation1 == "H") ? "V" : "H"

        var constraint1:String!
        if direction == .Left || direction == .Up {
            constraint1 = "\(orientation1):[contentView]-(<=0@250,0@750)-[view(>=0)]-0-|"
        }
        else {
            constraint1 = "\(orientation1):|-0-[view(>=0)]-(<=0@250,0@750)-[contentView]"
        }
        let constraints1 = NSLayoutConstraint.constraintsWithVisualFormat(constraint1, options: [], metrics: [:], views: views)
        
        let constraint2 = "\(orientation2):|-0-[view]-0-|"
        let constraints2 = NSLayoutConstraint.constraintsWithVisualFormat(constraint2, options: [], metrics: [:], views: views)
        
        self.addConstraints(constraints1)
        actionContentViewConstraints[direction] = constraints1
        
        self.addConstraints(constraints2)
    }
}

extension PanGestureView : UIGestureRecognizerDelegate {
    
    func handlePan(gesture:UIPanGestureRecognizer){
        let translation = gesture.translationInView(gesture.view)
        let velocity = gesture.velocityInView(gesture.view)
        
        switch gesture.state {
            case .Began:
                swipeDirection = swipeDirectionForTranslation(translation,velocity: velocity)
                print(swipeDirection)
            
            case .Changed:
                
                if actions[swipeDirection] == nil {
                    return
                }
                updatePosition(translation)
            
            case .Cancelled:
                print("cancelled")
            case .Ended:
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.contentView.center = self.center
                    self.setNeedsLayout()
                    self.layoutIfNeeded()

                    }, completion: { (finished) -> Void in
                        
                        if let actionView = self.actionViews[self.swipeDirection], let action = self.actions[self.swipeDirection] where actionView.shouldTrigger {
                           
                            action.didTriggerBlock?(swipeDirection:self.swipeDirection)
                        }
                })
            
            default:
                break
        }
    }
    
    private func updatePosition(translation:CGPoint){
        
        if horizontalSwipeDirections.contains(swipeDirection){
            let elasticTranslation = elasticPoint(Float(translation.x), li: 44, lf: 100)
            contentView.center.x = contentView.frame.size.width/2 + CGFloat(elasticTranslation)
        }
        else {
            let elasticTranslation = elasticPoint(Float(translation.y), li: 44, lf: 100)
            contentView.center.y = contentView.frame.size.height/2 + CGFloat(elasticTranslation)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        if let actionView = actionViews[swipeDirection] {
            if actionView.isActive {
                actionView.shouldTrigger = true
            }
            else {
                actionView.shouldTrigger = false
            }
        }
        
    }
    
    private func swipeDirectionForTranslation(translation:CGPoint, velocity: CGPoint) -> PanGestureViewSwipeDirection{

        if velocity.x == 0 && velocity.y == 0 {
            return .None
        }
        
        var isHorizontal: Bool = false
        if abs(velocity.x) > abs(velocity.y) {
            
            isHorizontal = true
            
        }
        if isHorizontal {
            if translation.x > 0 {
                return .Right
            }
            return .Left
        }
        
        if translation.y > 0 {
            return .Down
        }
        
        return .Up
    }
    
    func elasticPoint(x: Float, li: Float, lf: Float) -> Float {
        let π = Float(M_PI)

        if (fabs(x) >= fabs(li)) {
            return atanf(tanf((π*li)/(2*lf))*(x/li))*(2*lf/π)
        } else {
            return x
        }
    }
    
    
}

let kMinimumTranslation: CGFloat = 30
class PanGestureActionView: UIView {
    var imageView: UIImageView!
    var action: PanGestureAction!
    var isActive:Bool = false
    var shouldTrigger:Bool = false
    
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    convenience init(frame: CGRect, action:PanGestureAction ) {
        self.init(frame:frame)
        self.action = action
        setupView()

    }
    
    private func setupView(){
        imageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        imageView.backgroundColor = UIColor.blackColor()
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        self.backgroundColor = action.backgroundColor
        setupConstraints()
        
    }
    
    private func setupConstraints(){
        let views = ["imageView":imageView]
        
        let orientation1 = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? "H" : "V"
        let orientation2 = (orientation1 == "H") ? "V" : "H"
        
        
        let hConstraintString = "\(orientation1):|-(0@250)-[imageView(<=44)]-(0@250)-|"
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(hConstraintString, options: [], metrics: [:], views: views)
        self.addConstraints(hConstraints)
        
        let vConstraintString = "\(orientation2):[imageView(44)]"
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vConstraintString, options: [], metrics: [:], views: views)
        self.addConstraints(vConstraints)
        
        let hCenterConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        hCenterConstraint.priority = 1000
        self.addConstraint(hCenterConstraint)
        
        let vCenterConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(vCenterConstraint)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.frame.size.width : self.frame.size.height
        let imageViewLength = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.imageView.frame.size.width : self.imageView.frame.size.height
        
        if length > imageViewLength {
            let origin = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.bounds.origin.x : self.bounds.origin.y
            let imageViewOrigin = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.imageView.frame.origin.x : self.imageView.frame.origin.y
            imageView.alpha = (origin + imageViewOrigin)/kMinimumTranslation
            isActive = true
        }
        else {
            imageView.alpha = 0
            isActive = false
        }
        
    }
}