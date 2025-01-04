import SwiftUI
import CoreLocation
import Combine

// ViewModel für GPS und Geocoding
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var cityName: String = "Unbekannt"  // Variable für den Stadtnamen
    @Published var latitude: Double = 0.0  // Variable für den Breitengrad
    @Published var longitude: Double = 0.0  // Variable für den Längengrad
    
    override init() {
        super.init()
        locationManager.delegate = self

        // Standortberechtigung anfordern
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Aktualisieren der Koordinaten
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        // Reverse Geocoding
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding Fehler: \(error)")
                self?.cityName = "Unbekannt"
                return
            }
            
            guard let placemark = placemarks?.first,
                  let city = placemark.locality else {
                self?.cityName = "Unbekannt"
                return
            }
            
            self?.cityName = city
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fehler beim Abrufen des Standorts: \(error)")
        cityName = "Unbekannt"
    }
}
