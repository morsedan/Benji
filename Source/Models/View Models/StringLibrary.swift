//
//  StringLibrary.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct StringLibrary {

    static var shared = StringLibrary()

    var library: Dictionary<String, String> {
        didSet {
            self.addToPlist(dictionary: self.library)
        }
    }

    init() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/localization.plist")
        if let dict = NSDictionary(contentsOfFile: path),
            let library = dict as? Dictionary<String, String> {
            self.library = library
        } else {
            self.library = [:]
        }
    }

    func getLocalizedString(for localized: Localized) -> String {
        var localizedString: String
        if let string = self.library[localized.identifier] {
            localizedString = string
        } else {
            localizedString = String(optional: localized.defaultString)
        }

        for (index, argument) in localized.arguments.enumerated() {
            let localizedArgument = StringLibrary.shared.getLocalizedString(for: argument)
            localizedString = localizedString.replacingOccurrences(of: "@\(index + 1)",
                with: localizedArgument)
        }
        return localizedString
    }

    private func addToPlist(dictionary: Dictionary<String, String>) {
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                          .userDomainMask, true)
            .first else { return }
        let path = documentDirectory.appending("/localization.plist")
        let plistContent = NSDictionary(dictionary: dictionary)
        plistContent.write(toFile: path, atomically: true)
    }
}

