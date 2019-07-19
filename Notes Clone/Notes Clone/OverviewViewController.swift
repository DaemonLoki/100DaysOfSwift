//
//  ViewController.swift
//  Notes Clone
//
//  Created by Stefan Blos on 12.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    var notesHandler: NotesHandler?
    
    var notes = [Note]() {
        didSet {
            let noteString = (notes.count == 1) ? "Note" : "Notes"
            noteCountLabel.text = "\(notes.count) \(noteString)"
        }
    }
    
    let bgImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "paper-bg"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.alpha = 0.7
        return iv
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        return tv
    }()
    
    let bottomBarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    let noteCountLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "0 Notes"
        return l
    }()
    
    let createNoteButton: UIButton = {
        let b = UIButton(type: .contactAdd)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tintColor = .customYellow
        b.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
        return b
    }()
    
    let reuseIdentifier = "NoteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = notesHandler else {
            fatalError("Notes handler not available")
        }
        
        title = "Notes"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadNotes()
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        tableView.backgroundView = bgImageView
        
        bottomBarView.addSubview(noteCountLabel)
        bottomBarView.addSubview(createNoteButton)
        
        view.addSubview(bgImageView)
        view.addSubview(bottomBarView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 40.0),
            
            noteCountLabel.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            noteCountLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            createNoteButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -20),
            createNoteButton.heightAnchor.constraint(equalToConstant: 35),
            createNoteButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func loadNotes() {
        guard let notesHandler = notesHandler else {
            return
        }
        
        notesHandler.loadNotes { [weak self] (notes) in
            self?.notes = notes
            self?.tableView.reloadData()
        }
    }
    
    func saveNotes() {
        guard let notesHandler = notesHandler else {
            return
        }
        
        notesHandler.saveNotes(notes: notes)
    }
    
    @objc func createNewNote() {
        let note = Note(id: UUID(), text: "", timeCreated: Date())
        notes.append(note)
        saveNotes()
        
        openDetailViewController(note: note)
    }
    
    func openDetailViewController(note: Note) {
        guard let notesHandler = notesHandler else {
            return
        }
        
        let vc = DetailViewController()
        vc.note = note
        vc.notesHandler = notesHandler
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Could not initialize NoteTableViewCell")
        }
        
        let note = notes[indexPath.row]
        let text = note.text
        var title: String
        var content: String?
        (title, content) = splitTextToTitleAndContent(text: text)
        cell.title = String(title)
        if let content = content {
            cell.content = content
        }
        
        cell.dateString = convertDateToString(date: note.timeSaved)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        openDetailViewController(note: note)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            
            self?.notes.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            guard let notes = self?.notes else { return }
            self?.notesHandler?.saveNotes(notes: notes)
        }
        return [delete]
    }
    
    fileprivate func splitTextToTitleAndContent(text: String) -> (String, String?) {
        let splitted = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        if splitted.count == 0 {
            return ("Empty note", nil)
        } else if splitted.count == 1 {
            return (String(splitted[0]), nil)
        } else {
            var noteContent = String(splitted[1])
            while noteContent.first == "\n" || noteContent.first == " " {
                noteContent.removeFirst()
            }
            return (String(splitted[0]), noteContent)
        }
    }
    
    fileprivate func convertDateToString(date: Date) -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        
        if today.month() == date.month() && today.year() == date.year() {
            if today.day() == date.day() {
                dateFormatter.timeStyle = .short
                return dateFormatter.string(from: date)
            } else if today.day() - date.day() == 1 {
                return "Yesterday"
            }
        }
        
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
}

