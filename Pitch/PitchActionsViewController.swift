//
//  PitchActionsViewController.swift
//  Pitch
//
//  Created by Kamil Badyla on 29/10/16.
//  Copyright © 2016 Realtime Games LTD. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import CocoaLumberjackSwift
import EasyPeasy
import Rex
import Result
import ObjectMapper

class PitchActionsViewController: UIViewController {
    @IBOutlet weak var actionsTableView: UITableView!
    
    let actions = MutableProperty<[PlayerAction]>([])
    var pitchViewController: PitchViewController!
    let actionIndicator = MutableProperty<PlayerActionIndicator>(PlayerActionIndicator())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupIndicator()
        
        self.actions <~ self.fetchActions()
        self.actions.producer.on(next: { [weak self] (actions: [PlayerAction]) in
            self?.actionsTableView.reloadData()
        }).start()
        
        self.pitchViewController.actions <~ self.actions.producer
        self.pitchViewController.actionIndicator <~ self.actionIndicator
        
        self.actionIndicator <~ self.rac_signalForSelector(#selector(PitchActionsViewController.scrollViewDidScroll(_:)))
        .toSignalProducer()
        .map { (object: AnyObject?) -> UIScrollView? in
            if let tuple = object as? RACTuple, scrollView = tuple.first as? UIScrollView {
                return scrollView
            }
            return nil
        }
        .ignoreNil()
        .debounce(0.01, onScheduler: QueueScheduler.mainQueueScheduler)
        .map({ [weak self] (sv: UIScrollView) -> PlayerActionIndicator in
            let indicator = PlayerActionIndicator.indicator(self?.position(forContentOffset: sv.contentOffset) ?? 0.0)
            print("Action index: " + indicator.actionIndex.description + "Progress: " + indicator.progress.description)
            return indicator
        })
        .ignoreError()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Pitch" {
            self.pitchViewController = segue.destinationViewController as! PitchViewController
        }
    }
    
    func setupIndicator() {
        let indicator = UIView()
        indicator.backgroundColor = UIColor.blackColor()
        self.view.addSubview(indicator)
        indicator <- [
            Right(0),
            Height(3),
            Width(20),
            Top((self.actionsTableView.tableHeaderView?.frame.size.height ?? 0) + self.actionsTableView.frame.origin.y)
        ]
    }
    
    func fetchActions() -> SignalProducer<[PlayerAction], NoError> {
        return SignalProducer { observer, disposable in
            let oJsonString = try? String(contentsOfFile: NSBundle.mainBundle().pathForResource("sample", ofType: "json")!)
            if let jsonString = oJsonString {
                let mapper = Mapper<PlayerAction>()
                let actions = mapper.mapArray(jsonString) ?? []
                observer.sendNext(actions)
            }
            observer.sendCompleted()
        }
    }
}

extension PitchActionsViewController: UIScrollViewDelegate {
    
//    static let ActionCellHeight: Double = 44.0
    
    func position(forContentOffset contentOffset: CGPoint) -> Double {
        return Double(contentOffset.y) / 44.0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) { }
}

extension PitchActionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let action = self.actions.value[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ActionCell")
        cell?.textLabel?.text = action.action! + " - " + action.playerName!
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
}
