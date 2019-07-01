//
//  ContactAuthorizationAlertController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts

class ContactAuthorizationAlertController: PagingModalController {

    enum Result {
        case denied
        case authorized
    }
    var onAuthorization: ((Result) -> Void)?

    init(status: CNAuthorizationStatus) {

        super.init(contentViewControllers: [])

        if let textController = self.createTextCard(with: status) {
            self.configure(contentViewControllers: [textController])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createTextCard(with status: CNAuthorizationStatus) -> TextAlertViewController? {

        var text: Localized = ""
        var buttons: [LoadingButton] = []

        switch status {
        case .denied:
            text = LocalizedString(id: "alert.contactauthorizationdenied.text",
                                   default: "You can change address book permissions in your settings.")

            let settingsTitle = LocalizedString(id: "alert.contactauthorizationdenied.changesettings",
                                                default: "CHANGE SETTINGS")
            let settingsButton = LoadingButton()
            settingsButton.set(style: .rounded(color: .blue, text: settingsTitle)) {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }

            let nevermindButton = LoadingButton()
            nevermindButton.set(style: .rounded(color: .clear,
                                                text: CommonWord.nevermind(.uppercase).localizedString)) { [weak self] in
                guard let `self` = self else { return }

                 self.onAuthorization?(.denied)
            }

            buttons = [settingsButton, nevermindButton]

        case .notDetermined:

            text = LocalizedString(id: "alert.contactauthorizationnotdetermined.text",
                                   default: "Invite contacts from your phone with peace of mind knowing that their information never leaves the device.")

            let allowTitle = LocalizedString(id: "alert.contactauthorizationnotdetermined.allow",
                                             default: "ALLOW")
            let allowButton = LoadingButton()
            allowButton.set(style: .rounded(color: .blue, text: allowTitle)) { [weak self] in
                guard let `self` = self else { return }

                self.onAuthorization?(.authorized)
            }

            let notNowButton = LoadingButton()
            notNowButton.set(style: .rounded(color: .clear, text: CommonWord.maybelater(.uppercase).localizedString)) { [weak self] in
                guard let `self` = self else { return }

                self.onAuthorization?(.denied)
            }

            buttons = [allowButton, notNowButton]

        case .authorized:
            return nil

        case .restricted:
            
            text = LocalizedString(id: "alert.contactauthorizationrestricted.text",
                                   default: "Tomorrow can't access your contacts because of a parental setting.")

            let okButton = LoadingButton()
            okButton.set(style: .rounded(color: .blue, text: CommonWord.ok(.uppercase).localizedString)) { [weak self] in
                guard let `self` = self else { return }

                self.onAuthorization?(.denied)
            }

            buttons = [okButton]

        @unknown default:
            return nil
        }

        return TextAlertViewController(localizedText: text,
                                       buttons: buttons)
    }
}
