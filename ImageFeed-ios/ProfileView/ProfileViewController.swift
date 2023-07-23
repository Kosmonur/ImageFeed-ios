//
//  ProfileViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.05.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var userNameLabel: UILabel { get set }
    var loginNameLabel: UILabel { get set }
    var profileTextLabel: UILabel { get set }
    func updateAvatar(_ avatarStringURL: String?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var userPickImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var loginNameLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var profileTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "YP_White")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: userPickImageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor)
        ])
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton))
        button.accessibilityIdentifier = "logout_button"
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP_Black")
        logoutButton.isHidden = false
        presenter?.viewDidLoad()
    }
    
    func updateAvatar(_ avatarStringURL: String?) {
        guard let avatarStringURL,
              let avatarURL = URL(string: avatarStringURL) else { return }
        
        userPickImageView.kf.indicatorType = .activity
        userPickImageView.kf.setImage(with: avatarURL,
                                      placeholder: UIImage(named: "user_placeholder"),
                                      options: [.forceRefresh])
    }
    
    @objc private func didTapLogoutButton() {
        
        var alertModel = AlertTwoButton.exitOrNot
        alertModel.completion2Button = {
            self.presenter?.logOut()
        }
        
        let alertPresenter = AlertPresenter(alertController: self)
        alertPresenter.showAlert(alertModel: alertModel)
    }
}

