//
//  LaunchManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum LaunchStatus {
    case isLaunching
    case success(object: DeepLinkable?)
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

    //Temp Twilio Funciton to register for push notifications
    private var serverURL = "https://topaz-booby-6355.twil.io"
    private var path = "/register-binding"

    // Important - update this URL with your Twilio Function URL
    private let tokenURL = "https://topaz-booby-6355.twil.io/chat-token"

    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    private let url = "https://benji-ios.herokuapp.com/parse"
    private let appID = "benjamindodgson.Benji"
    private let clientKey = "myMasterKey"
    private(set) var status: LaunchStatus = .isLaunching {
        didSet {
            self.delegate?.launchManager(self, didFinishWith: self.status)
        }
    }

    func launchApp(with: [UIApplication.LaunchOptionsKey: Any]?) {

        Parse.enableLocalDatastore()
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = self.url
            configuration.clientKey = self.clientKey
            configuration.applicationId = self.appID
        }))

        if let user = PFUser.current(), let identity = user.objectId {
            self.authenticateChatClient(with: identity)
        } else {
            self.createAnonymousUser()
        }
    }

    func createAnonymousUser() {
        PFAnonymousUtils.logIn { (user, error) in
            guard let anonymousUser = user, let identifier = anonymousUser.objectId else { return }
            self.authenticateChatClient(with: identifier)
        }
    }

    func authenticateChatClient(with identity: String) {
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are running
        // the PHP starter app on your local machine, as instructed in the quick start guide
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let urlString = "\(self.tokenURL)?identity=\(identity)&device=\(deviceId)"

        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let token = token {
                // Set up Twilio Chat client
                ChannelManager.initialize(token: token)
                self.finishedInitialFetch = true
                self.status = .success(object: nil)
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

    func registerDevice(_ identity: String, deviceToken: String) {

        // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
        let session = URLSession.shared

        let url = URL(string: self.serverURL + self.path)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let params = ["identity": identity,
                      "BindingType" : "apn",
                      "Address" : deviceToken]

        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData

        let requestBody = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        print("Request Body: \(requestBody ?? "")")

        let task = session.dataTask(with: request, completionHandler: {
            (responseData, response, error) in

            if let responseData = responseData {
                let responseString = String(data: responseData, encoding: String.Encoding.utf8)

                print("Response Body: \(responseString ?? "")")
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                    if let responseDictionary = responseObject as? [String: Any] {
                        if let message = responseDictionary["message"] as? String {
                            print("Message: \(message)")
                        }
                    }
                    print("JSON: \(responseObject)")
                } catch let error {
                    print("Error: \(error)")
                }
            }
        })

        task.resume()
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
