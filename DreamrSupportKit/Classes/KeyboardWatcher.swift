
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

protocol KeyboardHeightChangeDelegate {
    func keyboardWillHideWithDuration(duration: Double)
    func keyboardHeightWillChangeTo(height: CGFloat, withDuration duration: Double)
}

class KeyboardWatcher: NSObject {
    
    // MARK: Members
    private var delegate: KeyboardHeightChangeDelegate?
    
    // MARK: Initialisation
    init(delegate: KeyboardHeightChangeDelegate?) {
        super.init()
        self.delegate = delegate
        self.registerKeyboardNotifications()
    }
    
    // MARK: Deinitialisation
    deinit {
        self.unregisterKeyboardNotifications()
        self.delegate = nil
    }
    
    // MARK: Register / Unregister Notifications
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(KeyboardWatcher.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(KeyboardWatcher.keyboardWillChange(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    // MARK: Handling
    func keyboardWillHide(_ aNotification: NSNotification) {
        let userInfo = aNotification.userInfo!
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.delegate?.keyboardWillHideWithDuration(duration: animationDuration)
    }
    
    func keyboardWillChange(_ aNotification: NSNotification) {
        let userInfo = aNotification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardHeight = keyboardSize!.height
        self.delegate?.keyboardHeightWillChangeTo(height: keyboardHeight, withDuration: animationDuration)
    }

}
