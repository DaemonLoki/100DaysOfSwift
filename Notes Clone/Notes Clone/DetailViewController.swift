//
//  DetailViewController.swift
//  Notes Clone
//
//  Created by Stefan Blos on 12.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var note: Note?
    var notesHandler: NotesHandler?
    
    var lastSavedLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        l.textColor = .darkGray
        return l
    }()
    
    var textView: UITextView = {
        var t = UITextView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.systemFont(ofSize: 18.0)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let note = note, let _ = notesHandler else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))]
        
        setupLayout()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm"
        lastSavedLabel.text = dateFormatter.string(from: note.timeSaved)
        textView.delegate = self
        textView.text = note.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let note = note, let notesHandler = notesHandler {
            note.text = textView.text
            note.timeSaved = Date()
            notesHandler.saveNote(note: note)
        }
        super.viewWillDisappear(true)
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(lastSavedLabel)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            
            lastSavedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            lastSavedLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .SIDE_MARGIN),
            lastSavedLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.SIDE_MARGIN),
            
            textView.topAnchor.constraint(equalTo: lastSavedLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .SIDE_MARGIN),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.SIDE_MARGIN),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.SIDE_MARGIN)
        ])
    }
    
    @objc func shareNote() {
        guard let note = self.note else {
            return
        }
        let vc = UIActivityViewController(activityItems: [note.text], applicationActivities: [])
        present(vc, animated: true)
    }

}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing)), at: 0)
    }
    
    @objc func endEditing() {
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if navigationItem.rightBarButtonItems?.count == 2 {
            navigationItem.rightBarButtonItems?.remove(at: 0)
        }
        endEditing()
    }
    
}
