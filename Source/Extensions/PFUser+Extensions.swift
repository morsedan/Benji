//
//  User.swift
//  Benji
//
//  Created by Benji Dodgson on 6/23/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

extension PFUser: Avatar {

    static var current: PFUser = PFUser.current()!

    var user: PFUser? {
        return self
    }

    var photo: UIImage? {
        return nil
    }

    var largeProfileImageFile: PFFileObject? {
        get {
            return self.userObject(for: .largeProfileImageFile)
        }
        set {
            self.setUserObject(for: .largeProfileImageFile, with: newValue)
        }
    }

    var smallProfileImageFile: PFFileObject? {
        get {
            return self.userObject(for: .smallProfileImageFile)
        }
        set {
            self.setUserObject(for: .smallProfileImageFile, with: newValue)
        }
    }

    var initials: String {
        let firstInitial = String(optional: self.firstName.first?.uppercased())
        let lastInitial = String(optional: self.lastName.first?.uppercased())
        return firstInitial + lastInitial
    }

    var firstName: String {
        get {
            return self.userObject(for: .firstName) ?? String()
        }
        set {
            self.setUserObject(for: .firstName, with: newValue)
        }
    }

    var lastName: String {
        get {
            return self.userObject(for: .lastName) ?? String()
        }
        set {
            self.setUserObject(for: .lastName, with: newValue)
        }
    }

    var handle: String {
        get {
            return self.userObject(for: .handle) ?? String()
        }
        set {
            self.setUserObject(for: .handle, with: newValue)
        }
    }

    var userObjectID: String? {
        return self.objectId
    }

    func parseName(from text: String) {
        let components = text.components(separatedBy: " ").filter { (component) -> Bool in
            return !component.isEmpty
        }
        if let first = components.first {
            self.firstName = first 
        }
        if let last = components.last {
            self.lastName = last
        }
    }

    func createHandle() {
        guard let last = self.lastName.first, let id = self.objectId else { return }
        self.handle = self.firstName + String(last) + "_" + id
    }

    static func cachedQuery(for objectID: String, completion: ((PFObject?, Error?) -> Void)?) {
        guard let query = self.query() else { return }
        query.cachePolicy = .cacheThenNetwork
        query.whereKey(UserKey.objectId.rawValue, equalTo: objectID)
        query.getFirstObjectInBackground(block: completion)
    }

    func getProfileImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageFile = self[UserKey.smallProfileImageFile.rawValue] as? PFFileObject else { return }

        imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
            guard let data = imageData else { return }
            let image = UIImage(data: data)
            completion(image)

        
        }
    }
}

extension PFUser {

    var phoneNumber: String? {
        get {
            return self.userObject(for: .phoneNumber) ?? String()
        }
        set {
            self.setUserObject(for: .phoneNumber, with: newValue)
        }
    }
}

extension PFUser: DisplayableCellItem {
    
    var backgroundColor: Color {
        return .purple
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self.objectId! as NSObjectProtocol
    }
}
