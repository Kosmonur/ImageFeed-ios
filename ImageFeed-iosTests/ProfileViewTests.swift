//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Александр Пичугин on 16.07.2023.
//

@testable import ImageFeed_ios
import XCTest

final class ProfileViewTests: XCTestCase {
    
    // Тест вызова метода viewDidLoad () в презентере ProfileViewPresenter
    func testViewControllerCallsViewDidLoad() {
        
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
