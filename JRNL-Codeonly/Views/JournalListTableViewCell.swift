//
//  JournalListTableViewCell.swift
//  JRNL-Codeonly
//
//  Created by 어재선 on 5/13/24.
//

import UIKit

class JournalListTableViewCell: UITableViewCell {
    
    private lazy var thumbnilView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "face.smiling")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
       let dateLable = UILabel()
        dateLable.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        dateLable.text = "Date"
        return dateLable
    }()
    
    private lazy var titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(thumbnilView)
        addSubview(dateLabel)
        addSubview(titleLabel)
        
        thumbnilView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.safeAreaLayoutGuide
        let marginGuide = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            thumbnilView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            thumbnilView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            thumbnilView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            thumbnilView.widthAnchor.constraint(equalToConstant: 90),
            
            dateLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: thumbnilView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnilView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -8)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configureCell
    func configureCell(journalEntry: JournalEntry) {
        thumbnilView.image = journalEntry.photo
        dateLabel.text = journalEntry.date.formatted(.dateTime.year().month().day())
        titleLabel.text = journalEntry.entryTitle
    }

}
