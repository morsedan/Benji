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

class DisplayableImageView: UIView {

    var delegate: DisplayableDelegate?
    var containerColor: TomorrowColor

    private let imageView = UIImageView()
    private let highlightView = HighlightView()

    var displayable: ImageDisplayable {
        didSet {
            self.updateImageView()
            self.setNeedsLayout()
            self.delegate?.didSet(displayable: self.displayable)
        }
    }

    init(displayable: ImageDisplayable = UIImage(),
         highlightOnTouch: Bool,
         containerColor: TomorrowColor) {

        self.containerColor = containerColor
        self.displayable = displayable

        super.init(frame: CGRect.zero)

        self.initializeView(addHighlightView: highlightOnTouch)
    }

    required init?(coder aDecoder: NSCoder) {
        self.containerColor = .clear
        self.displayable = UIImage()

        super.init(coder: aDecoder)

        self.initializeView(addHighlightView: true)
    }

    private func initializeView(addHighlightView: Bool) {
        self.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFill
        self.layer.borderWidth = TomorrowTheme.borderWidth
        self.updateImageView()

        if addHighlightView {
            self.addSubview(self.highlightView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.width = self.width - 1
        self.imageView.height = self.height - 1
        self.imageView.centerOnXAndY()
        self.imageView.makeRound()

        self.updateBorder()

        self.highlightView.makeRound(masksToBounds: false)
    }

    func updateBorder() {
        self.makeRound(masksToBounds: true)
        self.layer.borderColor = TomorrowColor.white.cgColor
    }

    private func updateImageView() {
        if let photo = self.displayable.photo {
            self.imageView.image = photo
        } else if let photoUrl = self.displayable.photoUrl {
            self.downloadAndSetImage(url: photoUrl)
        } else {
            self.imageView.image = self.displayable.icon.getImage(forBackgroundColor: self.containerColor)
        }
    }

    private func downloadAndSetImage(url: URL) {
        self.imageView.sd_setImage(with: url,
                                   completed: { [weak self] (image, error, imageCacheType, imageUrl) in
                                    guard let `self` = self, image != nil else { return }
                                    self.imageView.image = image
        })
    }
}
