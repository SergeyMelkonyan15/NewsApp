//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Subviews
    @IBOutlet private var detailImageView: UIImageView!
    @IBOutlet private var articleTitle: UILabel!
    @IBOutlet private var articleAuthors: UILabel!
    @IBOutlet private var articleDate: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var type: UILabel!

    // MARK: - ViewModel
    var detailViewModel: DetailViewModel

    // MARK: - Items
    var articles: ArticleResult?

    // MARK: - Init
    init(detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let defaultImageFormatIndex = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.articles = detailViewModel.getArticles()
        setUp()
    }

    // MARK: - Helpers
    private func setUp() {
        guard let articles else { return }

        articleTitle.text = articles.title
        articleAuthors.text = articles.byLine
        articleDate.text = articles.publishedDate
        section.text = articles.section
        type.text = articles.type
        setImageViewImage(withURL: getImageURL(forFormat: ImageFormat.big.rawValue))
    }

    private func setImageViewImage(withURL url: String?) {
        Task {
            let imageData = await detailViewModel.getImage(withURL: url)
            if let imageData {
                detailImageView.image = UIImage(data: imageData)
            } else {
                detailImageView.image = UIImage(systemName: "photo.circle")
            }
        }
    }

    private func getImageURL(forFormat imageFormat: ImageFormat.RawValue) -> String? {
        guard let articles else { return nil}

        var imageURL: String?
        guard let media = articles.media.first else { return nil }
        for (index, article) in media.mediaMetadata.enumerated() {
            if article.format == imageFormat {
                imageURL = articles.media.first?.mediaMetadata[index].imageURL
            } else {
                imageURL = articles.media.first?.mediaMetadata[defaultImageFormatIndex].imageURL
            }
        }
        return imageURL
    }
}
