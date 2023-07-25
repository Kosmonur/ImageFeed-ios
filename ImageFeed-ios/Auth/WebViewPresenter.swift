//
//  WebViewPresenter.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 09.07.2023.
//

import Foundation

protocol WebViewPresenterDelegate: AnyObject {
    func didAuthenticateWithCode(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    func didAuthenticateWithCode(_ vc: WebViewViewController, _ code: String)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    weak var delegate: WebViewPresenterDelegate?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func didAuthenticateWithCode(_ vc: WebViewViewController, _ code: String) {
        delegate?.didAuthenticateWithCode(vc, didAuthenticateWithCode: code)
    }
}
