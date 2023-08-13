//
//  ViewController.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import UIKit
import Security

final class HomeViewController: UIViewController {

    // MARK: - Subviews
    @IBOutlet weak var loaderActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var homeTableView: UITableView!
    @IBOutlet private var filterSegmentedControl: UISegmentedControl!

    // MARK: - Enums
    enum UserDefaultsKeys {
        static let filterIndexKey = "filterIndex"
    }

    // MARK: - UserDefaults
    var defaults = UserDefaults.standard

    // MARK: - ViewModel
    var homeViewModel: HomeViewModel?

    // MARK: - Items
    var articles: ArticleResponse?

    // MARK: - Properties
    private let heightRatioForCellHeight = 0.13
    private let defaultImageFormatIndex = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        configureTableView()
    }

    // MARK: - Helpers
    private func configureTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(
            UINib(
                nibName: String(describing: HomeTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: "HomeCell"
        )
    }

    private func setUp() {
        homeViewModel = HomeViewModel()
        homeViewModel?.delegate = self

        filterSegmentedControl.selectedSegmentIndex = defaults.integer(forKey: UserDefaultsKeys.filterIndexKey)
        loaderActivityIndicator.startAnimating()

        setUpUserDefaults()
        checkFilter()
    }

    private func setUpUserDefaults() {
        defaults.set(filterSegmentedControl.selectedSegmentIndex, forKey: UserDefaultsKeys.filterIndexKey)
    }

    private func checkFilter() {
        let filterIndex = defaults.integer(forKey: UserDefaultsKeys.filterIndexKey)
        Task {
            await homeViewModel?.getArticle(forType: Filter.allCases[filterIndex])
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title, message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )

        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func configureCell(cell: HomeTableViewCell, articles: ArticleResponse, indexPath: IndexPath) {
        let articleResult = articles.results[indexPath.row]
        let articleImageURL = getImageURL(forFormat: ImageFormat.standart.rawValue, articleResult: articleResult)
        let articleTitle = articleResult.title
        let articleDate = articleResult.publishedDate
        let articleCreator = articleResult.byLine

        cell.configure(
            withImageURL: articleImageURL,
            articleTitle: articleTitle,
            articleDate: articleDate,
            articleBriefDescription: articleCreator
        )
    }

    private func getImageURL(forFormat imageFormat: ImageFormat.RawValue, articleResult: ArticleResult) -> String? {
        var imageURL: String?
        guard let media = articleResult.media.first else { return nil }
        for (index, article) in media.mediaMetadata.enumerated() {
            if article.format == imageFormat {
                imageURL = articleResult.media.first?.mediaMetadata[index].imageURL
            } else {
                imageURL = articleResult.media.first?.mediaMetadata[defaultImageFormatIndex].imageURL
            }
        }
        return imageURL
    }

    // MARK: - Callbacks
    @IBAction func filterTapped(_ sender: UISegmentedControl) {
        guard let homeViewModel else { return }
        setUpUserDefaults()
        Task {
            await homeViewModel.getArticle(forType: Filter.allCases[sender.selectedSegmentIndex])
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeTableViewCell
        else { fatalError() }

        if let articles {
            loaderActivityIndicator.stopAnimating()
            loaderActivityIndicator.isHidden = true
            configureCell(cell: cell, articles: articles, indexPath: indexPath)
        } else {
            loaderActivityIndicator.isHidden = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
        var detailViewModel = DetailViewModel()
        let detailViewController = DetailViewController(detailViewModel: detailViewModel)
        if let articles {
            detailViewModel.updateArticles(withArticles: articles.results[indexPath.row])
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * heightRatioForCellHeight
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didFetchArticle(article: ArticleResponse) {
        articles = article
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }

    func didGetError(errorMessage: String) {
        showAlert(title: errorMessage, message: "Error Occurred")
    }
}
