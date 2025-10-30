//
//  AlertButton.swift
//  AlertController
//
//  Created by 秋星桥 on 2/22/25.
//

import UIKit

class AlertButton: UIView {
    let action: ActionContext.Action

    let label = UILabel()

    init(action: ActionContext.Action) {
        self.action = action
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        label.text = action.title
        label.textColor = action.foregroundColor
        label.textAlignment = .center
        label.font = action.font

        layer.borderWidth = 1
        backgroundColor = action.backgroundColor

        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        
        updateBorderColor()

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])

        isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
        
        if let touch = touches.first, bounds.contains(touch.location(in: self)) {
            DispatchQueue.main.async {
                self.action.block()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorderColor()
        }
    }
    
    private func updateBorderColor() {
        layer.borderColor = action.borderColor.cgColor
    }
}

extension ActionContext.Action {
    var foregroundColor: UIColor {
        switch attribute {
        case .dangerous:
            .white
        case .normal:
            AlertControllerConfiguration.accentColor
        }
    }

    var backgroundColor: UIColor {
        switch attribute {
        case .dangerous:
            AlertControllerConfiguration.accentColor
        case .normal:
            .clear
        }
    }

    var borderColor: UIColor {
        switch attribute {
        default:
            AlertControllerConfiguration.accentColor
        }
    }

    var font: UIFont {
        switch attribute {
        case .dangerous:
            .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        case .normal:
            .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        }
    }
}
