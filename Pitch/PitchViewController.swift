//
//  PitchViewController.swift
//  Pitch
//
//  Created by Kamil Badyla on 29/10/16.
//  Copyright © 2016 Realtime Games LTD. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

class PitchViewController: UIViewController {
    let actionIndicator = MutableProperty<PlayerActionIndicator>(PlayerActionIndicator())
    let actions = MutableProperty<[PlayerAction]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
