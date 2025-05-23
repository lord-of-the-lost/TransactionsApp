//
//  ProductsListViewController.swift
//  ProductList
//
//  Created by Николай Игнатов on 21.05.2025.
//

import Core
import UIKit

public class ProductsListViewController: UIViewController {
    private let presenter: ProductsListPresenterProtocol
    private var products: [ProductItemViewModel] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BaseCell.self, forCellReuseIdentifier: BaseCell.identifier)
        return tableView
    }()

    init(presenter: ProductsListPresenterProtocol) {
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
extension ProductsListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let item = products[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: BaseCell.identifier, for: indexPath) as? BaseCell
        else {
            assertionFailure("Invalid item for cell or BaseCell doesn't provided")
            return UITableViewCell()
        }
      
        let viewModel = BaseCell.BaseCellViewModel(
            leftText: item.sku,
            rightText: String(item.count),
            needDisclosureIndicator: true
        )
        cell.configure(with: viewModel)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectProduct(at: indexPath.row)
    }
}

// MARK: - ProductsListViewProtocol
extension ProductsListViewController: ProductsListViewProtocol {
    func updateProductsList(_ products: [ProductItemViewModel]) {
        self.products = products
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
private extension ProductsListViewController {
    func setupView() {
        title = Constants.Text.screenTitle
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
private extension ProductsListViewController {
    enum Constants {
        enum Text {
            static let screenTitle = "Products"
            static let errorTitle = "Error"
            static let okActionTitle = "OK"
        }
    }
}

