import Foundation
import CoreLocation
import Combine

class HomeViewModel : NSObject, CLLocationManagerDelegate{
    
    // MARK:- Properties
    
    var manager : CLLocationManager!
    
    @Published
    var weather : Weather?
    
    var delegate : HomeViewModelDelegate?
    
    override init() {
        super.init()
        manager = CLLocationManager()
        manager.delegate = self
        checkPermissions()
    }
    
    // MARK:- Location Handlers

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let longitude = locations[0].coordinate.longitude
        let latitude = locations[0].coordinate.latitude
        
        let geolocation = Geolocation(longitude: longitude, latitude: latitude)
        
        APICaller.shared.fetchWeather(for: geolocation) { weather in
            self.weather = weather
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.showMessage(message: error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
       checkPermissions()
    }
    
    // MARK:- Functions
    
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
