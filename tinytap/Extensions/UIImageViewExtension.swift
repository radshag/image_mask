//
//  UIImageViewExtension.swift
//  tinytap
//
//  Created by Dov Goldberg on 23/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

extension UIImage {
    
    func crop(to path: CGPath) -> UIImage? {
        
        let r: CGRect = path.boundingBox // the rect to draw our image in (minimum rect that the path occupies).
        
        UIGraphicsBeginImageContextWithOptions(self.size, _: false, _: self.scale) // begin image context, with transparency & the scale of the image.
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        ctx.translateBy(x: -r.origin.x, y: -r.origin.y) // translate context so that when we add the path, it starts at (0,0).
        
        ctx.addPath(path) // add path.
        ctx.clip() // clip any future drawing to the path region.
        
        //let croppedImage = UIImage.init()
        
        self.draw(in: CGRect.init(origin: CGPoint.zero, size: self.size)) // draw image
        
        let i: UIImage? = UIGraphicsGetImageFromCurrentImageContext() // get image from context
        UIGraphicsEndImageContext() // clean up and finish context
        
        return i // return image
    }
    
//    func clippedImage(with path: CGPath) -> UIImage? {
//        
//        guard let context = UIGraphicsGetImageFromCurrentImageContext() else {
//            return nil
//        }
//        
//        defer {
//            UIGraphicsEndImageContext()
//        }
//        
//        UIGraphicsBeginImageContext(self.bounds.size)
//        context.setStrokeColor(UIColor.black.cgColor)
//        context.addPath(path)
//        context.setFillColor(UIColor.red.cgColor)
//        context.drawPath(using: .fillStroke)
//        
//        guard
//            let maskImage = UIGraphicsGetImageFromCurrentImageContext(),
//            let originalImage = self.image
//        else {
//            return nil
//        }
//        
//        UIGraphicsBeginImageContext(originalImage.size)
//        
//        guard let newcontext = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//        let captureImage: UIImage = UIImage.init()
//        newcontext.clip(to: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), mask: maskImage.cgImage!)
//        captureImage.draw(at: CGPoint.zero)
//        let clippedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return clippedImage
//    }
}
