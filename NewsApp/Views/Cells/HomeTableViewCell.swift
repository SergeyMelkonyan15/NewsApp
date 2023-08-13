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

    // MARK: - ViewModel
    var viewModel: HomeTableViewCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        viewModel = HomeTableViewCellViewModel()
        viewModel?.delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        articleImageView.layer.cornerRadius = articleImageView.bounds.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.articleImageView.image = UIImage(systemName: "photo.circle")
    }

    // configure subviews values
    func configure(withImageURL url: String?, articleTitle: String, articleDate: String, articleBriefDescription: String) {
        Task {
            await viewModel?.getImage(withURL: url)
        }
        self.articleTitle.text = articleTitle
        self.articleDate.text = articleDate
        self.articleAuthors.text = articleBriefDescription
    }
}

// MARK: - Delegation
extension HomeTableViewCell: HomeTableViewCellViewModelDelegate {
    func didFinishFetchingImage(imageData: Data) {
        DispatchQueue.main.async {
            self.articleImageView.image = UIImage(data: imageData)
        }
    }

    func didFailedFetchImage() {
        articleImageView.image = UIImage(systemName: "photo.circle")
    }
}
