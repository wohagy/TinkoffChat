//
//  LongPressAnimator.swift
//  iOS Chat
//
//  Created by Macbook on 05.05.2022.
//

import UIKit

protocol ILongPressAnimator {}

final class LongPressAnimator: ILongPressAnimator {
    
    private let view: UIView?
    
    private lazy var logoLayerCell: CAEmitterCell = {
        var cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoffLogo")?.cgImage
        cell.scale = 0.001
        cell.scaleRange = 0.3
        cell.emissionRange = .pi
        cell.lifetime = 20.0
        cell.birthRate = 3
        cell.velocity = 30
        cell.velocityRange = 20
        cell.alphaSpeed = -0.3
        cell.spin = -0.5
        cell.spinRange = 1.0
        return cell
        
    }()
    
    private lazy var logoLayer: CAEmitterLayer = {
        let logoLayer = CAEmitterLayer()
        logoLayer.emitterSize = CGSize(width: 1, height: 1)
        logoLayer.beginTime = CACurrentMediaTime()
        logoLayer.birthRate = 0
        logoLayer.emitterCells = [logoLayerCell]
        return logoLayer
    }()
    
    init(view: UIView?) {
        self.view = view
        self.view?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:))))
    }
    
    @objc private func longTap(_ sender: UILongPressGestureRecognizer) {
        
        let loc = sender.location(in: view)
        
        switch sender.state {
        
        case .began:
            logoLayer.emitterPosition = loc
            logoLayer.birthRate = 1
            view?.layer.addSublayer(logoLayer)
        case .ended:
            logoLayer.birthRate = 0
            logoLayer.removeFromSuperlayer()
        default:
            break
        }
    }
}
