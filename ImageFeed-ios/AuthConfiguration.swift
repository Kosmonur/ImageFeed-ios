//
//  Constants.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.05.2023.
//

import Foundation

let AccessKey = "8RDPQgEIwoBrCyDpQaK1jKNAFbxDtcyaXZXvUQi7LoQ"
let SecretKey = "l6ToeHQoSP1o18sm2IAexqIQABmxpI0dcmpLKGtYjP4"

//let AccessKey = "Re1sBTF90r3BFZsWf-Pi94QgT263uUipanZxfDBPRVw"
//let SecretKey = "8SgsJRcmns98nseYiawh8gpHXwfmPCM-V_ePZewL4lU"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

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
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
