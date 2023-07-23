//
//  WebViewViewControllerSpy.swift
//  ImageFeed-iosTests
//
//  Created by Александр Пичугин on 10.07.2023.
//

import ImageFeed_ios
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}

