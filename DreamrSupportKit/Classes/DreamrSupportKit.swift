
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

/**
 Defines a Protocol to be Implemented on a UIViewControl
 - func presentSupportKit:                  Used to present support modal with SupportType modifers.
 */

let podBundle = Bundle(identifier: "org.cocoapods.DreamrSupportKit")

public enum SupportType {
    case Reminder
    case Request
}

public protocol SupportKitDelegate: class {
    func supportKitDidComplete()
}

public protocol SupportKitProtocol: SupportKitDelegate {
    func presentSupportKit(withType type:SupportType, withModifiers modifiers:KitModifiers, delegate: SupportKitDelegate?)
}

public extension SupportKitProtocol where Self: UIViewController {
    func presentSupportKit(withType type:SupportType, withModifiers modifiers:KitModifiers, delegate: SupportKitDelegate?) {
        let support = SupportVC(withType: type, withModifiers: modifiers, delegate: delegate)
        support.modalPresentationStyle = .overFullScreen
        self.present(support, animated: false, completion: nil)
    }
}
