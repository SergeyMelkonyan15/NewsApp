//
//  HomeTableViewCellViewModel.swift
//  NewsApp
//
//  Created by Sergey Melkonyan on 13.08.23.
//

import Foundation

final class MasterTableViewCellViewModel {

    weak var delegate: HomeTableViewCellViewModelDelegate?

    func getImage(withURL url: String?) async {
        guard let url else { return; delegate?.didFailedFetchImage() }
        do {
            let imageData = try await NetworkUtils.downloadImageData(fromURL: URL(string: url))
            delegate?.didFinishFetchingImage(imageData: imageData)
        } catch {
            delegate?.didFailedFetchImage()
        }
    }
}
