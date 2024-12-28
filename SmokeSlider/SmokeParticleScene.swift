//
//  SmokeParticleScene.swift
//  SmokeSlider
//
//  Created by HEssam on 12/27/24.
//

import SwiftUI
import SpriteKit

final class SmokeParticleScene: SKScene, ObservableObject {
    private let particleEmitterNode = SKEmitterNode(fileNamed: "smoke.sks")
    
    override func didMove(to view: SKView) {
        guard let particleEmitterNode else { return }
        addChild(particleEmitterNode)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func configureEmitter(
        birthRate: CGFloat,
        emissionAngleRange: CGFloat,
        verticalAcceleration: CGFloat,
        particleScale: CGFloat,
        scaleRange: CGFloat,
        scaleSpeed: CGFloat,
        lifetime: CGFloat,
        speed: CGFloat,
        positionRange: CGVector
    ) {
        guard let particleEmitterNode else { return }
        
        particleEmitterNode.particleBirthRate = birthRate
        particleEmitterNode.emissionAngleRange = CGFloat.pi / 180 * emissionAngleRange
        particleEmitterNode.yAcceleration = verticalAcceleration
        particleEmitterNode.particleScale = particleScale
        particleEmitterNode.particleScaleRange = particleScale
        particleEmitterNode.particleScaleSpeed = scaleRange
        particleEmitterNode.particleLifetime = lifetime
        particleEmitterNode.particleSpeed = speed
        particleEmitterNode.particlePositionRange = positionRange
    }
    
    func updateHorizontalAcceleration(_ xAcceleration: CGFloat) {
        guard let particleEmitterNode else { return }
        particleEmitterNode.xAcceleration = xAcceleration
    }
}

struct SmokeView: View {
    @Binding var birthRate: CGFloat
    @Binding var emissionAngleRange: CGFloat
    @Binding var verticalAcceleration: CGFloat
    @Binding var particleScale: CGFloat
    @Binding var scaleRange: CGFloat
    @Binding var scaleSpeed: CGFloat
    @Binding var lifetime: CGFloat
    @Binding var speed: CGFloat
    @Binding var positionRange: CGVector
    @Binding var horizontalAcceleration: CGFloat
    
    @StateObject private var particleScene: SmokeParticleScene = {
        let scene = SmokeParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }()
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            SpriteView(scene: particleScene, options: [.allowsTransparency])
        }
        .onChange(of: birthRate) { updateScene() }
        .onChange(of: emissionAngleRange) { updateScene() }
        .onChange(of: verticalAcceleration) { updateScene() }
        .onChange(of: particleScale) { updateScene() }
        .onChange(of: scaleRange) { updateScene() }
        .onChange(of: scaleSpeed) { updateScene() }
        .onChange(of: lifetime) { updateScene() }
        .onChange(of: speed) { updateScene() }
        .onChange(of: positionRange) { updateScene() }
        .onChange(of: horizontalAcceleration){ updateHorizontalAcceleration() }
    }
    
    private func updateScene() {
        particleScene.configureEmitter(
            birthRate: birthRate,
            emissionAngleRange: emissionAngleRange,
            verticalAcceleration: verticalAcceleration,
            particleScale: particleScale,
            scaleRange: scaleRange,
            scaleSpeed: scaleSpeed,
            lifetime: lifetime,
            speed: speed,
            positionRange: positionRange
        )
    }
    
    private func updateHorizontalAcceleration() {
        particleScene.updateHorizontalAcceleration(horizontalAcceleration)
    }
}
