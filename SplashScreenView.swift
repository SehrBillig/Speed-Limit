//
//  Project_CApp.swift
//  Project-C
//
//  Created by Philipp Duong on 28.07.24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var secondAnimation = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "car")
                        .font(.system(size: 80))
                        .foregroundColor(Color("Main Color"))
                    Text("Speed Limit")
                        .bold()
                        .font(.system(size: 30))
                        .foregroundColor(Color("Main Color"))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.size = 0.8
                            self.opacity = 0.5
                            self.secondAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeIn(duration: 0.42)) {
                                //Die Antwort ist 42
                                self.size = 1.1
                                self.opacity = 1.0
                            }
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    //Was ist lustiger als 24? 25! xD
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
