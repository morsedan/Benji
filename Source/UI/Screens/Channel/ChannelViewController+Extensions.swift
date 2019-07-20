//
//  ChannelViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension ChannelViewController {

    @objc func keyboardWillShow(notification: Notification) {

        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        self.showAnimator.addAnimations {
            self.contextButton.bottom = self.contentContainer.height - keyboardHeight - self.bottomOffset
            self.inputTextView.bottom = self.contextButton.bottom
            self.bottomGradientView.bottom = self.contentContainer.height - keyboardHeight
            self.channelCollectionVC.collectionView.height = self.contentContainer.height - keyboardHeight
            self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
        }

        self.showAnimator.addCompletion { (position) in
            if position == .end {
                self.channelCollectionVC.collectionView.scrollToBottom()
            }
        }

        self.showAnimator.stopAnimation(true)
        self.showAnimator.startAnimation()
    }

    @objc func keyboardWillHide(notification: Notification) {

        self.dismissAnimator.addAnimations {
            self.contextButton.bottom = self.contentContainer.height - self.view.safeAreaInsets.bottom - 16
            self.inputTextView.bottom = self.contextButton.bottom
            self.bottomGradientView.bottom = self.contentContainer.height
            self.channelCollectionVC.collectionView.height = self.contentContainer.height
            self.channelCollectionVC.collectionView.collectionViewLayout.invalidateLayout()
        }

        self.dismissAnimator.addCompletion { (position) in
            if position == .end {
                self.channelCollectionVC.collectionView.scrollToBottom()
            }
        }

        self.dismissAnimator.stopAnimation(true)
        self.dismissAnimator.startAnimation()
    }


    func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
}
