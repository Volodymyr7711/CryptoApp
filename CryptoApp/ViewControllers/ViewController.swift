//
//  ViewController.swift
//  CryptoApp
//
//  Created by Volodymyr Mendyk on 25/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        return searchBar
    }()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .default
        return formatter
    }()
    
    private var viewModels = [CryptoTableCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Crypto Tracker"
        view.addSubview(tableView)
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        //MARK: - Fetching Data
        ApiCaller.shared.getAllCryptoData { [weak self] result in
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ model in
                    let price = model.price_usd ?? 0
                    let formatter = ViewController.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    let iconURL = URL(string: ApiCaller.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url ?? "")
                    
                    return CryptoTableCellViewModel(name: model.name ?? "N/A",
                                                    symbol: model.asset_id,
                                                    price: priceString ?? "N/A",
                                                    iconURL: iconURL)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error : \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: UISearchBarDelegate {
    
}
