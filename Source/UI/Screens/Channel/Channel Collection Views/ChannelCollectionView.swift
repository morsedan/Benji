//
//  ChannelCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 12/28/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionView: CollectionView {

    lazy var emptyView = EmptyChannelView()

    var channelLayout: ChannelCollectionViewFlowLayout {
        guard let layout = collectionViewLayout as? ChannelCollectionViewFlowLayout else {
            fatalError("ChannelCollectionViewFlowLayout NOT FOUND")
        }
        return layout
    }

    var isTypingIndicatorHidden: Bool {
        return self.channelLayout.isTypingIndicatorViewHidden
    }

    init() {
        super.init(flowLayout: ChannelCollectionViewFlowLayout())
        self.registerReusableViews()
        self.backgroundView = self.emptyView
        self.backgroundView?.alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateEmptyView(shouldShow: Bool) {
        UIView.animate(withDuration: Theme.animationDuration) {
            self.backgroundView?.alpha = shouldShow ? 1 : 0
        }
    }

    private func registerReusableViews() {
        self.register(MessageCell.self)
        self.register(TypingIndicatorCell.self)
        self.register(ChannelSectionHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        self.register(InitialSectionHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        self.register(LoadMoreSectionHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let dataSource = self.channelLayout.dataSource, dataSource.sections.count > 0 {
            self.emptyView.isHidden = false
        } else {
            self.emptyView.isHidden = true 
        }

        self.emptyView.frame = self.backgroundView?.bounds ?? .zero
    }
}
