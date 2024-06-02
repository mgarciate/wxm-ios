//
//  CoinGeckoNetworkService.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import Foundation

class CoinGeckoNetworkManager {
    static let shared = CoinGeckoNetworkManager()
    
    private init() {}
    
    func fetchWXMTokenPrice(completion: @escaping (Double?) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=weatherxm-network&vs_currencies=usd"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let weatherxmNetwork = json["weatherxm-network"] as? [String: Any],
                   let usdPrice = weatherxmNetwork["usd"] as? Double {
                    completion(usdPrice)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
