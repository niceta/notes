//
//  ViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 17/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var whiteColorView: ColorSquareView!
    @IBOutlet weak var redColorView: ColorSquareView!
    @IBOutlet weak var greenColorView: ColorSquareView!
    @IBOutlet weak var anyColorView: ColorSquareView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePickerView: DatePickerView!
    
    @IBAction func whiteColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = false
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = true
    }
    
    @IBAction func redColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = false
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = true
    }
    
    @IBAction func greenColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = false
        anyColorView.isShapeHidden = true
    }
    
    @IBAction func anyColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = false
    }
    
    private var screenFrame = UIScreen.main.bounds
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textField.delegate = self
        tapOnViewAndCloseKeyboard()
        initDatePicker()
        
        whiteColorView.layer.borderWidth = 1
        whiteColorView.layer.borderColor = UIColor.black.cgColor
        
        redColorView.layer.borderWidth = 1
        redColorView.layer.borderColor = UIColor.black.cgColor

        greenColorView.layer.borderWidth = 1
        greenColorView.layer.borderColor = UIColor.black.cgColor
        
        anyColorView.layer.borderWidth = 1
        anyColorView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func initDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognier:)))
        view.addGestureRecognizer(tapGesture)
        datePickerView.dateFieldView.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognier: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        datePickerView.dateFieldView.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func tapOnViewAndCloseKeyboard() {
        let tapOnView = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tapOnView.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnView)
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        var frame = self.view.frame
        screenFrame = UIScreen.main.bounds
        
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            if frame.height + keyboardFrame.height > screenFrame.height {
                let delta = screenFrame.height - keyboardFrame.height
                frame = CGRect(x: frame.origin.x, y: frame.origin.y,
                               width: frame.width, height: delta)
            }
        } else if frame.height < screenFrame.height {
            frame = screenFrame
        }
        self.view.frame = frame
    }
}
