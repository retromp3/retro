//
//  ContentView.swift
//  Shuffle Watch App
//
//  Created by Sakun on 2/19/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject private var manager = WatchCommunicationManager()
    
    var body: some View {
        ZStack {
            Image("gen7_black")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            ZStack{
                Circle()
                    .stroke(lineWidth: 35)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black, Color(hex: "383838")]),
                            startPoint: .bottomTrailing,
                            endPoint: .topTrailing
                        )
                    )
                    .scaledToFit()
                    .padding(28)
                
                VStack(spacing: 53) {
                    Button(action: {
                        print("volume up")
                    }) {
                        Image("volumeup")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        print("play/pause")
                    }) {
                        Image("playpause")
                            .resizable()
                            .frame(width: 52, height: 29.29)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 10)
                    
                    
                    Button(action: {
                        print("volume down")
                    }) {
                        Image("volumedown")
                            .resizable()
                            .frame(width: 15, height: 4)
                    }
                    .buttonStyle(.plain)

                }
                
                HStack(spacing: 120) {
                    Button(action: prevSong) {
                        Image("fastrewind")
                            .resizable()
                            .frame(width: 25, height: 24.13)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: nextSong) {
                        Image("fastforward")
                            .resizable()
                            .frame(width: 25, height: 24.13)
                    }
                    .buttonStyle(.plain)
                }
            }
            
        }
    }
    
    private func nextSong() {
        WKInterfaceDevice.current().play(.success)
        manager.playNextSong()
    }

    private func prevSong() {
        WKInterfaceDevice.current().play(.success)
        manager.playPrevSong()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
