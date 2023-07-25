//
//  ImageFeed_iosTests.swift
//  ImageFeed-iosTests
//
//  Created by Александр Пичугин on 10.07.2023.
//

@testable import ImageFeed_ios
import XCTest

final class ImageFeed_iosTests: XCTestCase {
    
    // Тест вызова метода viewDidLoad () в презентере
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) 
    }
    
    // Проверка - вызывает ли презентер после вызова viewDidLoad()
    // метод loadRequest вьюконтроллера?
    func testPresenterCallsLoadRequest() {
        
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
        
    }
    
    // Проверка что индикатор прогресса отображается (= false), когда прогресс меньше едиицы
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    // Проверка что индикатор прогресса скрывается (= true), когда прогресс равен 1
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    // Проверка, что ссылка, полученная из authURL, содержит все необходимые компоненты.
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    // Проверка, что AuthHelper корректно распознаёт код из ссылки.
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let receivedСode = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(receivedСode, "test code")
    }
}
