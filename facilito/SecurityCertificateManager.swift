//
//  SecurityCertificateManager.swift
//  facilito
//
//  Created by iMac Mario on 13/10/22.
//

import Foundation
import Alamofire

class SecurityCertificateManager {
    static let sharedInstance = SecurityCertificateManager()

    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "272.73.41.156": .disableEvaluation
        ]

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}
