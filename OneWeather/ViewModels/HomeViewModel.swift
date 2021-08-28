import Foundation
import CoreLocation
import Combine

class HomeViewModel : NSObject, CLLocationManagerDelegate{
    
    // MARK:- Properties
    
    var manager : CLLocationManager!
    
    @Published
    var weather : Weather?
    
    @Published
    var locationName : String = ""
    
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
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        let geoCoder: CLGeocoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(loc) { [weak self] placemarks, error  in
            guard let placemark = placemarks?[0], error == nil else { return }
            
            self?.locationName = placemark.locality ?? placemark.subLocality ?? ""
        }
        
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
