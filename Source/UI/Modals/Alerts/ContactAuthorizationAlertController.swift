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
            break
//            text = TomorrowString(id: "alert.contactauthorizationdenied.text",
//                                  default: "You can change address book permissions in your settings.")
//
//            let settingsTitle = TomorrowString(id: "alert.contactauthorizationdenied.changesettings",
//                                               default: "CHANGE SETTINGS")
//            let settingsButton = FooterButton(localizedTitle: settingsTitle, color: .blue2) {
//                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
//                    UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.open(settingsUrl)
//                }
//            }
//
//            let nevermindButton = FooterButton(localizedTitle: CommonWord.nevermind(.uppercase).localizedString,
//                                               color: .clear) { [unowned self] in
//                                                self.onAuthorization?(.denied)
//            }
//            buttons = [settingsButton, nevermindButton]
//
//            icon = Icon.PhoneIcon.darkImage

        case .notDetermined:
            break
//            text = TomorrowString(id: "alert.contactauthorizationnotdetermined.text",
//                                  default: "Tomorrow can import your info, so you don't have to type it in.")
//
//            let allowTitle = TomorrowString(id: "alert.contactauthorizationnotdetermined.allow",
//                                            default: "ALLOW")
//            let allowButton = FooterButton(localizedTitle: allowTitle, color: .blue2) { [unowned self] in
//                self.onAuthorization?(.authorized)
//            }
//
//            let notNowTitle = TomorrowString(id: "alert.contactauthorizationnotdetermined.type",
//                                             default: "I'LL TYPE IT IN")
//            let notNowButton = FooterButton(localizedTitle: notNowTitle, color: .clear) { [unowned self] in
//                self.onAuthorization?(.denied)
//            }
//
//            buttons = [allowButton, notNowButton]
//
//            icon = Icon.FamilyIcon.darkImage

        case .authorized:
            return nil

        case .restricted:
            break 
//            text = TomorrowString(id: "alert.contactauthorizationrestricted.text",
//                                  default: "Tomorrow can't access your contacts because of a parental setting.")
//
//            let okTitle = TomorrowString(id: "alert.contactauthorizationrestricted.ok",
//                                         default: "OK")
//            let okButton = FooterButton(localizedTitle: okTitle, color: .blue2) { [unowned self] in
//                self.onAuthorization?(.denied)
//            }
//
//            buttons = [okButton]
//
//            icon = Icon.FatherIcon.darkImage

        @unknown default:
            return nil
        }

        return TextAlertViewController(localizedText: text,
                                       buttons: buttons)
    }
}
