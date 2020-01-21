//
//  LaunchManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import Branch

enum LaunchStatus {
    case isLaunching
    case needsOnboarding
    case success(object: DeepLinkable?, token: String)
    case failed(error: ClientError?)
}

protocol LaunchManagerDelegate: class {
    func launchManager(_ launchManager: LaunchManager, didFinishWith options: LaunchStatus)
}

class LaunchManager {

    static let shared = LaunchManager()

    weak var delegate: LaunchManagerDelegate?
    private(set) var finishedInitialFetch = false
    var onLoggedOut: (() -> Void)?

    // Important - update this URL with your Twilio Function URL
    private let tokenURL = "https://topaz-booby-6355.twil.io/chat-token"

    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    private let url = "https://benji-backend.herokuapp.com/parse"
    private let appID = "BenjiApp"
    private let clientKey = "theStupidMasterKeyThatShouldBeSecret"
    private(set) var status: LaunchStatus = .isLaunching {
        didSet {
            self.delegate?.launchManager(self, didFinishWith: self.status)
        }
    }

    func launchApp(with options: [UIApplication.LaunchOptionsKey: Any]?) {

        if !Parse.isLocalDatastoreEnabled {
            Parse.enableLocalDatastore()
        }

        if Parse.currentConfiguration == nil  {
            Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.isLocalDatastoreEnabled = true
                configuration.server = self.url
                configuration.clientKey = self.clientKey
                configuration.applicationId = self.appID
            }))
        }

        if let user = User.current(), let identity = user.objectId {
            self.authenticateChatClient(with: identity, options: options)
        } else {
            self.status = .needsOnboarding
        }
    }

    func authenticateChatClient(with identity: String, options: [UIApplication.LaunchOptionsKey: Any]?) {

        Branch.getInstance().setIdentity(identity)
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are running
        // the PHP starter app on your local machine, as instructed in the quick start guide
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let urlString = "\(self.tokenURL)?identity=\(identity)&device=\(deviceId)"

        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let tkn = token {
                // Set up Twilio Chat client
                UserNotificationManager.shared.silentRegister(withApplication: UIApplication.shared)
                self.finishedInitialFetch = true
                
                //Initialize Branch
                self.initializeBranch(with: options, token: tkn)
            } else {
                self.status = .failed(error: ClientError.apiError(detail: error.debugDescription))
            }
        }
    }

    func logout() {
        if let client = ChannelManager.shared.client  {
            client.delegate = nil
            client.shutdown()
        }
    }

    private func initializeBranch(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?, token: String) {
        let branch: Branch = Branch.getInstance()

        let notificationInfo = launchOptions?[.remoteNotification] as? [String : Any]
        if let data = notificationInfo?["data"] as? [String : Any],
            let branchLink = data["branch"] as? String {
            branch.handleDeepLink(URL(string: branchLink))
        }

        branch.initSession(launchOptions: launchOptions,
                           andRegisterDeepLinkHandlerUsingBranchUniversalObject: { (branchObject,
                            properties,
                            error) in

                            guard error == nil else {
                                // IMPORTANT: Allow the launch sequence to continue even if branch fails.
                                // We don't want issues with the branch api to block our app from launching.
                                self.status = .success(object: nil, token: token)
                                return
                            }

                            let buo: BranchUniversalObject? = branchObject
                                ?? Branch.getInstance().getLatestReferringBranchUniversalObject()

                            self.status = .success(object: buo, token: token)
        })
    }
}

fileprivate struct TokenUtils {

    static func retrieveToken(url: String, completion: @escaping (String?, String?, Error?) -> Void) {
        if let requestURL = URL(string: url) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
                        let token = json["token"]
                        let identity = json["identity"]
                        completion(token, identity, error)
                    }
                    catch let error as NSError {
                        completion(nil, nil, error)
                    }

                } else {
                    completion(nil, nil, error)
                }
            })
            task.resume()
        }
    }
}
