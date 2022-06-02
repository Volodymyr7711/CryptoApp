//
//  CryptoTableViewCell.swift
//  CryptoApp
//
//  Created by Volodymyr Mendyk on 25/05/2022.
//

import UIKit

class CryptoTableCellViewModel {
    
    let name: String
    let symbol: String
    let price: String
    let iconURL: URL?
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconURL: URL?) {
       self.name = name
       self.symbol = symbol
       self.price = price
       self.iconURL = iconURL
   }
}

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    //Subviews
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 24, weight: .medium)
        return nameLabel
    }()
    
    private let symbolLabel: UILabel = {
        let symbolLabel = UILabel()
        symbolLabel.font = .systemFont(ofSize: 20, weight: .light)
        return symbolLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = .green
        priceLabel.textAlignment = .right
        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return priceLabel
    }()
    
    private let iconURL: UIImageView = {
        let iconURL = UIImageView()
        iconURL.contentMode = .scaleAspectFit
        return iconURL
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        iconURL.frame = CGRect(x: 20,
                               y: (contentView.frame.height-size) / 2,
                               width: size,
                               height: size)
        
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: 30 + size,
                                 y: 0,
                                 width: contentView.frame.size.width/2,
                                 height: contentView.frame.size.height/2)
        
        symbolLabel.frame = CGRect(x: 30 + size,
                                   y: contentView.frame.size.height/2,
                                   width: contentView.frame.size.width/2,
                                   height: contentView.frame.size.height/2)
        
        priceLabel.frame = CGRect(x: contentView.frame.size.width/2,
                                  y: 0,
                                  width: (contentView.frame.size.width/2) - 15,
                                  height: contentView.frame.size.height/2)
        
    }
    
    //Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconURL.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        symbolLabel.text = nil
    }
    
    //Configure
    func configure(with viewModel: CryptoTableCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        if let data = viewModel.iconData {
            iconURL.image = UIImage(data: data)
        }
        else if let url = viewModel.iconURL {
            let task = URLSession.shared.dataTask(with: url) { [weak self ] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.iconURL.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    
}
