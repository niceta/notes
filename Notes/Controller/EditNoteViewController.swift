//
//  ViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 17/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var whiteColorView: ColorSquareView!
    @IBOutlet weak var redColorView: ColorSquareView!
    @IBOutlet weak var greenColorView: ColorSquareView!
    @IBOutlet weak var anyColorView: ColorSquareView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePickerView: DatePickerView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    weak var delegate: ViewController?
    var color: UIColor? = .white
    var selectedNote: Note?
    var isAnyColorPressed = false
    var didReturnFromColorPicker = false
    
    @IBAction func unwindToStartScreen(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func whiteColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = false
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = true
        
        color = .white
    }
    
    @IBAction func redColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = false
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = true
        
        color = .red
    }
    
    @IBAction func greenColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = false
        anyColorView.isShapeHidden = true
        
        color = .green
    }
    
    @IBAction func anyColorTapped(_ sender: UITapGestureRecognizer) {
        if let _ = anyColorView.layer.sublayers {
            return
        }
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = false
        
        color = anyColorView.backgroundColor
    }
    
    @IBAction func anyColorLongPressed(_ sender: UILongPressGestureRecognizer) {
        //view.endEditing(true) // чтобы убрать клавиатуру при переходе к выбору цвета
        //colorPickerView.isHidden = false
        if sender.state == .began {
            performSegue(withIdentifier: "showColorPickerSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ColorPickerViewController, segue.identifier == "showColorPickerSegue" {
            controller.delegate = self
            isAnyColorPressed = true
        }
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
        whiteColorView.isShapeHidden = false
        
        redColorView.layer.borderWidth = 1
        redColorView.layer.borderColor = UIColor.black.cgColor

        greenColorView.layer.borderWidth = 1
        greenColorView.layer.borderColor = UIColor.black.cgColor
        
        anyColorView.layer.borderWidth = 1
        anyColorView.layer.borderColor = UIColor.black.cgColor
        anyColorView.gradientOfView(withColours: UIColor.red,UIColor.green, UIColor.blue)
        
        //colorPickerView.colorPicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAnyColorPressed = false
        
        guard let note = selectedNote, !didReturnFromColorPicker else {
            return
        }
        textField.text = note.title
        textView.text = note.content
        switch note.color {
        case .white:
            whiteColorTapped(.init())
        case .green:
            greenColorTapped(.init())
        case .red:
            redColorTapped(.init())
        default:
            anyColorView.backgroundColor = note.color
            anyColorView.layer.sublayers = nil
            anyColorTapped(.init())
        }
        if let date = note.selfDestructionDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            datePickerView.dateFieldView.text = formatter.string(from: date)
            datePickerView.dateFieldView.isHidden = false
            datePickerView.switchView.isOn = true
        }
    }
    
    private func initDatePicker() {
        let toolbar: UIToolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0,  width: screenFrame.size.width, height: 30)
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textFieldShouldReturn))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        toolbar.backgroundColor = .white
        datePickerView.dateFieldView.inputAccessoryView = toolbar
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(EditNoteViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditNoteViewController.viewTapped(gestureRecognier:)))
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
        
        didReturnFromColorPicker = false
        
        guard let strongDelegate = delegate, isAnyColorPressed == false else {
            return
        }
        
        guard
            let title = textField.text, !title.isEmpty,
            let content = textView.text, !content.isEmpty
        else {
            return
        }
        
        var destructionDate: Date? = nil
        if let date = datePickerView.dateFieldView.text, !date.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            destructionDate = formatter.date(from: date)
        }
        
        let note = Note(title: title,
                        content: content,
                        priority: .normal,
                        color: color ?? .white,
                        selfDestructionDate: destructionDate)
        
        if selectedNote == nil {
            strongDelegate.tableView.beginUpdates()
            strongDelegate.notebook.add(note)
            strongDelegate.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            strongDelegate.tableView.endUpdates()
        } else {
            guard
                let uid = selectedNote?.uid,
                let noteIdx = (strongDelegate.notebook.notesArray.firstIndex(where: {$0.uid == uid})),
                selectedNote?.title != note.title ||
                selectedNote?.content != note.content ||
                selectedNote?.color != note.color ||
                selectedNote?.selfDestructionDate != note.selfDestructionDate
            else {
                return
            }
            strongDelegate.tableView.beginUpdates()
            strongDelegate.notebook.remove(with: uid)
            strongDelegate.notebook.add(note)
            strongDelegate.tableView.deleteRows(at: [IndexPath(row: noteIdx, section: 0)], with: .automatic)
            strongDelegate.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            strongDelegate.tableView.endUpdates()
        }
        
        selectedNote = nil
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

/*extension EditNoteViewController: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        colorPickerView.preview.backgroundColor = color
        anyColorView.backgroundColor = color
        anyColorView.layer.sublayers = nil
        
        whiteColorView.isShapeHidden = true
        redColorView.isShapeHidden = true
        greenColorView.isShapeHidden = true
        anyColorView.isShapeHidden = false
        
        self.color = color
    }
}
*/
extension UIView {
    func gradientOfView(withColours: UIColor...) {
        
        var cgColours = [CGColor]()
        
        for colour in withColours {
            cgColours.append(colour.cgColor)
        }
        let grad = CAGradientLayer()
        grad.frame = self.bounds
        grad.colors = cgColours
        self.layer.insertSublayer(grad, at: 0)
    }
}
