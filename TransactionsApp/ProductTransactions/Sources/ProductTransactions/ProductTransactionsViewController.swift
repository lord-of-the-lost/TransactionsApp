//
//  ProductTransactionsViewController.swift
//  ProductTransactions
//
//  Created by Николай Игнатов on 22.05.2025.
//

import Core
import UIKit

public class ProductTransactionsViewController: UIViewController {
    private let presenter: ProductTransactionsPresenterProtocol
    private var viewModel: ProductTransactionsViewModel?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BaseCell.self, forCellReuseIdentifier: BaseCell.identifier)
        return tableView
    }()

    init(presenter: ProductTransactionsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        presenter.setupView(self)
        presenter.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension ProductTransactionsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.items.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let item = viewModel?.items[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: BaseCell.identifier, for: indexPath) as? BaseCell
        else {
            assertionFailure("Invalid item for cell or BaseCell doesn't provided")
            return UITableViewCell()
        }
        let viewModel = BaseCell.BaseCellViewModel(
            leftText: item.originalPrice,
            rightText: item.convertedPrice,
            needDisclosureIndicator: false
        )
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductTransactionsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.sectionHeader
    }
}

// MARK: - ProductTransactionsViewProtocol
extension ProductTransactionsViewController: ProductTransactionsViewProtocol {
    func updateView(_ model: ProductTransactionsViewModel) {
        self.viewModel = model
        title = model.titleText
        tableView.reloadData()
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: Constants.Text.errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.Text.okActionTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Private Methods
private extension ProductTransactionsViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Constants
private extension ProductTransactionsViewController {
    enum Constants {
        enum Text {
            static let errorTitle = "Error"
            static let okActionTitle = "OK"
        }
    }
}
