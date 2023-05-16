//
//  ProfileViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let userPickImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let profileTextLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP_Black")
        setUserPick()
        setUserNameLabel()
        setLoginNameLabel()
        setProfileTextLabel()
        setLogoutButton()
    }
    
    private func setUserPick() {
        userPickImageView.image = UIImage (named: "user_pick")
        userPickImageView.setValue(true, forKeyPath: "layer.masksToBounds")
        userPickImageView.setValue(35, forKeyPath: "layer.cornerRadius")
        userPickImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPickImageView)
        
        NSLayoutConstraint.activate([
            userPickImageView.widthAnchor.constraint(equalToConstant: 70),
            userPickImageView.heightAnchor.constraint(equalToConstant: 70),
            userPickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userPickImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setUserNameLabel() {
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        userNameLabel.textColor = UIColor(named: "YP_White")
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userPickImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setLoginNameLabel() {
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        loginNameLabel.textColor = UIColor(named: "YP_Gray")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            loginNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setProfileTextLabel() {
        profileTextLabel.text = "Hello, World!"
        profileTextLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        profileTextLabel.textColor = UIColor(named: "YP_White")
        profileTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileTextLabel)
        
        NSLayoutConstraint.activate([
            profileTextLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            profileTextLabel.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            profileTextLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            profileTextLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton))
        
        logoutButton.tintColor = UIColor(named: "YP_Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: userPickImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: userPickImageView.trailingAnchor)
        ])
    }
    
    @objc private func didTapLogoutButton() {
        print(#function)
    }
}
