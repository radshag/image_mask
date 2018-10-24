//
//  TracerImageViewModel.swift
//  tinytap
//
//  Created by Dov Goldberg on 24/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit
import DragDropUI

protocol TracerImageViewModeling {
    func setImage(image: UIImage)
    func reset()
}

class TracerImageViewModel: NSObject {

    private let tracerView: TracerImageView
    private let pointCollection = PointCollection.init()
    private var content = [UIImageView]()
    private var maskPath: UIBezierPath
    private var shapeLayer: CAShapeLayer?
    private var originalImage: UIImage?
    
    init(tracerView: TracerImageView) {
        self.tracerView = tracerView
        self.tracerView.isUserInteractionEnabled = true
        self.maskPath = UIBezierPath.init(rect: self.tracerView.bounds)
        super.init()
        self.tracerView.tracerImageViewDelegate = self
    }
    
    private func doReset() {
        tracerView.image = originalImage
        shapeLayer = nil
        for view in content {
            view.removeFromSuperview()
        }
        content.removeAll()
        self.maskPath = UIBezierPath.init(rect: self.tracerView.bounds)
    }
    
    private func trace() {
        guard
            let path = pointCollection.path()
            else {
                return
        }
        
        if shapeLayer == nil {
            shapeLayer = CAShapeLayer.init()
            tracerView.layer.addSublayer(shapeLayer!)
        }
        
        shapeLayer!.path = path
        shapeLayer!.strokeColor = UIColor.white.cgColor
        shapeLayer!.fillColor = UIColor.clear.cgColor
        shapeLayer!.lineWidth = 4
    }
    
    private func createMask(with path: UIBezierPath) {
        maskPath.append(path)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = tracerView.bounds
        
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.path = maskPath.cgPath
        tracerView.layer.mask = maskLayer
    }
}

extension TracerImageViewModel: TracerImageViewDelegate {
    func tracer(imageView: UIImageView, didTouchAt point: CGPoint) {
        pointCollection.addPoint(aPoint: point)
        trace()
    }
    
    func tracerImageViewTouchesEnded() {
        guard
            let path = pointCollection.path(),
            let bezierPath = pointCollection.bezierPath(),
            let image = self.tracerView.toImage()
            else {
                return
        }
    
        createMask(with: bezierPath)
        let croppedImage = image.crop(to: path)
        let imageView = DDImageView.init(frame: path.boundingBoxOfPath)
        //cut(hole: path, inView: self.tracerImageView)
        imageView.image = croppedImage
        imageView.isUserInteractionEnabled = true
        tracerView.superview?.addSubview(imageView)
        shapeLayer?.removeFromSuperlayer()
        content.append(imageView)
        shapeLayer = nil
        pointCollection.reset()
    }
}

extension TracerImageViewModel: TracerImageViewModeling {
    func setImage(image: UIImage) {
        self.doReset()
        tracerView.image = image
        originalImage = image
    }
    
    func reset() {
        doReset()
    }
}
