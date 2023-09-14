//
//  ParallelogramView.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import UIKit

@IBDesignable
class ParallelogramView: UIView {
    @IBInspectable var offset:    CGFloat = 9 { didSet { setNeedsDisplay() } }
    @IBInspectable var fillColor: UIColor = .white { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX + offset, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - offset, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.close()
        fillColor.setFill()
        path.fill()
    }
}

