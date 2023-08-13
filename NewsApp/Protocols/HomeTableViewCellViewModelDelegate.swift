//
//  HomeTableViewCellViewModelDelegate.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

protocol HomeTableViewCellViewModelDelegate: AnyObject {
    func didFinishFetchingImage(imageData: Data)
    func didFailedFetchImage()
}
