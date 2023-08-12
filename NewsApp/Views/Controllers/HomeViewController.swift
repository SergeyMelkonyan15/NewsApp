//
//  ViewController.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 12.08.23.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Subviews
    @IBOutlet private var homeTableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

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
}


// MARK: - TableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeTableViewCell
        else { fatalError() }


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.13
    }
}
