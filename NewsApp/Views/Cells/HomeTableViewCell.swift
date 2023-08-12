//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    // MARK: - Subviews
    @IBOutlet private var articleImageView: UIImageView!
    @IBOutlet private var articleTitle: UILabel!
    @IBOutlet private var articleDate: UILabel!
    @IBOutlet private var articleAuthors: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        articleImageView.layer.cornerRadius = articleImageView.bounds.height / 2
    }

    func configure(withImage image: String, articleTitle: String, articleDate: String, articleBriefDescription: String) {
        self.articleImageView.image = UIImage(named: image)
        self.articleTitle.text = articleTitle
        self.articleDate.text = articleDate
        self.articleAuthors.text = articleBriefDescription
    }
}
