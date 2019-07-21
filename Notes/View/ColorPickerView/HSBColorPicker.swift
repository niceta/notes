//
//  ColorPicker.swift
//  Notes
//
//  Created by n.kuznetsov on 15/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

public protocol HSBColorPickerDelegate: NSObjectProtocol {
    func HSBColorColorPickerTouched(sender: HSBColorPicker,
                                    color: UIColor,
                                    point: CGPoint,
                                    state: UIGestureRecognizer.State)
}

@IBDesignable
public class HSBColorPicker: UIView {
    
    let stepCount: CGFloat = 256.0
    
    weak public var delegate: HSBColorPickerDelegate?
    
    var brightness: CGFloat = 1.0
    var alphaValue: CGFloat = 1.0
    var dy = CGFloat()
    var dx = CGFloat()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let yMax = rect.height
        let xMax = rect.width
        
        dy = yMax / stepCount
        dx = xMax / stepCount
        let ddy = dy * 0.5
        let ddx = dx * 0.5
        
        for y: CGFloat in stride(from: 0, to: yMax, by: dy) {
            for x: CGFloat in stride(from: 0, to: xMax, by: dx) {
                let color = UIColor(hue: x/xMax,
                                    saturation: y/yMax,
                                    brightness: brightness,
                                    alpha: alphaValue)
                context!.setFillColor(color.cgColor)
                context!.fill( CGRect(x: x, y: y, width: dx + ddx, height: dy + ddy) )
            }
        }
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: dx * CGFloat( Int(point.x / dx) ),
                                   y: dy * CGFloat( Int(point.y / dy) ))
        let hue = roundedPoint.x / self.bounds.width
        let saturation = roundedPoint.y / self.bounds.height
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaValue)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        let xPos = hue * self.bounds.width
        let yPos = hue * self.bounds.height
        return CGPoint(x: xPos, y: yPos)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            let point = gestureRecognizer.location(in: self)
            let color = getColorAtPoint(point: point)
            self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state: gestureRecognizer.state)
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
}
