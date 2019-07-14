//
//  ColorPickerView.swift
//  Notes
//
//  Created by n.kuznetsov on 15/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit


class ColorPickerView: UIView {    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        self.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        let xib = loadViewFromXib()
        xib.frame = self.bounds
        xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xib)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}
