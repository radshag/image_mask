//
//  UIViewExtension.swift
//  tinytap
//
//  Created by Dov Goldberg on 24/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
