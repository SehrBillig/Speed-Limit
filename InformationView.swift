//
//  InfoView.swift
//  Project-C
//
//  Created by Philipp Duong on 29.07.24.
//
import SwiftUI

struct InformationView: View {
    var body: some View {
        ZStack {
            // Hintergrundbild
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 500)
                
                // Titeltext
                //Text("Speed Limit")
                    //.font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.bottom, 10)
//                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                
                // Beschreibender Text
                Text("The weather data is provided by OpenWeather.")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 2.0)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                Text("Image by mat_hias from Pixabay")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                Text("Das Internet ist die größte Informationsquelle \nund Ablenkung der Menschheit. \n– Bill Gates")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                
                // Schaltfläche
                Button(action: {
                    // Aktion für die Schaltfläche
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 5, x: 0, y: 2)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    InformationView()
}
