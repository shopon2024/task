//
//  NoteViewController.swift
//  Task
//
//  Created by Habib on 14/3/19.
//  Copyright © 2019 Habib. All rights reserved.
//

import UIKit
final class NoteViewController: UIViewController {
    
    //***** MARK: - Views *****
    private var noteTextView: UITextView =  {
        let textView = UITextView()
        if let font = UIFont(name: "Avenir", size: 17),  #available(iOS 11.0, *){
                let fontMetrics = UIFontMetrics(forTextStyle: .body)
                textView.font = fontMetrics.scaledFont(for: font)
        }else {
            textView.font = .preferredFont(forTextStyle: .body)
        }
        
        textView.adjustsFontForContentSizeCategory = true
        textView.isEditable = false
        return textView
    }()
    
    private var presenter: NotePresenter?
    
    //***** MARK:- Properties *****
    var userId: Int?
    private var isSave = true
    private var savedNote = ""
    
    //***** MARK:- View LifeCycle *****
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NotePresenter(delegate: self)
        backgroundSetup()
        addNoteTextView()
        setupConstraints()
        addNavigationItem()
        fetchNote()
    }

    //***** MARK: - Private Methods *****
    private func backgroundSetup() {
        view.backgroundColor = .white
    }
    
    private func addNoteTextView() {
        view.addSubview(noteTextView)
    }
    
    private func noteTextViewIsEditable(isEditable: Bool) {
        noteTextView.isEditable = isEditable
    }
    
    private func addNavigationItem() {
        let saveNoteButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveNoteButton(sender:)))
        let editNoteButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditNoteButton(sender:)))
        
        navigationItem.rightBarButtonItems = [editNoteButton,saveNoteButton]
    }
    
    private func toggleNavigationBarButton(isEditButton: Bool) {
        navigationItem.rightBarButtonItems?.first?.isEnabled = isEditButton
        navigationItem.rightBarButtonItems?.last?.isEnabled = !isEditButton
    }
    
    private func setupConstraints() {
        noteTextView.anchor(top: view.topAnchor,
                            left: view.readableContentGuide.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.readableContentGuide.rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 0,
                            height: 0,
                            enableInsets: true)
        
    }
    
    private func fetchNote() {
        if let id = userId {
            presenter?.fetchNoteWith(userId: id)
        }
    }
    
    private func addNote(with note: String) {
        if let id = userId{
            presenter?.addNoteWith(userId: id, note: note)
        }
    }
    
    private func editNote(with note: String) {
        if let id = userId {
            presenter?.editNoteWith(userId: id, newNote: note)
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Note", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func noteIsEmpty() -> Bool{
        if noteTextView.text.isEmpty {
            let message = "Note can't be blank"
            showAlert(with: message)
            return true
        }
        
        return false
    }
    
    //***** MARK:- IBActions ***** 
    @objc private func didTapSaveNoteButton(sender: Any) {
        if noteIsEmpty() {
            return
        }
        
        if presenter?.didChangeNote(saveNote: savedNote, currentNote: noteTextView.text) ?? false{
            isSave ? addNote(with: noteTextView.text) : editNote(with: noteTextView.text)
        }else {
            let message = "Note didn't change"
            showAlert(with: message)
        }
    }
    
    @objc private func didTapEditNoteButton(sender: Any) {
        toggleNavigationBarButton(isEditButton: false)
        noteTextViewIsEditable(isEditable: true)
        isSave = false
    }
}

//***** MARK: - NoteViewable Delegate *****
extension NoteViewController: NoteViewable {
    func addOrEditNoteSucceed() {
        navigationController?.popViewController(animated: true)
    }
    
    func addOrEditNoteDidFailedWith(_ message: String) {
        showAlert(with: message)
    }
    
    func fetchNoteSucceddWith(_ note: Note) {
        noteTextView.text = note.note
        savedNote = note.note
        toggleNavigationBarButton(isEditButton: true)
    }
    
    func fetchNoteDidFailedWith(_ message: String) {
        noteTextViewIsEditable(isEditable: true)
        toggleNavigationBarButton(isEditButton: false)
    }
    
}
