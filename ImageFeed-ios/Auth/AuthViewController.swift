//
//  AuthViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.05.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    private let oAuth2Service = OAuth2Service.shared
    
    private lazy var authLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage (named: "auth_screen_logo")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = UIColor(named: "YP_White")
        button.setTitleColor(UIColor(named: "YP_Black"), for: .normal)
        button.accessibilityIdentifier = "Authenticate"
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        button.setTitle("Войти", for: .normal)
        button.setValue(true, forKeyPath: "layer.masksToBounds")
        button.setValue(16, forKeyPath: "layer.cornerRadius")
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP_Black")
        authLogoImageView.isHidden = false
        loginButton.isHidden = false
        
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) {[weak self] in
            self?.fetchOAuthToken(authCode: code)
        }
    }
    
    private func fetchOAuthToken(authCode code: String) {
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let token):
                self.delegate?.authViewController(self, didAuthenticateWithCode: token)
            case .failure:
                let alertModel = AlertOneButton.notLogin
                let alertPresenter = AlertPresenter(alertController: self)
                alertPresenter.showAlert(alertModel: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    @objc private func didTapLoginButton() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController
        else {
            assertionFailure("Ошибка инициализации WebViewViewController")
            return
        }
        
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
        
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
}

