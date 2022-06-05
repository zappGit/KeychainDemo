import Foundation
import UIKit
import SnapKit

protocol SetViewDelegate {
    func setupPicherView()
}

class SetView: UIView {
    var delegate: SetViewDelegate?
    let profileImageButtonHeight: CGFloat = 120
    let avatarView: UIButton = {
        var button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        return button
    }()
    private let text: UITextField = {
        var textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        return textField
    }()
    private let switchControl: UISwitch = {
        let isPrivateSwitch = UISwitch()
        isPrivateSwitch.onTintColor = #colorLiteral(red: 0.9921568627, green: 0.7960784314, blue: 0.431372549, alpha: 1)
        isPrivateSwitch.isOn = false
        isPrivateSwitch.layer.cornerRadius = 16
        isPrivateSwitch.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        isPrivateSwitch.addTarget(self, action: #selector(switchTapp), for: .valueChanged)
        return isPrivateSwitch
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Доступ запрещен"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAvatar()
        setupTextField()
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAvatar() {
        addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.height.width.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTextField() {
        addSubview(text)
        text.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).inset(-16)
        }
    }
    
    private func setupStack() {
        let stack = UIStackView(arrangedSubviews: [switchControl, label])
        stack.distribution = .fill
        stack.spacing = 16
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(text.snp.bottom).inset(-16)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func profileImageButtonTapped() {
        delegate?.setupPicherView()
    }
    
    @objc private func switchTapp(mySwitch: UISwitch) {
        mySwitch.isOn ? (label.text = "Доступ разрешен") : (label.text = "Доступ запрещен")
    }
    
    func setupImage(image: UIImage) {
        avatarView.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

