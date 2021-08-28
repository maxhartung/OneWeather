import Foundation

class APICaller {
    static let shared = APICaller()
    
    public func fetchWeather(for location : Geolocation, completion : @escaping (Weather?) -> Void) {
        
        guard var urlComponents = URLComponents(string: Constants.URL) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: Constants.API_KEY),
            URLQueryItem(name: "lon", value: String(location.longitude)),
            URLQueryItem(name: "lat", value: String(location.latitude)),
            URLQueryItem(name: "exclude", value: "minutely,daily,alerts")
        ]
        
        let urlRequest = URLRequest(url: urlComponents.url!)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let jsonData = data, error == nil else {
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                                
                let weather = try jsonDecoder.decode(Weather.self, from: jsonData)
                completion(weather)
            }catch {
                completion(nil)
            }
            
        }.resume()
    }
}
