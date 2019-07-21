//
//  ViewController.swift
//  Notes
//
//  Created by n.kuznetsov on 21/07/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowEditScreen", sender: nil)
    }
    
    @IBAction func didTapEdit(_ sender: UIBarButtonItem) {
        sender.title = "Cancel"
        if tableView.isEditing {
            sender.title = "Edit"
            tableView.isEditing = false
        } else {
            sender.title = "Cancel"
            tableView.isEditing = true
        }
    }
    
    let reuseIdentifiers = "note cell"
    var notebook = FileNotebook.exampleNotebook
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifiers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? EditNoteViewController else {
            return
        }
        controller.delegate = self
        if segue.identifier == "ShowEditScreen" {}
        else if segue.identifier == "EditNoteSegue" {
            controller.selectedNote = selectedNote
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


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers, for: indexPath) as! NoteTableViewCell
        let note = notebook.notesArray[indexPath.row]
        
        cell.colorView.backgroundColor = note.color
        cell.contentLabel.text = note.content
        cell.titleLabel.text = note.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let uid = notebook.notesArray[indexPath.row].uid
            notebook.remove(with: uid)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notebook.notesArray[indexPath.row]
        tableView.deselectRow(at: IndexPath(row: indexPath.row, section: indexPath.section), animated: true)
        performSegue(withIdentifier: "EditNoteSegue", sender: nil)
    }
}
