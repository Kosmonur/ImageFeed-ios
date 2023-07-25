//
//  WebViewPresenterSpy.swift
//  ImageFeed-iosTests
//
//  Created by Александр Пичугин on 10.07.2023.
//

@testable import ImageFeed_ios
import ImageFeed_ios
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed_ios.WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    func webViewViewControllerDidCancel(_ vc: ImageFeed_ios.WebViewViewController) {
        
    }
    
    func didAuthenticateWithCode(_ vc: ImageFeed_ios.WebViewViewController, _ code: String) {
        
    }
    
}
