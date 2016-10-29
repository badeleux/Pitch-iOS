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
import EasyPeasy

class PitchViewController: UIViewController {
    let actionVisualisation = MutableProperty<PlayerActionViewModel?>(nil)
    @IBOutlet weak var actionVisualisationView: ActionVisualisationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionVisualisationView.actionVisualisationVM <~ self.actionVisualisation.producer
    }
    
}
