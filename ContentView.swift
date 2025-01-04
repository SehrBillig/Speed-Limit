//
//  Project_CApp.swift
//  Project-C
//
//  Created by Philipp Duong on 28.07.24.
//
import SwiftUI
import Combine

// Modell für die Wetterdaten
struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

struct ContentView: View {
    @State private var schnell: Bool = false // Beispiel Zustand für "schnell"
    @State private var selectedTab = 0
    @State private var showWeather = true  // Zustand für die Wetteranzeige
    @State private var showBlitzer = false // Zustand für Blitzer-Option
    @State private var isVoiceEnabled = true  // Zustand für Stimme
    @State private var isSoundAlertEnabled = false // Zustand für Warnton
    @State private var isHeadUpDisplayEnabled = false // Zustand für Head-Up Display
    @State private var showCameraAlert = false // Zustand für die Kamera-Alert
    @State private var cameraMessage = "" // Nachricht für die Kamera-Alert
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var weatherData: WeatherResponse?
    @State private var weatherSubscription: AnyCancellable?
    
    private let apiKey = "c055de6f8bdce2a800dd62c158e887e6" // Füge hier deinen OpenWeatherMap API-Schlüssel ein
    
    var body: some View {
        NavigationView { // Kuss CHATGPT!!! Hinzufügen von NavigationView
            
            VStack(spacing: 10.0) {
                // Überschrift
                headerView
                // Tabs
                TabView(selection: $selectedTab) {
                    homeTab
                        .tabItem {
                            Image(systemName: "car")
                            Text("Home")
                        }
                        .tag(0)
                    
                    settingsTab
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(1)
                }
            }
            .padding()
            // Alarm!!!!!!
            .alert(isPresented: $showCameraAlert) {
                Alert(
                    title: Text("Kamerawechsel"),
                    message: Text(cameraMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                fetchWeatherData()
            }
        }
    }
    
    // Header View
    private var headerView: some View {
        VStack {
            Image(systemName: "car")
                .imageScale(.large)
                .foregroundColor(Color("Main Color"))
            Text("Speed limit")
                .bold()
                .foregroundColor(Color("Main Color"))
                .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
        }
    }
    private func activateSchnell() {
        // Setzt "schnell" auf true
        schnell = true
        
        // Nach 1 Sekunde wird "schnell" wieder auf false gesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            schnell = false
        }
    }
    // Home Tab
    private var homeTab: some View {
        VStack(spacing: 20) {
            Image("Speed 50")
                           .resizable()
                           .scaledToFit()
                           .imageScale(.large)
                           .foregroundColor(schnell ? .red : Color("Main Color")) // Rot färben, wenn "schnell" true ist
                           .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
                           .scaleEffect(schnell ? 1.1 : 1) // Vergrößern, wenn "schnell" true ist
                           .frame(width: 300, height: 300) // Optional: Bildgröße anpassen
                           .animation(.easeInOut, value: schnell)
                           .saturation(schnell ? /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/ : 1) // Animation für die Skalierung
            
            Text("53km/h")
                .bold()
                .font(.system(size: 50))
                .fixedSize()
                .foregroundColor(schnell ? .red : Color("Main Color"))
                .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung

            
            
            
//            Der Tester
            
            // Button zum Aktivieren von "schnell" (Geheim code)
//                        Button(action: activateSchnell) {
//                            Text("Schnell aktivieren")
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
///
            
            
            Spacer().frame(height: 10)

            if showWeather, let weather = weatherData {
                weatherView(weather: weather)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung

            }
            Text("Stadt: \(locationViewModel.cityName)")
                .bold()
                .foregroundColor(Color("Main Color"))
                .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
        }
    }
    
    // Wetter View
    private func weatherView(weather: WeatherResponse) -> some View {
        VStack {
            Text("Aktuelles Wetter")
                .bold()
                .foregroundColor(Color("Main Color"))

            HStack {
                weatherIcon(for: weather.weather.first?.icon ?? "01d")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                VStack(alignment: .leading) {
                    Text(String(format: "%.0f°C", weather.main.temp - 273.15)) // Umrechnung von Kelvin nach Celsius
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("Main Color"))
                    Text(translateDescription(weather.weather.first?.description ?? ""))
                        .foregroundColor(Color("Main Color"))
                }
            }
        }
    }
    
    // Icons für Wetterbedingungen
    private func weatherIcon(for iconCode: String) -> Image {
        switch iconCode {
        case "01d":
            return Image(systemName: "sun.max.fill") // Klarer Himmel
        case "01n":
            return Image(systemName: "moon.stars.fill") // Klare Nacht
        case "02d", "02n":
            return Image(systemName: "cloud.sun.fill") // Teilweise bewölkt
        case "03d", "03n":
            return Image(systemName: "cloud.fill") // Überwiegend bewölkt
        case "04d", "04n":
            return Image(systemName: "smoke") // Stark bewölkt
        case "09d", "09n":
            return Image(systemName: "cloud.rain.fill") // Regen
        case "10d":
            return Image(systemName: "cloud.sun.rain.fill") // Regenschauer tagsüber
        case "10n":
            return Image(systemName: "cloud.moon.rain.fill") // Regenschauer nachts
        case "11d", "11n":
            return Image(systemName: "cloud.bolt.fill") // Gewitter
        case "13d", "13n":
            return Image(systemName: "snow") // Schnee
        case "50d", "50n":
            return Image(systemName: "cloud.fog.fill") // Nebel
        default:
            return Image(systemName: "questionmark") // Unbekanntes Wetter
        }
    }
    
    // Übersetzung der Wetterbeschreibung ins Deutsche
    private func translateDescription(_ description: String) -> String {
        switch description.lowercased() {
        case "clear sky":
            return "Klarer Himmel"
        case "few clouds":
            return "Wenig Wolken"
        case "scattered clouds":
            return "Wolkig"
        case "broken clouds":
            return "Überwiegend bewölkt"
        case "shower rain":
            return "Regenschauer"
        case "rain":
            return "Regen"
        case "thunderstorm":
            return "Gewitter"
        case "snow":
            return "Schnee"
        case "mist":
            return "Nebel"
        default:
            return description.capitalized // Standardmäßige Beschreibung zurückgeben
        }
    }
    
    // Settings Tab
    private var settingsTab: some View {
        VStack {
            Text("Settings")
                .bold()
                .foregroundColor(Color("Main Color"))
            GroupBox(label: Text("System")) {
                Toggle("Stimme", isOn: $isVoiceEnabled)
                    .onChange(of: isVoiceEnabled) { newValue in
                        if newValue {
                            isSoundAlertEnabled = false
                        }
                    }
                Toggle("Warnton", isOn: $isSoundAlertEnabled)
                    .onChange(of: isSoundAlertEnabled) { newValue in
                        if newValue {
                            isVoiceEnabled = false
                        }
                    }
                Toggle("Head-Up Display", isOn: $isHeadUpDisplayEnabled)
                    .onChange(of: isHeadUpDisplayEnabled) { newValue in
                        cameraMessage = newValue ? "Für die Schildererkennung wird die Frontkamera verwendet." : "Für die Schildererkennung wird die Rückkamera verwendet."
                        showCameraAlert = true
                    }
            }
            GroupBox(label: Text("Erkennung und Anzeigen")) {
                Toggle("Geschwindigkeit", isOn: .constant(true))
                Toggle("Stop Schilder", isOn: .constant(true))
                Toggle("Ampeln", isOn: .constant(true))
                Toggle("Blitzer", isOn: $showBlitzer)
                if showBlitzer {
                    Text("Die Nutzung der Blitzerwarnung ist in manchen \nLändern strafbar.")
                        .font(.caption2)
                        .fontWeight(.regular)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                Toggle("Wetter anzeigen", isOn: $showWeather)
            }
            Spacer().frame(height: 15)

                NavigationLink(destination: InformationView()) {
                    Text("Weitere Informationen")
                        .bold()
                        .foregroundColor(Color.blue)

            }
            
            Spacer().frame(height: 5)
            
            // Fußzeile der Liebe
            VStack {
                HStack {
                    Text("Made with")
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("in Germany")
                }
                .font(.caption) // Kleinere Schriftgröße
                Text("by Flo & Philipp")
                    .font(.caption) // Kleinere Schriftgröße
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    // Funktion zum Abrufen der Wetterdaten
    private func fetchWeatherData() {
        let latitude = locationViewModel.latitude
        let longitude = locationViewModel.longitude
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        weatherSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fehler beim Abrufen der Wetterdaten: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { weather in
                self.weatherData = weather
            })
    }
}



#Preview {
    ContentView()
}
