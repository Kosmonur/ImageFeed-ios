//
//  Constants.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.05.2023.
//

import Foundation

enum Constant {
//    static let accesKey = "8RDPQgEIwoBrCyDpQaK1jKNAFbxDtcyaXZXvUQi7LoQ"
//    static let secretKey = "l6ToeHQoSP1o18sm2IAexqIQABmxpI0dcmpLKGtYjP4"
    
    static let accesKey = "Re1sBTF90r3BFZsWf-Pi94QgT263uUipanZxfDBPRVw"
    static let secretKey = "8SgsJRcmns98nseYiawh8gpHXwfmPCM-V_ePZewL4lU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constant.accesKey,
                                 secretKey: Constant.secretKey,
                                 redirectURI: Constant.redirectURI,
                                 accessScope: Constant.accessScope,
                                 authURLString: Constant.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constant.defaultBaseURL)
    }
}
