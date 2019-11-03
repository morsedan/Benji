//
//  Person.swift
//  Benji
//
//  Created by Benji Dodgson on 11/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

enum PersonKey: String {
    case givenName
    case familyName
    case email
    case phoneNumber
    case smallImage
    case largeImage
    case connection
}

final class Person: Object {

    var givenName: String? {
        get {
            return self.getObject(for: .givenName)
        }
        set {
            self.setObject(for: .givenName, with: newValue)
        }
    }

    var familyName: String? {
        get {
            return self.getObject(for: .familyName)
        }
        set {
            self.setObject(for: .familyName, with: newValue)
        }
    }

    var email: String? {
        get {
            return self.getObject(for: .email)
        }
        set {
            self.setObject(for: .email, with: newValue)
        }
    }

    var phoneNumber: String? {
        get {
            return self.getObject(for: .phoneNumber)
        }
        set {
            self.setObject(for: .phoneNumber, with: newValue)
        }
    }

    var smallImage: PFFileObject? {
        get {
            return self.getObject(for: .smallImage)
        }
        set {
            self.setObject(for: .smallImage, with: newValue)
        }
    }

    var largeImage: PFFileObject? {
        get {
            return self.getObject(for: .largeImage)
        }
        set {
            self.setObject(for: .largeImage, with: newValue)
        }
    }

    var connection: PFRelation<Conneciton>? {
        get {
            return self.getObject(for: .connection)
        }
        set {
            self.setObject(for: .connection, with: newValue)
        }
    }
}

extension Person {

    func formatName(from text: String) {
        let components = text.components(separatedBy: " ").filter { (component) -> Bool in
            return !component.isEmpty
        }
        if let first = components.first {
            self.givenName = first
        }
        if let last = components.last {
            self.familyName = last
        }
    }

    func getProfileImage(completion: @escaping (UIImage?) -> Void) {
//        guard let imageFile = self[UserKey.smallProfileImageFile.rawValue] as? PFFileObject else { return }
//
//        imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
//            guard let data = imageData else { return }
//            let image = UIImage(data: data)
//            completion(image)
//        }
    }
}

extension Person: Avatar {

    var person: Person? {
        return self
    }

    var image: UIImage? {
        return nil
    }

    var userObjectID: String? {
        self.objectId
    }
}
