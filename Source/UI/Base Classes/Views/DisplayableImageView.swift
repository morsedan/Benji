//
//  DisplayableImageView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/4/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

protocol DisplayableDelegate {
    func didSet(displayable: ImageDisplayable)
}

class DisplayableImageView: View {

    var delegate: DisplayableDelegate?

    private(set) var imageView = UIImageView()

    var displayable: ImageDisplayable {
        didSet {
            self.updateImageView()
            self.setNeedsLayout()
            self.delegate?.didSet(displayable: self.displayable)
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

    override func initialize() {
        super.initialize()

        self.set(backgroundColor: .clear)
        self.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFill
        self.updateImageView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.width = self.width - 1
        self.imageView.height = self.height - 1
        self.imageView.centerOnXAndY()
        self.imageView.makeRound()
    }

    private func updateImageView() {
        if let photo = self.displayable.photo {
            self.imageView.image = photo
        } else if let user = self.displayable.user {
            self.downloadAndSetImage(for: user)
        }
    }

    private func downloadAndSetImage(for user: PFUser) {
        //Possible Parse integration
        guard let imageFile = user["profilePicute"] as? PFFileObject else { return }
        
        imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
            guard let data = imageData else { return }
            self.imageView.image = UIImage(data: data)
        }
    }
}
