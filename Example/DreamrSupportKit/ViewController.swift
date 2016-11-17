//
//  ViewController.swift
//  DreamrSupportKit
//
//  Created by Ryan on 06/24/2016.
//  Copyright (c) 2016 Ryan. All rights reserved.
//

import UIKit
import DreamrSupportKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showSupport() {
        let mods = KitModifiers(
            fontType: nil,
            primaryColour: UIColor.purple,
            secondaryColour: UIColor.orange,
            withEmail: "24",
            withAppUrl: "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4"
        )
        self.presentSupportKit(withType: .Request, withModifiers: mods, delegate: self)
    }
    
}

extension ViewController: SupportKitProtocol {
    func supportKitDidComplete() {
        
    }
}
