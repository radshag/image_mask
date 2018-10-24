//
//  TracerImageView.swift
//  tinytap
//
//  Created by Dov Goldberg on 23/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit
import UIView_draggable

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
        guard
            let touch = touches.first,
            let _ = self.image
        else {
            return
        }
        
        let point = touch.preciseLocation(in: self)
        
        self.tracerImageViewDelegate?.tracer(imageView: self, didTouchAt: point)
    }
    
    private func end(touches: Set<UITouch>) {
        guard
            let _ = self.image
            else {
                return
        }
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


protocol TracerImageViewDraggableContentDelegate: class {
    func tracer(imageView: UIImageView, didLongPress gesture: UILongPressGestureRecognizer)
}

class TracerImageViewDraggableContent: UIImageView, TracerImageDraggableContent {
    
    public var delegate: TracerImageViewDraggableContentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.isUserInteractionEnabled = true
        self.enableDragging()
        
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(TracerImageViewDraggableContent.handleLongPress(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        delegate?.tracer(imageView: self, didLongPress: gestureRecognizer)
    }
}
