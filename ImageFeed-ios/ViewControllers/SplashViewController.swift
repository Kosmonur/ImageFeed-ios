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
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            UIBlockingProgressHUD.show()
            oauth2Service.fetchAuthToken(code: code) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let token):
                    self.fetchProfile(token)
                case .failure:
                    // TODO
                    UIBlockingProgressHUD.dismiss()
                    print ("Ошибка:", result)
                    break
                }
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                if let userName = profileService.profile?.userName {
                    profileImageService.fetchProfileImageURL(username: userName) {_ in }
                }
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default) {[weak self] _ in
            self?.switchToAuthViewController()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func switchToAuthViewController() {
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
        guard let window = authViewController.instantiateViewController(withIdentifier: "authViewController") as? AuthViewController
        else {
            assertionFailure("Ошибка инициализации AuthViewController")
            return
        }
        window.delegate = self
        window.modalPresentationStyle = .fullScreen
        present(window, animated: true)
    }
}
