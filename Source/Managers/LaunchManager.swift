//
//  LaunchManager.swift
//  Benji
//
//  Created by Benji Dodgson on 1/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class LaunchManager {

    static let shared = LaunchManager()

    // Important - update this URL with your Twilio Function URL
    let tokenURL = "https://violet-lionfish-6641.twil.io/chat-token"

    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    var identity = "Benji"

    func launchApp() {

        self.login()
    }

    func login() {
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
