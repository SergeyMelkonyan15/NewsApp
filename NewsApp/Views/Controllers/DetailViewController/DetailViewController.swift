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
    @IBOutlet weak var noItemsSelectedText: UILabel!
    
    // MARK: - ViewModel
    var detailViewModel: DetailViewModel?

    // MARK: - Items
    var article: ArticleResult?

    private let defaultImageFormatIndex = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        setUp()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        if let contactVC = self.navigationController?.viewControllers.filter({ $0 is MasterViewController }).first {

//        }
//        if let splitVC = splitViewController, let navController = splitVC.viewControllers.first as? UINavigationController {
//               navController.popToRootViewController(animated: true)
//       
//           }

        
    }

    // MARK: - Helpers
    private func configureSubviews() {
        self.article = detailViewModel?.getArticle()

        // hiding the unused labels programmatically. Not adding initial "hidden" value in Storyboard so that it be easy to visualize the Storyboard
        detailImageView.isHidden = true
        articleTitle.isHidden = true
        articleAuthors.isHidden = true
        articleDate.isHidden = true
        section.isHidden = true
        type.isHidden = true
        noItemsSelectedText.isHidden = false
    }


    private func setUp() {
        // hiding back button for iPads
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
        guard let article else { return }
        noItemsSelectedText.isHidden = true
        detailImageView.isHidden = false
        articleTitle.isHidden = false
        articleAuthors.isHidden = false
        articleDate.isHidden = false
        section.isHidden = false
        type.isHidden = false
        articleTitle.text = article.title
        articleAuthors.text = article.byLine
        articleDate.text = article.publishedDate
        section.text = article.section
        type.text = article.type

        setImageViewImage()
    }

    private func setImageViewImage() {
        Task {
            // using big image size
            var imageUrl = detailViewModel?.getImageURL(bigImageSize: ImageSize.big.rawValue)
            // downloading image from viewmodel
            let imageData = await detailViewModel?.getImage(withURL: imageUrl)
            if let imageData {
                detailImageView.image = UIImage(data: imageData)
            } else {
                // using a default placeholder if there is no image received
                detailImageView.image = UIImage(systemName: "photo.circle")
            }
        }
    }

   
}
