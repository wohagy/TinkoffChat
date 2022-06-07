//
//  UIAllertController.swift
//  iOS Chat
//
//  Created by Macbook on 21.04.2022.
//

import UIKit

extension UIAlertController {
    @objc func textDidChange() {
        guard let text = textFields?.first?.text else { return }
        guard let addAction = actions.first(where: { $0.title == "Add" }) else { return }
        let trimText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        addAction.isEnabled = !trimText.isEmpty
    }
}
