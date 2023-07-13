//
//  TabBarController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 23.06.2023.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            assertionFailure("Ошибка инициализации ImagesListViewController")
            return
        }
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)

        let imagesListViewPresenter = ImagesListViewPresenter()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
