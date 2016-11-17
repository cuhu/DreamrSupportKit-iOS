
// InfinityEngine
//
// Copyright Dreamr (c) 2016
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

protocol SupportDelegate {
    func supportDidCancel()
}

public class SupportVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var type:SupportType!
    var modifiers:KitModifiers!
    var animator:ZoomAnimationController!
    var delegate:SupportKitDelegate?
    
    init(withType type:SupportType, withModifiers mods: KitModifiers, delegate:SupportKitDelegate?) {
        self.type = type
        self.modifiers = mods
        self.delegate = delegate
        super.init(nibName: "SupportVC", bundle: podBundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // New instance of our animation
        self.animator = ZoomAnimationController()
        self.addController(withType: self.type)
        self.containerView.alpha = 0.0
        self.backgroundView.alpha = 0.0
        self.closeBtn.alpha = 0.0
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.entranceAnimation()
    }
    
    // MARK: - Add Child Controller
    
    func addController(withType type:SupportType) {
        
        switch type {
        case .Reminder:
            
            let controller = OptionVC(withType: .Reminder, withModifiers: self.modifiers)
            let reminder = SupportNavigationController(rootViewController: controller)
            self.addChildViewController(reminder)
            reminder.didMove(toParentViewController: self)
            reminder.view.frame = self.containerView.bounds
            self.containerView.insertSubview(reminder.view, at: 0)
            
        case .Request:
            
            let controller = WelcomeVC(withModifiers: self.modifiers)
            let welcome = SupportNavigationController(rootViewController: controller)
            self.addChildViewController(welcome)
            welcome.didMove(toParentViewController: self)
            welcome.view.frame = self.containerView.bounds
            self.containerView.insertSubview(welcome.view, at: 0)
        }
    }
    
    // MARK: - Animations
    
    func entranceAnimation() {
        self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.closeBtn.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.containerView.alpha = 1.0
        self.closeBtn.alpha = 1.0
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
            self.closeBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1.0
        }
    }
    
    func exitAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.containerView.alpha = 0.0
            self.closeBtn.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.backgroundView.alpha = 0.0
        }) { (complete) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func close(_ sender: AnyObject) {
        self.exitAnimation()
        self.delegate?.supportKitDidComplete()
    }
}

