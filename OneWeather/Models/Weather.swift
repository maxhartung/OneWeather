import Foundation

struct Weather : Decodable {
    let current : Current
}

struct Current : Decodable {
    let temp : Double
    let feels_like : Double
    let pressure : Double
    let humidity : Double
    let visibility : Double
    let wind_speed : Double
}
