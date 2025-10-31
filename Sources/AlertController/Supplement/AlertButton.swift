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
        fadeDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        fadeRestore()
        
        if let touch = touches.first, bounds.contains(touch.location(in: self)) {
            DispatchQueue.main.async {
                self.action.block()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        fadeRestore()
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

private extension UIView {
    func fadeDown(animated: Bool = true) {
        if animated {
            withCardSpringAnimation(duration: 0.2) {
                self.alpha = 0.25
            }
        } else {
            alpha = 0.25
        }
    }

    func fadeRestore(animated: Bool = true) {
        if animated {
            withCardSpringAnimation(duration: 0.3) {
                self.alpha = 1.0
            }
        } else {
            alpha = 1.0
        }
    }
}

private func withCardSpringAnimation(
    duration: TimeInterval = 0.75,
    delay: TimeInterval = 0,
    damping: CGFloat = 1.0,
    velocity: CGFloat = 0.5,
    options: UIView.AnimationOptions = [.allowUserInteraction, .allowAnimatedContent],
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
) {
    UIView.animate(
        withDuration: duration,
        delay: delay,
        usingSpringWithDamping: damping,
        initialSpringVelocity: velocity,
        options: options,
        animations: animations,
        completion: completion
    )
}
