//
//  PlayerAction.swift
//  Pitch
//
//  Created by Kamil Badyla on 29/10/16.
//  Copyright © 2016 Realtime Games LTD. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

struct PlayerActionViewModel {
    let origin: PlayerAction
    let destination: PlayerAction
    let progress: CGFloat
    
    func originPlayer(inRect canvasRect: CGRect) -> Colorer {
        let center = origin.coordinates.translate(toCanvasCoordinates: canvasRect.size)
        return Filled(color: Black, shape: Circle(centerX: Int(center.x), Y: Int(center.y), radius: 10))
    }
    
    func destPlayer(inRect canvasRect: CGRect) -> Colorer {
        let center = destination.coordinates.translate(toCanvasCoordinates: canvasRect.size)
        return Filled(color: White, shape: Circle(centerX: Int(center.x), Y: Int(center.y), radius: 10))
    }
    
    func arrowWithBall(inRect canvasRect: CGRect) -> Colorer {
        let lineOrigin = origin.coordinates.translate(toCanvasCoordinates: canvasRect.size)
        let lineDest = CGPoint.between(between: lineOrigin,
                                         and: destination.coordinates.translate(toCanvasCoordinates: canvasRect.size),
                                         atPart: self.progress)
        return Outlined(color: Blue, shape: Line([lineOrigin, lineDest].map { $0.toPoint }))
    }
}

extension CGPoint {
    func translate(toCanvasCoordinates canvasSize: CGSize) -> CGPoint {
        let xFactor = self.x / 100.0
        let yFactor = self.y / 100.0
        return CGPointMake(xFactor * canvasSize.width, yFactor * canvasSize.height)
    }
    
    static func between(between a: CGPoint, and b: CGPoint, atPart progress: CGFloat) -> CGPoint {
        return CGPointMake(a.x + progress * (b.x - a.x), a.y + progress * (b.y - a.y))
    }
    
    var toPoint: Point {
        return Point(x: Int(self.x), y: Int(self.y))
    }
}


struct PlayerActionIndicator {
    
    static func indicator(position: Double) -> PlayerActionIndicator {
        let p = max(0.0, position)
        let index = Int(p)
        let progress = p - Double(index)
        return PlayerActionIndicator(actionIndex: index, progress: progress)
    }
    
    
    var actionIndex: Int = 0
    var progress: Double = 0 // 0->1
    
}

public class PlayerAction: NSObject, Mappable, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kPlayerActionActionKey: String = "action"
    internal let kPlayerActionMinKey: String = "min"
    internal let kPlayerActionTimestampKey: String = "timestamp"
    internal let kPlayerActionXKey: String = "x"
    internal let kPlayerActionPlayerIdKey: String = "player_id"
    internal let kPlayerActionTeamIdKey: String = "team_id"
    internal let kPlayerActionYKey: String = "y"
    internal let kPlayerActionPlayerNameKey: String = "player_name"
    internal let kPlayerActionHomeKey: String = "home"
    
    
    // MARK: Properties
    public var action: String?
    public var min: Int?
    public var timestamp: String?
    public var x: Int?
    public var playerId: Int?
    public var teamId: Int?
    public var y: Float?
    public var playerName: String?
    public var home: Bool = false
    public var coordinates: CGPoint {
        return CGPointMake(CGFloat(self.x ?? 0.0), CGFloat(self.y ?? 0.0))
    }
    
    
    
    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(_ map: Map){
        
    }
    
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        action <- map[kPlayerActionActionKey]
        min <- map[kPlayerActionMinKey]
        timestamp <- map[kPlayerActionTimestampKey]
        x <- map[kPlayerActionXKey]
        playerId <- map[kPlayerActionPlayerIdKey]
        teamId <- map[kPlayerActionTeamIdKey]
        y <- map[kPlayerActionYKey]
        playerName <- map[kPlayerActionPlayerNameKey]
        home <- map[kPlayerActionHomeKey]
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if action != nil {
            dictionary.updateValue(action!, forKey: kPlayerActionActionKey)
        }
        if min != nil {
            dictionary.updateValue(min!, forKey: kPlayerActionMinKey)
        }
        if timestamp != nil {
            dictionary.updateValue(timestamp!, forKey: kPlayerActionTimestampKey)
        }
        if x != nil {
            dictionary.updateValue(x!, forKey: kPlayerActionXKey)
        }
        if playerId != nil {
            dictionary.updateValue(playerId!, forKey: kPlayerActionPlayerIdKey)
        }
        if teamId != nil {
            dictionary.updateValue(teamId!, forKey: kPlayerActionTeamIdKey)
        }
        if y != nil {
            dictionary.updateValue(y!, forKey: kPlayerActionYKey)
        }
        if playerName != nil {
            dictionary.updateValue(playerName!, forKey: kPlayerActionPlayerNameKey)
        }
        dictionary.updateValue(home, forKey: kPlayerActionHomeKey)
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.action = aDecoder.decodeObjectForKey(kPlayerActionActionKey) as? String
        self.min = aDecoder.decodeObjectForKey(kPlayerActionMinKey) as? Int
        self.timestamp = aDecoder.decodeObjectForKey(kPlayerActionTimestampKey) as? String
        self.x = aDecoder.decodeObjectForKey(kPlayerActionXKey) as? Int
        self.playerId = aDecoder.decodeObjectForKey(kPlayerActionPlayerIdKey) as? Int
        self.teamId = aDecoder.decodeObjectForKey(kPlayerActionTeamIdKey) as? Int
        self.y = aDecoder.decodeObjectForKey(kPlayerActionYKey) as? Float
        self.playerName = aDecoder.decodeObjectForKey(kPlayerActionPlayerNameKey) as? String
        self.home = aDecoder.decodeBoolForKey(kPlayerActionHomeKey)
        
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(action, forKey: kPlayerActionActionKey)
        aCoder.encodeObject(min, forKey: kPlayerActionMinKey)
        aCoder.encodeObject(timestamp, forKey: kPlayerActionTimestampKey)
        aCoder.encodeObject(x, forKey: kPlayerActionXKey)
        aCoder.encodeObject(playerId, forKey: kPlayerActionPlayerIdKey)
        aCoder.encodeObject(teamId, forKey: kPlayerActionTeamIdKey)
        aCoder.encodeObject(y, forKey: kPlayerActionYKey)
        aCoder.encodeObject(playerName, forKey: kPlayerActionPlayerNameKey)
        aCoder.encodeBool(home, forKey: kPlayerActionHomeKey)
        
    }
    
}
