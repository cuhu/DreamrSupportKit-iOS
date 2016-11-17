
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
import MessageUI

enum FeedbackType:String {
    case Problem = "Problem"
    case Improve = "Improvement"
    case Feedback = "Feedback"
}

public class FeedbackVC: UIViewController {
    
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var twoImagesView: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var leftCS: NSLayoutConstraint!
    @IBOutlet weak var rightCS: NSLayoutConstraint!
    @IBOutlet weak var heightCS: NSLayoutConstraint!
    @IBOutlet weak var yAxisCS: NSLayoutConstraint!
    @IBOutlet weak var textViewTopCS: NSLayoutConstraint!
    
    var keyboardWatcher:KeyboardWatcher!
    var type:FeedbackType!
    var modifers:KitModifiers!
    
    init(withType type:FeedbackType, withModifiers mods:KitModifiers) {
        self.type = type
        self.modifers = mods
        super.init(nibName: "FeedbackVC", bundle: podBundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setApperance()
        
        self.containerView.startColor = self.modifers.primaryColour
        self.containerView.endColor = self.modifers.secondaryColour
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 8.0
        
        if UIScreen.main.sizeType == .iPhone4 || UIScreen.main.sizeType == .iPhone5 {
            self.leftCS.constant = 14.0
            self.rightCS.constant = 14.0
            self.view.layoutIfNeeded()
        }
        
        // Layout Font
        if let fontName = self.modifers.fontName {
            self.titleLbl.font = UIFont(name: fontName, size: 28.0)
            self.descriptionLbl.font = UIFont(name: fontName, size: 15.0)
            self.doneBtn.titleLabel?.font = UIFont(name: fontName, size: 15.0)
            self.textView.font = UIFont(name: fontName, size: 15.0)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyboardWatcher = KeyboardWatcher(delegate: self)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.keyboardWatcher = nil
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup UI
    
    func setApperance() {
        switch self.type! {
        case .Problem:
            self.twoImagesView.isHidden = true
            self.imageView.image = UIImage(named: "problem", in: podBundle, compatibleWith: nil)
            self.titleLbl?.text = "Report a problem"
            self.descriptionLbl.text = "We're really keen to hear about your experience. Please tell us about your problem."
        case .Improve:
            self.twoImagesView.isHidden = true
            self.imageView.image = UIImage(named: "sad", in: podBundle, compatibleWith: nil)
            self.titleLbl?.text = "Aww no"
            self.descriptionLbl.text = "We're really sorry about your experience, please let us know how we can do better."
        case .Feedback:
            self.twoImagesView.isHidden = false
            self.imageView.image = nil
            self.titleLbl?.text = "Submit feedback"
            self.descriptionLbl.text = "We're really always keen to hear about your experience. Please tell us more."
        }
    }
    
    // MARK: - Device Information
    
    func getDeviceInfo() -> String {
        
        let systemVersion = "System Version: \(UIDevice.current.systemVersion) \n"
        let systemName = "System Name: \(UIDevice.current.name) \n"
        let modelName = "Model Name: \(UIDevice.current.modelName) \n"
        let model = "Model: \(UIDevice.current.model) \n"
        let battery = "Battery: \(UIDevice.current.batteryLevel) \n"
        let batteryStatus = "Battery Status: \(UIDevice.current.batteryState.rawValue) \n"
        let orientation = "Orientation: \(UIDevice.current.orientation) \n"
        let multitaskingSupported = "Multitasking Supported: \(UIDevice.current.isMultitaskingSupported) \n"
        let userInterfaceIdiom = "Interface Idiom \(UIDevice.current.userInterfaceIdiom) \n"
        let proximityMonitoring = "Proximity Monitoring \(UIDevice.current.proximityState) \n"
        let notificationsEnabled = "Notifications Enabled \(UIApplication.shared.isRegisteredForRemoteNotifications) \n"
        let versionNumber = "Version Number: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A") \n"
        let buildNumber = "Build Number: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A") \n"
        
        
        let spacer = "---------------------------------\n"
        
        let fullString = spacer + systemVersion + systemName + modelName + model + battery + batteryStatus + orientation +
        multitaskingSupported + userInterfaceIdiom + proximityMonitoring + notificationsEnabled + versionNumber + buildNumber + spacer
        
        return fullString
    }
    
    // MARK: - Mail
    
    @IBAction func done() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func cancel() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let messageText = self.textView.text + "\n\n\n\n\n" + self.getDeviceInfo()
        
        mailComposerVC.setToRecipients([self.modifers.email])
        mailComposerVC.setSubject(self.type.rawValue)
        mailComposerVC.setMessageBody(messageText, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
}

extension FeedbackVC: KeyboardHeightChangeDelegate {
    public func keyboardWillHideWithDuration(duration: Double) {}
    
    public func keyboardHeightWillChangeTo(height: CGFloat, withDuration duration: Double) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.layer.cornerRadius = 0.0
            self.leftCS.constant = 0.0
            self.rightCS.constant = 0.0
            self.heightCS.constant = self.view.bounds.height + 25 - height
            self.yAxisCS.constant = -height / 2 + 34
            self.view.layoutIfNeeded()
        }
        
        if UIScreen.main.sizeType == .iPhone4 || UIScreen.main.sizeType == .iPhone5 {
            self.titleLbl.isHidden = true
            self.descriptionLbl.isHidden = true
            self.twoImagesView.isHidden = true
            self.imageView.isHidden = true
            self.textViewTopCS.constant = 20.0
            self.view.layoutIfNeeded()
        }
    }
}

extension FeedbackVC:MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.containerView.alpha = 0.0
        self.view.endEditing(true)
        controller.dismiss(animated: true) {
            if result == MFMailComposeResult.sent {

                self.navigationController?.pushViewController(ThanksVC(withModifiers: self.modifers), animated: true)
            } else {
                self.textView.becomeFirstResponder()

                UIView.animate(withDuration: 0.3, animations: {
                    self.containerView.alpha = 1.0
                })
            }
        }
    }
}
