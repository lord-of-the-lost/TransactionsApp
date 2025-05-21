//
//  BaseCell.swift
//  Core
//
//  Created by Николай Игнатов on 21.05.2025.
//

import UIKit

public class BaseCell: UITableViewCell {
    public static let identifier = BaseCell.description()

    private lazy var leftText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightText: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        leftText.text = nil
        rightText.text = nil
        accessoryType = .none
    }
    
    // MARK: - Configure
    public func configure(with model: BaseCellViewModel) {
        leftText.text = model.leftText
        rightText.text = model.rightText
        accessoryType = model.needDisclosureIndicator ? .disclosureIndicator : .none
    }
}

// MARK: - BaseCellViewModel
extension BaseCell {
    public struct BaseCellViewModel {
        let leftText: String
        let rightText: String
        let needDisclosureIndicator: Bool
        
        public init(
            leftText: String,
            rightText: String,
            needDisclosureIndicator: Bool = false
        ) {
            self.leftText = leftText
            self.rightText = rightText
            self.needDisclosureIndicator = needDisclosureIndicator
        }
    }
}

// MARK: - Private Methods
private extension BaseCell {
    func setupView() {
        contentView.addSubview(leftText)
        contentView.addSubview(rightText)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rightText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            rightText.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            rightText.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

            leftText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftText.trailingAnchor.constraint(lessThanOrEqualTo: rightText.leadingAnchor, constant: -8),
            leftText.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            leftText.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
