//
//  ProfileViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.05.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var userPickImageView: UIImageView = {
        let imageView = UIImageView()
 //       imageView.image = UIImage (named: "user_pick")
        imageView.image = UIImage (named: "user_placeholder")
        imageView.setValue(true, forKeyPath: "layer.masksToBounds")
        imageView.setValue(35, forKeyPath: "layer.cornerRadius")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        label.textColor = UIColor(named: "YP_White")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: userPickImageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.textColor = UIColor(named: "YP_Gray")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    
    private lazy var profileTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.textColor = UIColor(named: "YP_White")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton))
        button.tintColor = UIColor(named: "YP_Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.centerYAnchor.constraint(equalTo: userPickImageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: userPickImageView.trailingAnchor)
        ])
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP_Black")
        
        logoutButton.isHidden = false
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileImageService.DidChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()
                    }
        updateAvatar()
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        userNameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        profileTextLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        userPickImageView.kf.indicatorType = .activity
        userPickImageView.kf.setImage(with: url,
                                      placeholder: UIImage(named: "user_placeholder"),
                                      options: [.forceRefresh])
    }

    @objc private func didTapLogoutButton() {
        print(#function)
        
//        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "bearer_token")
 

        
    }
}

//import SwiftKeychainWrapper
