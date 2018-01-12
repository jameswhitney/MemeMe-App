//
//  ViewController.swift
//  MemeMe
//
//  Created by James Whitney on 1/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var originalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickAnImage(_ sender: Any) {
        
        let originalImage = UIImagePickerController()
        originalImage.delegate = self
        originalImage.sourceType = .photoLibrary
        present(originalImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage.image = image
        }
    }
    

}

