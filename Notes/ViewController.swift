//
//  ViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 17/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePickerView: DatePickerView!
    
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
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognier:)))
        view.addGestureRecognizer(tapGesture)
        datePickerView.dateFieldView.inputView = datePicker
        
//        whiteSquare.layer.borderWidth = 1
//        whiteSquare.layer.borderColor = UIColor.black.cgColor
//
//        redSquare.layer.borderWidth = 1
//        redSquare.layer.borderColor = UIColor.black.cgColor
//
//        greenSquare.layer.borderWidth = 1
//        greenSquare.layer.borderColor = UIColor.black.cgColor
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
