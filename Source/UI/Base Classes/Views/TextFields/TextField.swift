//
//  TextField.swift
//  Benji
//
//  Created by Benji Dodgson on 12/31/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class TextField: UITextField {

    override var text: String? {
        get {
            return super.text
        }
        set {
            guard super.text != newValue else { return }
            if let newText = newValue {
                super.text = newText
            } else {
                super.text = newValue
            }
            self.onTextChanged?()
        }
    }

    var onTextChanged: (() -> ())?
    var onEditingEnded: (() -> ())?

    init() {
        super.init(frame: .zero)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        self.addTarget(self,
                       action: #selector(handleTextChanged),
                       for: UIControl.Event.editingChanged)
        self.addTarget(self,
                       action: #selector(handleEditingEnded),
                       for: [.editingDidEnd, .editingDidEndOnExit])
    }

    @objc private func handleTextChanged() {
        self.onTextChanged?()
    }

    @objc private func handleEditingEnded() {
        self.onEditingEnded?()
    }

    func setDefaultAttributes(style: StringStyle, alignment: NSTextAlignment = .left) {
        self.defaultTextAttributes = style.attributes
        self.textAlignment = alignment
    }

    func setPlaceholder(attributed: AttributedString, alignment: NSTextAlignment = .left) {
        self.attributedPlaceholder = attributed.string
        self.textAlignment = alignment
    }

    func set(attributed: AttributedString, alignment: NSTextAlignment = .left) {
        //APPLE BUG: Trying to set both the attributed text AND the defaultAttributes will cause a memory crash
        self.text = attributed.string.string
        self.setDefaultAttributes(style: attributed.style, alignment: alignment)
    }
}
