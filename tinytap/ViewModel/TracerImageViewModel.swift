//
//  TracerImageViewModel.swift
//  tinytap
//
//  Created by Dov Goldberg on 24/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

protocol TracerImageViewModeling {
    func setImage(image: UIImage)
    func reset()
}

class TracerImageViewModel: NSObject {

    private let tracerView: TracerImageView
    private let viewController: UIViewController
    private let pointCollection = PointCollection.init()
    private var content = [PathImageModel]()
    private var maskPath: UIBezierPath
    private var shapeLayer: CAShapeLayer?
    private var originalImage: UIImage?
    
    init(tracerView: TracerImageView, viewController: UIViewController) {
        self.tracerView = tracerView
        self.viewController = viewController
        self.tracerView.isUserInteractionEnabled = true
        self.maskPath = UIBezierPath.init(rect: self.tracerView.bounds)
        super.init()
        self.tracerView.tracerImageViewDelegate = self
    }
    
    private func doReset() {
        tracerView.layer.mask = nil
        tracerView.image = originalImage
        shapeLayer = nil
        for pathModel in content {
            pathModel.imageView.removeFromSuperview()
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
    
    private func addMask(with path: UIBezierPath) {
        maskPath.append(path)
        
        self.drawMasks()
    }
    
    private func drawMasks() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = tracerView.bounds
        
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.path = maskPath.cgPath
        tracerView.layer.mask = maskLayer
    }
    
    private func removeContent(with imageView:UIImageView) {
        var indexToDelete = -1
        for (i, item) in self.content.enumerated() {
            if item.imageView == imageView {
                indexToDelete = i
            }
        }
        if indexToDelete > -1 {
            self.content.remove(at: indexToDelete)
        }
    
        imageView.removeFromSuperview()
        self.refreshPaths()
    }
    
    private func refreshPaths() {
        self.maskPath = UIBezierPath.init(rect: self.tracerView.bounds)
        
        for item in self.content {
            self.maskPath.append(item.path)
        }
        
        self.drawMasks()
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
            let image = self.tracerView.toImage(),
            let croppedImage = image.crop(to: path)
            else {
                return
        }
    
        let rect = path.boundingBox
        let size = croppedImage.size
        addMask(with: bezierPath)
        let imageView = TracerImageViewDraggableContent.init(frame: CGRect.init(origin: rect.origin, size: size))
        imageView.image = croppedImage
        imageView.delegate = self
        imageView.isUserInteractionEnabled = true
        tracerView.superview?.addSubview(imageView)
        shapeLayer?.removeFromSuperlayer()
        content.append(PathImageModel.init(path: bezierPath, imageView: imageView))
        shapeLayer = nil
        pointCollection.reset()
    }
}

extension TracerImageViewModel: TracerImageViewDraggableContentDelegate {
    func tracer(imageView: UIImageView, didLongPress gesture: UILongPressGestureRecognizer) {
        let alert = UIAlertController.init(title: "Remove Item", message: "Are you sure?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            self.removeContent(with: imageView)
        })
        
        let noAction = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.viewController.present(alert, animated: true)
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
