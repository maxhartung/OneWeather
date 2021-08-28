import Foundation
import CoreLocation
import Combine

class HomeViewModel : NSObject, CLLocationManagerDelegate{
    
    var manager : CLLocationManager!
    
    @Published
    var weather : Weather?
    
    override init() {
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        checkPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let longitude = locations[0].coordinate.longitude
        let latitude = locations[0].coordinate.latitude
        
        let geolocation = Geolocation(longitude: longitude, latitude: latitude)
        
        APICaller.shared.fetchWeather(for: geolocation) { weather in
            self.weather = weather
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
       checkPermissions()
    }
    
    func checkPermissions(){
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            break
        }
    }
}
