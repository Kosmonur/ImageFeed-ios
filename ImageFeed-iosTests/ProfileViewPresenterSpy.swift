//
//  ProfileViewPresenterSpy.swift
//  ImageFeed-iosTests
//
//  Created by Александр Пичугин on 17.07.2023.
//

import ImageFeed_ios
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logOut() {
        
    }
}
