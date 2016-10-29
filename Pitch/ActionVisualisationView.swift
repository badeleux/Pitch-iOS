//
//  ActionVisualisationView.swift
//  Pitch
//
//  Created by Kamil Badyla on 29/10/16.
//  Copyright © 2016 Realtime Games LTD. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

class ActionVisualisationView: UIView {
    let actionVisualisationVM = MutableProperty<PlayerActionViewModel?>(nil)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.actionVisualisationVM.producer.ignoreNil().on(next: { (player: PlayerActionViewModel?) in
            self.setNeedsDisplay()
        }).start()
    }
    
    override func drawRect(rect: CGRect) {
        if let viewModel = self.actionVisualisationVM.value {
            Draw(viewModel.originPlayer(inRect: rect) + viewModel.arrowWithBall(inRect: rect) + viewModel.destPlayer(inRect: rect))
        }
    }
    
    
}
