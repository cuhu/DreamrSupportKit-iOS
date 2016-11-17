
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

public class ThanksVC: UIViewController {
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var leftCS: NSLayoutConstraint!
    @IBOutlet weak var rightCS: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var modifers: KitModifiers!
    
    init(withModifiers modifiers:KitModifiers) {
        self.modifers = modifiers
        super.init(nibName: "ThanksVC", bundle: podBundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
