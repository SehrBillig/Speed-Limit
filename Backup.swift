//
//  Project_CApp.swift
//  Project-C
//
//  Created by Philipp Duong on 28.07.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0 // Zustand für Home
    @State private var showWeather = true  // Zustand für die Wetteranzeige
    @State private var showBlitzer = false // Zustand für Blitzer-Option
    @State private var isVoiceEnabled = true  // Zustand für Stimme
    @State private var isSoundAlertEnabled = false // Zustand für Warnton
    @State private var isHeadUpDisplayEnabled = false // Zustand für Head-Up Display
    @State private var showCameraAlert = false // Zustand für die Kamera-Alert
    @State private var cameraMessage = "" // Nachricht für die Kamera-Alert
    
    var body: some View {
        VStack(spacing: 10.0) {
            // Überschrift
            headerView
            // Tabs
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.bottom)
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
        }
        .padding()
        .alert(isPresented: $showCameraAlert) {
            Alert(
                title: Text("Kamerawechsel"),
                message: Text(cameraMessage),
                dismissButton: .default(Text("OK"))
            )
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
    
    // Home Tab
    private var homeTab: some View {
        VStack(spacing: 20) {
            Image("Speed 50")
                .imageScale(.large)
                .foregroundColor(Color("Main Color"))
                .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
            // Momentane Geschwindigkeit
            Text("53km/h")
                .bold()
                .font(.system(size: 50))
                .fixedSize()
                .foregroundColor(Color("Main Color"))
                .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
            
            Spacer().frame(height: 30) // Abstand hinzufügen

            // Wetter Anzeige
            if showWeather {
                weatherView
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .scaleEffect(x: isHeadUpDisplayEnabled ? -1 : 1, y: 1) // Horizontale Spiegelung
            }
        }
    }
    
    // Wetter View
    private var weatherView: some View {
        VStack {
            Text("Aktuelles Wetter")
                .bold()
                .foregroundColor(Color("Main Color"))
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                VStack(alignment: .leading) {
                    Text("25°C")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("Main Color"))
                    Text("Teilweise bewölkt")
                        .foregroundColor(Color("Main Color"))
                }
            }
        }
    }
    
    // Settings Tab
    private var settingsTab: some View {
        VStack {
            Text("Settings")
                .bold()
                .font(.title2)
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
                    Text("Die Nutzung der Blitzerwarnung ist in manchen Ländern strafbar.")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                Toggle("Wetter anzeigen", isOn: $showWeather)
            }
            Spacer().frame(height: 30)
            // Fußzeile der Liebe
            VStack {
                HStack {
                    Text("Made with")
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("in Germany")
                }
                .font(.caption) //  Schriftgröße
                Text("by Flo & Philipp")
                    .font(.caption) //  Schriftgröße
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
