//
//  UserNotificationManager.swift
//  Benji
//
//  Created by Benji Dodgson on 9/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import UserNotifications
import TMROLocalization
import TwilioChatClient

class UserNotificationManager: NSObject {


    //Temp Twilio Funciton to register for push notifications
    private var serverURL = "https://topaz-booby-6355.twil.io"
    private var registerPath = "/register-binding"
    private var sendPath = "/send-notification"

    static let shared = UserNotificationManager()

    let center = UNUserNotificationCenter.current()

    // NOTE: Retrieves the notification settings synchronously.
    // WARNING: Use with caution as it will block whatever thread it is
    // called on until a setting is retrieved.
    func getNotificationSettingsSynchronously() -> UNNotificationSettings {

        // To avoid read/write issues inherent to multithreading, create a serial dispatch queue
        // so that mutations to the notification setting var happening synchronously
        let notificationSettingsQueue = DispatchQueue(label: "notificationsQueue")

        var notificationSettings: UNNotificationSettings?

        self.center.getNotificationSettings { (settings) in
            notificationSettingsQueue.sync {
                notificationSettings = settings
            }
        }

        // Wait in a loop until we get a result back from the notification center
        while true {
            var result: UNNotificationSettings?

            // IMPORTANT: Perform reads synchrononously to ensure the value if fully written before a read.
            // If the sync is not performed, this function may never return.
            notificationSettingsQueue.sync {
                result = notificationSettings
            }

            if let strongResult = result {
                return strongResult
            }
        }
    }

    func silentRegister(withApplication application: UIApplication) {

        self.center.getNotificationSettings() { (settings) in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                runMain {
                    application.registerForRemoteNotifications()  // To update our token
                }
            case .notDetermined:
                let options: UNAuthorizationOptions = [.alert,.sound,.badge, .provisional]

                self.register(with: options, application: application, completion: { (success, error) in

                })
            case .denied:
                break
            @unknown default:
                break
            }
        }
    }

    func register(with options: UNAuthorizationOptions,
                  application: UIApplication,
                  completion: @escaping ((Bool, Error?) -> Void)) {

        self.center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                runMain {
                    application.registerForRemoteNotifications()  // To update our token
                }
            } else {
                print("User Notification permission denied: \(String(describing: error?.localizedDescription))")
            }
            completion(granted, error)
        }
    }

    func clearNotificationCenter() {
        let count = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.applicationIconBadgeNumber = count
    }

    func schedule(note: UNNotificationRequest) {
        self.center.add(note, withCompletionHandler: { (error) in
            if let e = error {
                print("NOTIFICATION \(e)")
            }
        })
    }

    func registerDevice(_ identity: String, deviceToken: String) {

        // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
        let session = URLSession.shared

        let url = URL(string: self.serverURL + self.registerPath)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let params = ["identity": identity,
                      "BindingType" : "apn",
                      "Address" : deviceToken]

        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData

        let task = session.dataTask(with: request, completionHandler: {
            (responseData, response, error) in

            if let responseData = responseData {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                    if let responseDictionary = responseObject as? [String: Any] {
                        if let message = responseDictionary["message"] as? String {
                            print("Message: \(message), for: \(identity)")
                        }
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        })

        task.resume()
    }

    func notify(channel: TCHChannel, body: String) {
        channel.getNonMeMembers()
            .observe { (result) in
                switch result {
                case .success(let members):
                    let identities = members.map { (member) -> String in
                        return String(optional: member.identity)
                    }

                    self.notify(identities: identities, body: body)
                case .failure(_):
                    break
                }
        }
    }

    private func notify(identities: [String], body: String) {

        guard let first = identities.first else { return }

        let session = URLSession.shared

        let url = URL(string: self.serverURL + self.sendPath)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let params = ["identity": first,
                      "body" : body]

        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData

        let task = session.dataTask(with: request, completionHandler: {
            (responseData, response, error) in

            if let responseData = responseData {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                    if let responseDictionary = responseObject as? [String: Any] {
                        if let message = responseDictionary["message"] as? String {
                            print("Message: \(message), for: \(first)")
                        }
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        })

        task.resume()
    }
}
