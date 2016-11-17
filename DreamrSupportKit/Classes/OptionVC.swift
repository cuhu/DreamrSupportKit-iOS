
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

enum OptionType {
    case TellUsMore
    case Thanks
    case Reminder
}

public class OptionVC: UIViewController {
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var positiveBtn: UIButton!
    @IBOutlet weak var negativeBtn: UIButton!
    @IBOutlet weak var leftCS: NSLayoutConstraint!
    @IBOutlet weak var rightCS: NSLayoutConstraint!
    
    var type: OptionType!
    var modifiers: KitModifiers
    
    init(withType type:OptionType, withModifiers modifiers:KitModifiers) {
        self.type = type
        self.modifiers = modifiers
        super.init(nibName: "OptionVC", bundle: podBundle)
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setApperance()
        
        self.containerView.startColor = self.modifiers.primaryColour
        self.containerView.endColor = self.modifiers.secondaryColour
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 8.0
        
        if UIScreen.main.sizeType == .iPhone4 || UIScreen.main.sizeType == .iPhone5 {
            self.leftCS.constant = 14.0
            self.rightCS.constant = 14.0
            self.view.layoutIfNeeded()
        }
        
        // Layout Font
        if let fontName = self.modifiers.fontName {
            self.titleLbl.font = UIFont(name: fontName, size: 28.0)
            self.descriptionLbl.font = UIFont(name: fontName, size: 15.0)
            self.positiveBtn.titleLabel?.font = UIFont(name: fontName, size: 15.0)
            self.negativeBtn.titleLabel?.font = UIFont(name: fontName, size: 15.0)
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI
    
    func setApperance() {
        
        switch self.type! {
        case .TellUsMore:
            
            self.imageView.image = UIImage(named: "comments", in: podBundle, compatibleWith: nil)
            self.titleLbl.text = "Tell us more"
            self.descriptionLbl.text = "So far using our app, is your experience great, or not so good?"
            self.positiveBtn.setTitle("Great!", for: .normal)
            self.negativeBtn.setTitle("Not good", for: .normal)
            
        case .Thanks:
            self.imageView.image = UIImage(named: "happy", in: podBundle, compatibleWith: nil)
            self.titleLbl.text = "Thanks so much!"
            self.descriptionLbl.text = "We're glad you've enjoyed your experience so far, want to leave feedback on the App Store?"
            self.positiveBtn.setTitle("Yes", for: .normal)
            self.negativeBtn.setTitle("Not now", for: .normal)
            
        case .Reminder:
            self.imageView.image = UIImage(named: "comments", in: podBundle, compatibleWith: nil)
            self.titleLbl.text = "Help us improve"
            self.descriptionLbl.text = "How is your experience of using our app so far?"
            self.positiveBtn.setTitle("Great!", for: .normal)
            self.negativeBtn.setTitle("Not good", for: .normal)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func negative() {
        
        switch self.type! {
        case .TellUsMore, .Reminder:
            self.navigationController?.pushViewController(FeedbackVC(withType: .Improve, withModifiers: self.modifiers), animated: true)
        case .Thanks:
            if let parent = self.parent?.parent as? SupportVC {
                parent.close(self)
            }
        }
    }
    
    @IBAction func positive() {
        switch self.type! {
        case .TellUsMore, .Reminder:
            self.navigationController?.pushViewController(OptionVC(withType: .Thanks, withModifiers: self.modifiers), animated: true)
        case .Thanks:
            UIApplication.shared.openURL(NSURL(string: self.modifiers.appStoreURL)! as URL)
            self.navigationController?.pushViewController(ThanksVC(withModifiers: self.modifiers), animated: true)
        }
    }
}
