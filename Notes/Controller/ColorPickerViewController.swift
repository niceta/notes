//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 21/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var colorPicker: HSBColorPicker!
    
    weak var delegate: EditNoteViewController?
    var color: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let thinWidth = preview.bounds.width / 100
        let mediumRadius = preview.bounds.width / 10
        
        preview.layer.borderColor = UIColor.lightGray.cgColor
        preview.layer.borderWidth = thinWidth
        preview.layer.cornerRadius = mediumRadius
        
        colorPicker.layer.borderColor = UIColor.lightGray.cgColor
        colorPicker.layer.borderWidth = thinWidth
        colorPicker.layer.cornerRadius = mediumRadius
        
        colorPicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditNoteViewController, segue.identifier == "backToEditNoteSegue" {
            controller.anyColorView.backgroundColor = color
            controller.anyColorView.layer.sublayers = nil
            controller.whiteColorView.isShapeHidden = true
            controller.redColorView.isShapeHidden = true
            controller.greenColorView.isShapeHidden = true
            controller.anyColorView.isShapeHidden = false
            controller.color = color
            controller.didReturnFromColorPicker = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ColorPickerViewController: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        preview.backgroundColor = color
        self.color = color
    }
}
