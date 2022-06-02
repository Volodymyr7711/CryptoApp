//
//  Crypto.swift
//  CryptoApp
//
//  Created by Volodymyr Mendyk on 25/05/2022.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String?
    let url: String?
}
