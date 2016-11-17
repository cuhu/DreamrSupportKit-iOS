//
//  ViewController.swift
//  DreamrSupportKit
//
//  Created by Ryan on 06/24/2016.
//  Copyright (c) 2016 Ryan. All rights reserved.
//

import UIKit
import DreamrSupportKit

class ViewController: UIViewController, SupportKitProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSupport() {
        
        let mods:KitModifiers = KitModifiers(fontType: nil, primaryColour: UIColor.purple,
            secondaryColour: UIColor.orange, withEmail: "24", withAppUrl: "itms://itunes.apple.com/de/app/x-gift/id839686104?mt=8&uo=4")
        
        self.presentSupportKit(withType: .Request, withModifiers: mods, delegate: self)
    }
    
    func supportKitDidComplete() {
       UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
}
