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
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let auth2Service = OAuth2Service()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
        auth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let token):
                self.delegate?.authViewController(self, didAuthenticateWithCode: token)
            case .failure:
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "ОК") { }
                let alertPresenter = AlertPresenter(alertController: self)
                alertPresenter.showAlert(alertModel: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
