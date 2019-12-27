//
//  FavoritesViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse 

class FavoritesViewController: CollectionViewController<FavoriteCell, FavoritesCollectionViewManager> {

    init() {
        super.init(with: FavoritesCollectionView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initializeViews() {
        super.initializeViews()

        guard let objectId = User.current()?.objectId else { return }

        User.initializeArrayQuery(notEqualTo: objectId)
            .observe { (result) in
                switch result {
                case .success(let users):
                    self.manager.set(newItems: users)
                case .failure(_):
                    break
                }
        }
    }


    private func createChannel(with inviteeIdentifier: String,
                               title: String,
                               description: String) {

        //self.createButton.isLoading = true

        ChannelSupplier.createChannel(channelName: title,
                                     channelDescription: description,
                                     type: .private)
            .joinIfNeeded()
            .sendInitialMessage()
            .invite(personUserID: inviteeIdentifier)
            .withProgressBanner("Creating conversation")
            .withErrorBanner()
            .ignoreUserInteractionEventsUntilDone(for: self.view)
            .observe { (result) in
                //self.createButton.isLoading = false
                switch result {
                case .success(let channel):
                    break
                    //self.delegate.newChannelView(self, didCreate: .channel(channel))
                case .failure(let error):
                    if let tomorrowError = error as? ClientError {
                        print(tomorrowError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}
