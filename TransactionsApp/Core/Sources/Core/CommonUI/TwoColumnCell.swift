//
//  TwoColumnCell.swift
//  Core
//
//  Created by Николай Игнатов on 21.05.2025.
//

import UIKit

public final class TwoColumnCell: UITableViewCell {
    public static let identifier = TwoColumnCell.description()

    private lazy var leftText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightText: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.rightLabel)
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
    
    public func configure(with model: TwoColumnCellViewModel) {
        leftText.text = model.leftText
        rightText.text = model.rightText
        accessoryType = model.needDisclosureIndicator ? .disclosureIndicator : .none
    }
}

// MARK: - ViewModel
extension TwoColumnCell {
    public struct TwoColumnCellViewModel {
        let leftText: String
        let rightText: String
        let needDisclosureIndicator: Bool
        
        public init(leftText: String, rightText: String, needDisclosureIndicator: Bool = false) {
            self.leftText = leftText
            self.rightText = rightText
            self.needDisclosureIndicator = needDisclosureIndicator
        }
    }
}

// MARK: - Private Methods
private extension TwoColumnCell {
    func setupView() {
        contentView.addSubview(leftText)
        contentView.addSubview(rightText)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            leftText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Constraints.horizontalPadding),
            leftText.trailingAnchor.constraint(lessThanOrEqualTo: rightText.leadingAnchor, constant: Constants.Constraints.interItemSpacing.negative),
            leftText.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: Constants.Constraints.verticalPadding),
            leftText.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: Constants.Constraints.verticalPadding.negative),
            
            rightText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.Constraints.horizontalPadding.negative),
            rightText.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: Constants.Constraints.verticalPadding),
            rightText.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: Constants.Constraints.verticalPadding.negative)
        ])
    }
}

// MARK: - Constants
private extension TwoColumnCell {
    enum Constants {
        enum Constraints {
            static let horizontalPadding: CGFloat = 16
            static let verticalPadding: CGFloat = 8
            static let interItemSpacing: CGFloat = 8
        }
        
        enum FontSize {
            static let rightLabel: CGFloat = 14
        }
    }
}
