//
//  ViewController.swift
//  AnimatedSettingsView
//
//  Created by cr0ss on 14.11.16.
//  Copyright © 2016 Kayos UG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet internal weak var settingsSelectionView1: LeftDetailSettingsSelectionView!
    @IBOutlet internal weak var settingsSelectionView2: RightDetailSettingsSelectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.settingsSelectionView1.setup(withBackgroundColor: .init(red: 229.0/255.0, green: 27.0/255.0, blue: 86.0/255.0, alpha: 1.0), invertTitleColor: false)
        self.settingsSelectionView2.setup(withBackgroundColor: .init(red: 0.0/255.0, green: 137.0/255.0, blue: 255.0/255.0, alpha: 1.0), invertTitleColor: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

