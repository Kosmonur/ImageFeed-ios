//
//  ImagesListViewPresenter.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.07.2023.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
} 
