//
//  ContentView.swift
//  SmokeSlider
//
//  Created by HEssam on 12/28/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sliderValue = 0.0
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            ParticleSlider(value: $sliderValue, range: 0...100)
                .padding(60)
        }
    }
}

#Preview {
    ContentView()
}

struct ParticleSlider: View {
    
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    @State private var particleBirthRate: CGFloat = 0
    @State private var emissionAngleRange: CGFloat = 10
    @State private var verticalAcceleration: CGFloat = 20
    @State private var horizontalAcceleration: CGFloat = 0
    @State private var particleScale: CGFloat = 0.1
    @State private var scaleRange: CGFloat = 0.1
    @State private var scaleSpeed: CGFloat = -0.07
    @State private var lifetime: CGFloat = 0.3
    @State private var speed: CGFloat = 10
    @State private var positionRange = CGVector(dx: 10, dy: 0)
    
    @State private var previousSliderValue: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                let valueRange = range.upperBound - range.lowerBound
                let filledTrackWidth = geometry.size.width * (value / valueRange)
                
                SmokeView(
                    birthRate: $particleBirthRate,
                    emissionAngleRange: $emissionAngleRange,
                    verticalAcceleration: $verticalAcceleration,
                    particleScale: $particleScale,
                    scaleRange: $scaleRange,
                    scaleSpeed: $scaleSpeed,
                    lifetime: $lifetime,
                    speed: $speed,
                    positionRange: $positionRange,
                    horizontalAcceleration: $horizontalAcceleration
                )
                .offset(x: filledTrackWidth - (geometry.size.width / 2) + 12, y: -17)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.emptyTrack)
                    .frame(height: 3)
                
                // filled track
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .frame(width: filledTrackWidth, height: 6)
                
                let displayedValue = String(format: "%.0f", value.rounded(.down))
                
                Circle()
                    .fill(Color.blue)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(height: 25)
                    .overlay(content: {
                        Text(displayedValue)
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .offset(y: 60)
                    })
                    .offset(x: filledTrackWidth)
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged({ gesture in
                                updateSliderValue(with: gesture, in: geometry)
                                updateHorizontalAcceleration(with: gesture)
                            })
                            .onEnded({ _ in
                                horizontalAcceleration = 0
                            })
                    )
                
            }
            .frame(width: geometry.size.width)
        }
        .onChange(of: value) { adjustParticleProperties() }
    }
    
    private func adjustParticleProperties() {
        if value == 0 {
            particleBirthRate = 0
        } else {
            let normalizedValue = (value - 1) / 99
            particleBirthRate = 40 + 160 * normalizedValue
            emissionAngleRange = 10 + 190 * normalizedValue
            verticalAcceleration = 20 + 180 * normalizedValue
            particleScale = 0.1 + 0.2 * normalizedValue
            scaleRange = 0.1 + 0.7 * normalizedValue
            scaleSpeed = -0.07 + 0.13 * normalizedValue
            lifetime = 0.3 + 0.7 * normalizedValue
            speed = 10 + 70 * normalizedValue
            positionRange = CGVector(dx: 10 + 40 * normalizedValue, dy: 0)
        }
    }
    
    private func updateSliderValue(with gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let dragPortion = gesture.location.x / geometry.size.width
        let clampedValue = min(max(dragPortion * 100, range.lowerBound), range.upperBound)
        value = clampedValue
    }
    
    private func updateHorizontalAcceleration(with gesture: DragGesture.Value) {
        let currentValue = gesture.translation.width
        let difference = currentValue - previousSliderValue
        
        if abs(difference) >= 2 {
            horizontalAcceleration = difference > 0 ? -400 : 400
        } else {
            horizontalAcceleration = 0
        }
        
        previousSliderValue = currentValue
    }
}
