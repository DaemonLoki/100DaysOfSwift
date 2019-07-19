//
//  NoteTableViewCell.swift
//  Notes Clone
//
//  Created by Stefan Blos on 12.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var dateString: String? {
        didSet {
            dateLabel.text = dateString
        }
    }
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 18)
        return l
    }()
    
    var dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
    
    var contentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    var separatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        v.alpha = 0.3
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .SIDE_MARGIN),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .SIDE_MARGIN),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.SIDE_MARGIN),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .SIDE_MARGIN),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.SIDE_MARGIN),
            dateLabel.widthAnchor.constraint(equalToConstant: 80),
            
            contentLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.SIDE_MARGIN),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .SIDE_MARGIN),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
