//
//  InviteModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/2/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts
import MessageUI

// Creating a delegate object for the message composer because MFMessageComposeViewControllerDelegate
// must conform to NSObjectProtocol and I don't want to force coordinators to be NSObjects.
private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {

    var onComposerDidFinish: (MessageComposeResult, MFMessageComposeViewController) -> Void

    init(onComposerDidFinish: @escaping (MessageComposeResult, MFMessageComposeViewController) -> Void) {
        self.onComposerDidFinish = onComposerDidFinish
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        self.onComposerDidFinish(result, controller)
    }
}

protocol ComposerViewControllerDelegate: class {
    func composerViewControllerDidFinish(_ controller: ComposerViewController)
}

class ComposerViewController: ViewController, Sizeable {

    var contacts: [CNContact] = []
    unowned let delegate: ComposerViewControllerDelegate

    private lazy var composerDelegate = MessageComposerDelegate { [unowned self] (result, controller) in
        self.handleMessageComposer(result: result, controller: controller)
    }
    
    lazy var messageComposerVC = MessageComposerViewController()

    init(delegate: ComposerViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        //Animate load then show messagecomposer
        
    }

    private func presentMessageComposer(with contact: CNContact) {
        // The message composer won't initialize properly if texts aren't enabled on the device
        guard MessageComposerViewController.canSendText(), let phoneNumber = contact.primaryPhoneNumber else { return }

        let vc = MessageComposerViewController()
        let message = self.createMessage()

        vc.body = message
        vc.recipients = [phoneNumber]
        vc.messageComposeDelegate = self.composerDelegate

        //self.router.present(vc, source: self)
    }

    private func createMessage() -> String {
        return "Some invite message"
    }

    func handleMessageComposer(result: MessageComposeResult, controller: MFMessageComposeViewController) {

         var inviteSent = false

         switch result {
         case .cancelled:
             break
         case .failed:
             break
         case .sent:
             inviteSent = true
         @unknown default:
             break
         }

         //self.router.dismiss(source: controller, animated: true) {
             // go to the next one?
         //}
     }
}
