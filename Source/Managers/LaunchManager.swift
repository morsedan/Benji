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
import ReactiveSwift

enum LaunchStatus {
    case isLaunching
    case needsOnboarding
    case success(object: DeepLinkable?, token: String)
    case failed(error: ClientError?)
}

class LaunchManager {

    static let shared = LaunchManager()

    private(set) var finishedInitialFetch = false
    var onLoggedOut: (() -> Void)?

    // Important - update this URL with your Twilio Function URL
    private let tokenURL = "https://topaz-booby-6355.twil.io/chat-token"

    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    private let url = "https://benji-backend.herokuapp.com/parse"
    private let appID = "BenjiApp"
    private let clientKey = "theStupidMasterKeyThatShouldBeSecret"

    var status = MutableProperty<LaunchStatus>(.isLaunching)

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
            self.status.value = .needsOnboarding
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
                self.finishedInitialFetch = true
                
                //Initialize Branch
                self.initializeBranch(with: options, token: tkn)
            } else {
                self.status.value = .failed(error: ClientError.apiError(detail: error.debugDescription))
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
                                self.status.value = .success(object: nil, token: token)
                                return
                            }

                            // Use for testing 
                            //let buo = self.createTestBUO()

                            let buo: BranchUniversalObject? = branchObject
                                ?? Branch.getInstance().getLatestReferringBranchUniversalObject()

                            self.status.value = .success(object: buo, token: token)
        })
    }

    private func createTestBUO() -> BranchUniversalObject {
        var buo = BranchUniversalObject()
        buo.deepLinkTarget = .channel
        buo.channelId = "CH489170e8675049048bf3179e48d2a47a"
        return buo
    }

    func continueUser(activity: NSUserActivity) -> Bool {
        return Branch.getInstance().continue(activity)
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
