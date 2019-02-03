//
//  LaunchManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class LaunchManager {

    static let shared = LaunchManager()

    // Important - update this URL with your Twilio Function URL
    private let tokenURL = "https://violet-lionfish-6641.twil.io/chat-token"

    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    private let identity = "Benji"
    private let url = "https://benji-ios.herokuapp.com/parse"
    private let appID = "benjamindodgson.Benji"
    private let clientKey = "myMasterKey"
    private let tempPhone = "2068509234"//Used for demo

    func launchApp() {
        Parse.enableLocalDatastore()

        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = self.url
            configuration.clientKey = self.clientKey
            configuration.applicationId = self.appID
        }))

        if PFUser.current() != nil {
            self.authenticateChatClient()
        } else {
            PFUser.logInWithUsername(inBackground: self.tempPhone, password: self.tempPhone, block: { (user, error) in
                if user != nil {
                    self.authenticateChatClient()
                }

                if error != nil {
                    print(error.debugDescription)
                }
            })
        }

        self.authenticateChatClient()
    }

    func authenticateChatClient() {
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are running
        // the PHP starter app on your local machine, as instructed in the quick start guide
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let urlString = "\(self.tokenURL)?identity=\(self.identity)&device=\(deviceId)"

        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let token = token {
                //Setup Access manager with token
                // Set up Twilio Chat client
                ChannelManager.shared.initialize(token: token, completion: { (client, error) in
                    //Do something now that its done.
                })
            } else {
                print("Error retrieving token: \(error.debugDescription)")
            }
        }
    }

    func logout() {
        if let client = ChannelManager.shared.client  {
            client.delegate = nil
            client.shutdown()
        }
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