//
//  ViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 17/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    private var whiteSquare: ColorSquareView!
//    private var greenSquare: ColorSquareView!
//    private var redSquare: ColorSquareView!
//    private var anySquare: ColorSquareView!
    @IBOutlet weak var whiteSquare: ColorSquareView!
    @IBOutlet weak var redSquare: ColorSquareView!
    @IBOutlet weak var greenSquare: ColorSquareView!
    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        whiteSquare.layer.borderWidth = 1
        whiteSquare.layer.borderColor = UIColor.black.cgColor
        
        redSquare.layer.borderWidth = 1
        redSquare.layer.borderColor = UIColor.black.cgColor
        
        greenSquare.layer.borderWidth = 1
        greenSquare.layer.borderColor = UIColor.black.cgColor
//
//        anySquare.layer.borderWidth = 1
//        anySquare.layer.borderColor = UIColor.black.cgColor
    }


}

