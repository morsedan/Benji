//
//  SplashViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SplashViewController: FullScreenViewController {

    let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let label = RegularSemiBoldLabel()
    
    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.loadingIndicator)
        self.contentContainer.addSubview(self.label)

        self.subscribeToUpdates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.loadingIndicator.centerOnXAndY()
        self.label.setSize(withWidth: self.view.width * 0.8)
        self.label.top = self.loadingIndicator.bottom + 10
        self.label.centerOnX()
    }

    private func subscribeToUpdates() {

        self.loadingIndicator.startAnimating()
        self.label.set(text: "Loading...",
                       alignment: .center,
                       stringCasing: .uppercase)

        ChannelManager.shared.clientSyncUpdate.producer.on { [weak self] (update) in
            guard let `self` = self, let clientUpdate = update else { return }

            switch clientUpdate {
            case .started:
                break
            case .channelsListCompleted:
                self.loadingIndicator.startAnimating()
                self.label.set(text: "Loading Messages...",
                               alignment: .center,
                               stringCasing: .uppercase)
            case .completed:
                self.loadingIndicator.stopAnimating()
                self.label.set(text: "Success 😁",
                               alignment: .center,
                               stringCasing: .uppercase)
            case .failed:
                self.loadingIndicator.stopAnimating()
                self.label.set(text: "Something went wrong 😓",
                               alignment: .center,
                               stringCasing: .uppercase)
            @unknown default:
                break
            }
            self.view.layoutNow()
            }
            .start()
    }
}
