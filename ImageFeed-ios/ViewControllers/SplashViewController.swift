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
    private let oauth2Service = OAuth2Service.shared
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
        
        if let token = auth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token)
        } else {
            showAuthViewController()
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
        fetchProfile(code)
        dismiss(animated: true)
    }
    
    private func fetchProfile(_ token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                if let userName = profileService.profile?.userName {
                    profileImageService.fetchProfileImageURL(token, username: userName) {_ in }
                }
                self.switchToTabBarController()
            case .failure:
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "ОК") { [weak self] in
                        guard let self else { return }
                        
                        self.showAuthViewController()
                    }
                let alertPresenter = AlertPresenter(alertController: self)
                alertPresenter.showAlert(alertModel: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showAuthViewController() {
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
        guard let window = authViewController.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else {
            assertionFailure("Ошибка инициализации AuthViewController")
            return
        }
        window.delegate = self
        window.modalPresentationStyle = .fullScreen
        present(window, animated: true)
    }
}
