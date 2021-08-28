import Foundation

struct Weather : Decodable {
    let current : Current
    let hourly : [Hourly]
}

struct Current : Decodable {
    let temp : Double
    let feels_like : Double
    let pressure : Double
    let humidity : Double
    let visibility : Double
    let wind_speed : Double
}

struct Hourly : Decodable {
    let dt : Date
    let temp : Double
    let feels_like : Double
    let pressure : Double
    let humidity : Double
    let visibility : Double
    let wind_speed : Double
}
