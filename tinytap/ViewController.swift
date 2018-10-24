//
//  ViewController.swift
//  tinytap
//
//  Created by Dov Goldberg on 23/10/2018.
//  Copyright © 2018 Dov Goldberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addImageButon: UIButton!
    
    @IBOutlet weak var tracerImageView: TracerImageView!
    var tracerImageViewModel: TracerImageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageButon.layer.cornerRadius = addImageButon.bounds.size.width / 2
        // Do any additional setup after loading the view, typically from a nib.        
        tracerImageViewModel = TracerImageViewModel.init(tracerView: tracerImageView, viewController: self)
        loadImage()
    }
    
    @IBAction func onAddImagePressed(_ sender: Any) {
        loadImage()
    }
    
    private func loadImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else {
                return
        }
        
        self.tracerImageViewModel?.setImage(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
}

