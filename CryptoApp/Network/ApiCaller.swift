//
//  ApiCaller.swift
//  CryptoApp
//
//  Created by Volodymyr Mendyk on 25/05/2022.
//

import Foundation
import UIKit

final class ApiCaller {
    
    static let shared = ApiCaller()
    typealias session = URLSession
    
    private struct Constants {
        static let apiKey = "378C07BB-96F9-4643-8A3D-3B30534CDBF2"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    private init() {}
    
    public var icons: [Icon] = []
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    //MARK: - API Call
    public func getAllCryptoData(
        completion: @escaping(Result<[Crypto], Error>) -> Void) {
            
            guard !icons.isEmpty else {
                whenReadyBlock = completion
                return }
            
            guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else { return }
            
            let task = session.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    // Decode the response
                    let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                    completion(.success(cryptos.sorted(by: { first, second -> Bool in
                        return first.price_usd ?? 0 > second.price_usd ?? 0
                    })))
                }
                catch {
                    //Catch the error
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=378C07BB-96F9-4643-8A3D-3B30534CDBF2") else { return }
        
        let task = session.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                // Decode the response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
                //Catch the error
                print(error)
            }
        }
        
        task.resume()
    }
}
