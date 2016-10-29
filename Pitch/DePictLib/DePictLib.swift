//
//  DePictLib.swift
//  DePictLib
//
//  Created by David Cairns on 4/10/15.
//  Copyright (c) 2015 David Cairns. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

///: Drawing
private func CreateDrawingContext(size: CGSize) -> CGContext {
	let bitsPerComponent = 8
	let numComponents = 4
	let bytesPerRow = (bitsPerComponent / 8) * numComponents * Int(size.width)
	let colorspace = CGColorSpaceCreateDeviceRGB()
	let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
	return CGBitmapContextCreate(nil, Int(size.width), Int(size.height), bitsPerComponent, bytesPerRow, colorspace, bitmapInfo.rawValue)!
}

public func Draw(width width: Int, height: Int, colorer: Colorer, context: CGContext? = UIGraphicsGetCurrentContext()) -> CGContext? {
	colorer.build(context!)
	return context
}

public func Draw(colorer: Colorer, context: CGContext? = UIGraphicsGetCurrentContext()) -> CGContext? {
	return Draw(width: Int(colorer.width), height: Int(colorer.height), colorer: colorer)
}

public func Draw(shape: Shape, context: CGContext? = UIGraphicsGetCurrentContext()) -> CGContext? {
	return Draw(Outlined(color: Black, shape: shape))
}
