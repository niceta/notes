//
//  datePickerView.swift
//  Notes
//
//  Created by n.kuznetsov on 14/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

@IBDesignable
class DatePickerView: UIView {
    
    @IBOutlet weak var dateFieldView: UITextField!
    @IBOutlet weak var switchView: UISwitch!
    @IBAction func switchStateChanged(_ sender: UISwitch) {
        dateFieldView.isEnabled = switchView.isOn
        dateFieldView.isHidden = !switchView.isOn
        if switchView.isOn {
            dateFieldView.becomeFirstResponder()
        }
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
        let nib = UINib(nibName: "DatePickerView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}
