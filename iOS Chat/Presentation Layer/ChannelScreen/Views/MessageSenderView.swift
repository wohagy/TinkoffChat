//
//  MessageSenderView.swift
//  iOS Chat
//
//  Created by Macbook on 09.04.2022.
//

import UIKit

protocol IMessageSenderView: UIView {
    var sendButton: UIButton { get }
    var photoButton: UIButton { get }
    func getTextViewMessage() -> String?
    func endEditing()
}

final class MessageSenderView: UIView, IMessageSenderView {
        
    var colors: IThemeColors?

    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
     private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = colors?.backgroundWhite
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = #colorLiteral(red: 0.874432981, green: 0.8745591044, blue: 0.8744053245, alpha: 1)
        return textView
    }()
    
    init(colors: IThemeColors?, frame: CGRect) {
        self.colors = colors
        super.init(frame: frame)
        self.backgroundColor = .none
        addSubview(sendButton)
        addSubview(messageTextView)
		addSubview(photoButton)
        setupConstraints()
        messageTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextViewMessage() -> String? {
        let trimmedMessage = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return nil }
        messageTextView.text = ""
        sendButton.tintColor = .label
        return trimmedMessage
    }
    
    func endEditing() {
        messageTextView.endEditing(true)
    }
    
    private func setupConstraints() {
    
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            messageTextView.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 5),
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5),
            
            photoButton.heightAnchor.constraint(equalToConstant: 40),
            photoButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            photoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            photoButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}

extension MessageSenderView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.tintColor = messageTextView.text.isEmpty ? .label : .blue
    }
}
