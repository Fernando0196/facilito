//
//  UIFloatingLabeledTextView.swift
//  facilito
//
//  Created by iMac Mario on 16/08/23.
//
import Foundation
import UIKit

class UIFloatingLabeledTextView: UITextView {

    var floatingLabel: UILabel!
    var placeHolderText: String?
    
    var floatingLabelColor = UIColor(red: 0/255, green: 26/255, blue: 97/255, alpha: 1) {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
        }
    }

    var floatingLabelHeight: CGFloat = 25

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupFloatingLabel()
    }

    private func setupFloatingLabel() {
        let floatingLabelFrame = CGRect(x: 0, y: -floatingLabelHeight, width: frame.width, height: floatingLabelHeight)
        floatingLabel = UILabel(frame: floatingLabelFrame)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = UIFont(name: "Poppins-Regular", size: 14)
        floatingLabel.text = placeHolderText  // Usar placeHolderText en lugar de placeholder
        addSubview(floatingLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }

    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
            }
            placeHolderText = ""
        }
    }

    @objc func textViewDidEndEditing(_ textView: UITextView) {
        if self.text == "" {
            UIView.animate(withDuration: 0.1) {
                self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
            }
            self.text = placeHolderText
        }
    }

    private func elevatePlaceholder() {
        if self.text != "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
            }
            placeHolderText = ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
