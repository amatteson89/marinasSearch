//
//  SearchHelper.swift
//  Marinas Search
//
//  Created by mattesona on 11/25/22.
//

import Foundation

/// Singleton class to handle getting the JSON point data
class SearchHelper {
    // MARK: Properties
    static var shared = SearchHelper()

    /// Get the point data
    func getPoints(searchText: String, completion: @escaping (PointData?, Error?) -> Void) {
        guard let searchURL = URL(string: "https://api.marinas.com/v1/points/search?api_key=UymcFDYh2me2ciyxsLc2&query=\(searchText)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: searchURL) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }

            if let data = data {
                do {
                    let decodeData = try JSONDecoder().decode(PointData.self, from: data)
                    completion(decodeData, nil)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
