//
//  ProfileViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userPickImageView: UIImageView!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var profileTextLabel: UILabel!
    @IBAction private func didTapLogout(_ sender: UIButton) {
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
}
