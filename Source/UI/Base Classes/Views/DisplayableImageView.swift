//
//  DisplayableImageView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/4/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class DisplayableImageView: View {

    private(set) var imageView = UIImageView()

    var displayable: ImageDisplayable {
        didSet {
            self.updateImageView()
            self.setNeedsLayout()
        }
    }

    init(displayable: ImageDisplayable = UIImage()) {
        self.displayable = displayable
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        self.displayable = UIImage()
        super.init(coder: aDecoder)
    }

    override func initializeSubviews() {
        super.initializeSubviews()

        self.set(backgroundColor: .clear)
        self.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFill
        self.updateImageView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.frame = self.bounds
    }

    private func updateImageView() {
        if let photo = self.displayable.image {
            self.imageView.image = photo
        } else if let objectID = self.displayable.userObjectID {
            self.findUser(with: objectID)
        }
    }

    private func downloadAndSetImage(for user: User) {
        user.smallImage?.getDataInBackground { (imageData: Data?, error: Error?) in
            guard let data = imageData else { return }
            let image = UIImage(data: data)
            self.imageView.image = image
        }
    }

    private func findUser(with objectID: String) {
        User.localThenNetworkQuery(for: objectID)
            .observeValue(with: { (user) in
                self.downloadAndSetImage(for: user)
            })
    }
}
