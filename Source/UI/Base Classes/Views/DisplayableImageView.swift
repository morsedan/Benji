//
//  DisplayableImageView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/4/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

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
        } else if let photoUrl = self.displayable.photoUrl {
            self.downloadAndSetImage(url: photoUrl)
        }
    }

    private func downloadAndSetImage(url: URL) {
        //Possible Parse integration
//        self.imageView.sd_setImage(with: url,
//                                   completed: { [weak self] (image, error, imageCacheType, imageUrl) in
//                                    guard let `self` = self, image != nil else { return }
//                                    self.imageView.image = image
//        })
    }
}
