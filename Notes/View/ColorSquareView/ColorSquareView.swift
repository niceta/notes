//
//  ColorSquareView.swift
//  Notes
//
//  Created by n.kuznetsov on 12/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

@IBDesignable
class ColorSquareView: UIView {
    @IBInspectable var shapeColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var cirlcePath: UIBezierPath?
    private var checkMarkPath: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            cirlcePath = nil
            checkMarkPath = nil
            return
        }
        shapeColor.setFill()
        
        let cirlceSize: CGFloat = 15
        let circleIndent: CGFloat = 5
        let cirlceX = bounds.maxX - circleIndent - cirlceSize
        let circleY = circleIndent
        
        let path = UIBezierPath(ovalIn: CGRect(x: cirlceX,
                                               y: circleY,
                                               width: cirlceSize,
                                               height: cirlceSize))
        
        path.stroke()
        cirlcePath = path
        
        checkMarkPath = UIBezierPath()
        checkMarkPath?.lineWidth = 1
        checkMarkPath?.move(to: CGPoint(x: cirlceX + 0.375 * cirlceSize, y: circleY + 0.5 * cirlceSize))
        checkMarkPath?.addLine(to: CGPoint(x: cirlceX + 0.5 * cirlceSize, y: circleY + 0.75 * cirlceSize))
        checkMarkPath?.addLine(to: CGPoint(x: cirlceX + 0.75 * cirlceSize, y: circleY + 0.25 * cirlceSize))
        checkMarkPath?.stroke()
    }
}
