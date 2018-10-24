//
//  PointCollection.swift
//  tinytap
//
//  Created by Dov Goldberg on 23/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

class PointCollection: NSObject {
    private var points: [CGPoint] = []
    
    func addPoint(aPoint: CGPoint) {
        points.append(aPoint)
    }
    
    func reset() {
        points.removeAll()
    }
    
    func path() -> CGPath? {
        
        let aPath = CGMutablePath.init()
        
        var pathPoints = self.points
        
        guard pathPoints.count > 0 else {
            return aPath
        }
        
        aPath.move(to: pathPoints.removeFirst())
        
        while pathPoints.first != nil {
            aPath.addLine(to: pathPoints.removeFirst())
        }
        
        aPath.closeSubpath()
        
        return aPath.copy()
    }
    
    func bezierPath() -> UIBezierPath? {
        
        let aPath = UIBezierPath.init()
        
        var pathPoints = self.points
        
        guard pathPoints.count > 0 else {
            return aPath
        }
        
        aPath.move(to: pathPoints.removeFirst())
        
        while pathPoints.first != nil {
            aPath.addLine(to: pathPoints.removeFirst())
        }
        
        aPath.close()
        
        return aPath
    }
}
