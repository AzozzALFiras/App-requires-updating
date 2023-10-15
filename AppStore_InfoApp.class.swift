// Developer by : Azozz ALFiras

import Foundation

class AppStoreInfoApp {
    func sentRequest(bundleId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "http://itunes.apple.com/lookup?bundleId=\(bundleId)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json))
            }
        }.resume()
    }

    func getInfoApp(bundleId: String, version: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        sentRequest(bundleId: bundleId) { result in
            switch result {
            case .success(let data):
                if let vAppStore = data["version"] as? String, let appLink = data["trackViewUrl"] as? String {
                    if vAppStore == version {
                        completion(responseApi(status: "Yes", url: appLink))
                    } else {
                        completion(responseApi(status: "No", url: appLink))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func responseApi(status: String, url: String) -> [String: Any] {
        if status == "Yes" {
            return [
                "status": "success",
                "status_message": "There is no application update"
            ]
        } else {
            return [
                "status": "failed",
                "status_message": "The version does not match. An update is required",
                "app_link": url
            ]
        }
    }
}
