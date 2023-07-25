//
//  ProfileViewPresenter.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 12.07.2023.
//

import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logOut()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var avatarStringURL: String?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard let profile = profileService.profile else { return }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                view?.updateAvatar(profileImageService.avatarURL)
            }
        
        view?.updateAvatar(profileImageService.avatarURL)
        view?.userNameLabel.text = profile.name
        view?.loginNameLabel.text = profile.loginName
        view?.profileTextLabel.text = profile.bio
    }
    
    func logOut() {
        OAuth2TokenStorage.shared.removeToken()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(
                        ofTypes: record.dataTypes,
                        for: [record],
                        completionHandler: {})
                }
            }
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
