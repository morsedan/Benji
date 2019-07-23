//
//  TextAlertViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TextAlertViewController: AlertViewController {

    init(localizedText: Localized,
         buttons: [LoadingButton]) {

        super.init(childViewController: TextViewController(),
                   buttons: buttons)

        self.configure(localizedText: localizedText,
                       loadingButtons: buttons)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(localizedText: Localized?,
                   loadingButtons: [LoadingButton]?) {

        if let buttons = loadingButtons {
            self.configure(buttons: buttons)
        }

        if let text = localizedText, let textVC = self.childViewController as? TextViewController   {
            textVC.localizedText = text
        }
    }
}

private class TextViewController: ViewController, UITextViewDelegate {

    let textView = TextView()
    var localizedText: Localized? {
        didSet {
            guard let text = self.localizedText else { return }
            
            let attributed = AttributedString(text,
                                              fontType: .regular,
                                              color: .white)

            self.textView.set(attributed: attributed,
                              alignment: .center)
            self.view.layoutNow()
        }
    }

    override init() {
        super.init()
        self.view.addSubview(self.textView)
        self.textView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.textView.width = self.view.width
        self.textView.sizeToFit()
        self.textView.centerOnX()
        self.textView.centerY = self.view.centerY - 30
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        if URL.absoluteString == "tomorrowplus" {
//            self.presentSubscriptionCard(initialCard: .plus)
//        } else {
//            self.presentURL(URL)
//        }
        return true
    }
}
