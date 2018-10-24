//
//  TracerImageView.swift
//  tinytap
//
//  Created by Dov Goldberg on 23/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

protocol TracerImageViewDelegate: class {
    func tracer(imageView: UIImageView, didTouchAt point: CGPoint)
    func tracerImageViewTouchesEnded()
}

class TracerImageView: UIImageView {
    
    public weak var tracerImageViewDelegate: TracerImageViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func processTouches(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.preciseLocation(in: self)
        
        self.tracerImageViewDelegate?.tracer(imageView: self, didTouchAt: point)
    }
    
    private func end(touches: Set<UITouch>) {
        self.processTouches(touches: touches)
        self.tracerImageViewDelegate?.tracerImageViewTouchesEnded()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.processTouches(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.processTouches(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.end(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.end(touches: touches)
    }
}

protocol TracerImageDraggableContent {
    
}

class TracerImageViewDraggableContent: UIImageView, TracerImageDraggableContent {
    
}
