
// InfinityEngine
//
// Copyright Ryan Willis (c) 2016
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import QuartzCore

public class ZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presentDuration:TimeInterval!
    var dismissDuration:TimeInterval!
    var isBeingPresented:Bool!
    var cellDisplayPoint:CGPoint!
    
    var transitionContext:UIViewControllerContextTransitioning!
    
    override init() {
        super.init()
        self.presentDuration = 0.4
        self.dismissDuration = 0.4
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        //Get the correct speed for dismissal/presentation
        return (self.isBeingPresented != nil) ? self.presentDuration : self.dismissDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if self.isBeingPresented == true {
            self.doPresentationAnimation(transitionContext: transitionContext)
        } else if self.isBeingPresented == false {
            self.doDismissAnimation(transitionContext: transitionContext)
        }
    }
    
    
    //MARK: - Custom Animation
    
    func doPresentationAnimation(transitionContext:UIViewControllerContextTransitioning) {
        let inView:UIView = transitionContext.containerView
        
        //The view we are going to
        let toViewController:UIViewController = transitionContext.viewController(forKey: .to)!
        toViewController.view.frame = inView.bounds

        //The view we are coming from
        let fromViewController:UIViewController = transitionContext.viewController(forKey: .from)!
        
        // Setup Start Points
        toViewController.view.alpha = 0.0
        //Set Larger so it can flow in
        let zoomInTransform:CATransform3D = self.doThirdTransformWithView(view: toViewController.view)
        toViewController.view.layer.transform = zoomInTransform
        
        //Add the subview on top ready for animation
        inView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        let duration:CFTimeInterval = self.presentDuration
        //var halfDuration:CFTimeInterval = duration / 2
        
        //FromViewController Transform out
        let transform2:CATransform3D = self.doSecondTransformWithView(view: fromViewController.view)
        
        UIView.animate(withDuration: duration * 2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [], animations: { () -> Void in
            //Zoom Out
            fromViewController.view.layer.transform = transform2
            fromViewController.view.alpha = 0.0
            
            //Bring the next view into frame
            toViewController.view.layer.transform = CATransform3DIdentity
            toViewController.view.alpha = 1.0
            
            }) { (finished) -> Void in
                self.transitionContext.completeTransition(true)
        }
    }
    
    func doDismissAnimation(transitionContext:UIViewControllerContextTransitioning) {
        
        let inView:UIView = transitionContext.containerView
        
        //The view we are going to
        let toViewController:UIViewController = transitionContext.viewController(forKey: .to)!
        //The view we are coming from
        let fromViewController:UIViewController = transitionContext.viewController(forKey: .from)!
        
        //Setup Starting Values
        //toViewController.view.frame = inView.frame
        let scale:CATransform3D = CATransform3DIdentity
        toViewController.view.layer.transform = CATransform3DScale(scale, 0.9, 0.9, 1.0)
        toViewController.view.alpha = 0.0;
        
        
        //toViewController.view.alpha = 0.0
        //toViewController.view.transform = CGAffineTransformMakeScale(0.7, 0.7)
        //toViewController.view.center = CGPointMake(inView.layer.frame.size.width - 220.0, inView.layer.frame.size.height)
        //Make the view background clear, otherwise it will not show behind animation properly
        //toViewController.view.backgroundColor = UIColor.clearColor()
        
        //Add the subview on top ready for animation
        inView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        let duration:CFTimeInterval = self.dismissDuration
        UIView.animate(withDuration: duration * 2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: [], animations: { () -> Void in
            
            fromViewController.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            fromViewController.view.alpha = 0.0
//            
            toViewController.view.alpha = 1.0
            toViewController.view.layer.transform = CATransform3DScale(scale, 1.0 , 1.0, 1.0)
            //toViewController.view.frame = inView.frame
            
            }) { (finished) -> Void in
                self.transitionContext.completeTransition(true)
        }
    }
    
    func doFirstTransform() -> CATransform3D {
        var t1:CATransform3D = CATransform3DIdentity
        t1.m34 = 1.0 / -900
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1)
        
        let angle:CGFloat = 15.0 * CGFloat(M_PI) / 180.0
        t1 = CATransform3DRotate(t1, angle, 1.0, 0.0, 0.0)
        return t1
    }
    
    func doSecondTransformWithView(view:UIView) -> CATransform3D {
        var t2:CATransform3D = CATransform3DIdentity
        t2.m34 = self.doFirstTransform().m34
        t2 = CATransform3DTranslate(t2, 0, 0, 0)
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1)
        return t2
    }
    
    func doThirdTransformWithView(view:UIView) -> CATransform3D {
        var t3:CATransform3D = CATransform3DIdentity
        t3.m34 = self.doFirstTransform().m34
        t3 = CATransform3DTranslate(t3, 0, view.frame.size.height * -0.08, 0)
        t3 = CATransform3DScale(t3, 1.3, 1.3, 1)
        return t3
    }
    
    func transfromToView(view:UIView) -> CATransform3D {
        var t3:CATransform3D = CATransform3DIdentity
        t3.m34 = self.doFirstTransform().m34
        t3 = CATransform3DTranslate(t3, 0, view.frame.size.height * -0.08, 0)
        t3 = CATransform3DScale(t3, 1.0, 1.0, 1)
        return t3
    }
}
