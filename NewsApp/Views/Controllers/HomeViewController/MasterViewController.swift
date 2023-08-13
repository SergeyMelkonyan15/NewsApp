//
//  ViewController.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import UIKit
import Security

final class MasterViewController: UIViewController {
    
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
    var masterViewModel: MasterViewModel?
    
    // MARK: - Items
    var articles: ArticleResponse?
    
    // MARK: - Properties
    private let heightRatioForCellHeight = 0.13

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configureTableView()
        syncArticlesData()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.loaderActivityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.height / 2)
    }
    
    // MARK: - Helpers
    private func configureTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(
            UINib(
                nibName: String(describing: MasterTableViewCell.self),
                bundle: nil
            ),
            forCellReuseIdentifier: "HomeCell"
        )
    }
    
    private func setUp() {
        masterViewModel = MasterViewModel()
        masterViewModel?.delegate = self
    }
    
    private func syncArticlesData() {
        // get saved filter selection from User Defaults
        filterSegmentedControl.selectedSegmentIndex = defaults.integer(forKey: UserDefaultsKeys.filterIndexKey)

        Task {
            // get articles according to the selected filter "Weekly", "Daily" and "30 days"
            await masterViewModel?.getArticle(forType: Filter.allCases[filterSegmentedControl.selectedSegmentIndex])
        }
    }
    
    private func updateSelectedFilterInUserDefaults() {
        defaults.set(filterSegmentedControl.selectedSegmentIndex, forKey: UserDefaultsKeys.filterIndexKey)
    }
    
    private func configureCell(cell: MasterTableViewCell, articles: ArticleResponse, indexPath: IndexPath) {
        let articleResult = articles.results[indexPath.row]
        // use small image size for the table view rows
        let articleImageURL = masterViewModel?.getImageURL(smallImageSize: ImageSize.standart.rawValue, articleResult: articleResult)
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
    
   
    
    // MARK: - Callbacks
    @IBAction func filterTapped(_ sender: UISegmentedControl) {
        guard let masterViewModel else { return }
        updateSelectedFilterInUserDefaults()
        Task {
            await masterViewModel.getArticle(forType: Filter.allCases[sender.selectedSegmentIndex])
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? MasterTableViewCell
        else { fatalError() }
        
        if let articles {
            configureCell(cell: cell, articles: articles, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        else { fatalError() }
        
        homeTableView.deselectRow(at: indexPath, animated: true)

        // pass selected article data to DetailViewModel
        let detailViewModel = DetailViewModel()
        detailViewController.detailViewModel = detailViewModel

        if let articles {
            detailViewModel.updateTappedArticle(withArticle: articles.results[indexPath.row])
        }

        // handling the navigation of the detail vc according to the device screen type
//        if UIDevice.current.userInterfaceIdiom == .pad {
            showDetailViewController(detailViewController, sender: self)
//        } else {
//            show(detailViewController, sender: self)
//        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * heightRatioForCellHeight
    }
}

// MARK: - HomeViewModelDelegate
extension MasterViewController: MasterDelegate {
    func didStartDataLoading() {
        DispatchQueue.main.async {
            self.loaderActivityIndicator.isHidden = false
            self.loaderActivityIndicator.startAnimating()
        }
    }
    
    func didFetchArticle(article: ArticleResponse) {
        articles = article
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
            self.loaderActivityIndicator.stopAnimating()
            self.loaderActivityIndicator.isHidden = true
        }
    }
    
    func didGetError(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Failed to load Articles", message: errorMessage)
            self.loaderActivityIndicator.stopAnimating()
            self.loaderActivityIndicator.isHidden = true
        }
    }
    
    
}
