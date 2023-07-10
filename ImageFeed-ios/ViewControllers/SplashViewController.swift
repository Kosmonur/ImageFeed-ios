//
//  SplashViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 01.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let auth2TokenStorage = OAuth2TokenStorage.shared
    
    private lazy var splashLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage (named: "splah_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP_Black")
        splashLogoImageView.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if auth2TokenStorage.token == nil  {
            showAuthViewController()
        } else {
            UIBlockingProgressHUD.show()
            fetchProfile()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        auth2TokenStorage.token = code
        fetchProfile()
        dismiss(animated: true)
    }
    
    private func fetchProfile() {
        
        profileService.fetchProfile() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                if let userName = profileService.profile?.userName {
                    profileImageService.fetchProfileImageURL(username: userName) {_ in }
                }
                switchToTabBarController()
            case .failure:
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "ОК") { [weak self] in
                        guard let self else { return }
                        
                        showAuthViewController()
                    }
                let alertPresenter = AlertPresenter(alertController: self)
                alertPresenter.showAlert(alertModel: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
      }

}
