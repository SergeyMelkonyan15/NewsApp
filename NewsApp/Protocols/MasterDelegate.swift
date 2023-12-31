//
//  HomeViewModelDelegate.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

protocol MasterDelegate: AnyObject {
    func didStartDataLoading()
    func didFetchArticle(article: ArticleResponse)
    func didGetError(errorMessage: String)
}
