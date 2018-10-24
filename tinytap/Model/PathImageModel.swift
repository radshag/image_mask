//
//  PathImageModel.swift
//  tinytap
//
//  Created by Dov Goldberg on 24/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

class PathImageModel: NSObject {
    let path: UIBezierPath
    let imageView: UIImageView
    
    init(path: UIBezierPath, imageView: UIImageView) {
        self.path = path
        self.imageView = imageView
    }
}
