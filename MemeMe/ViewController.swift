//
//  ViewController.swift
//  MemeMe
//
//  Created by James Whitney on 1/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController: UIController, UINavigationControllerDelegate, UIImagePickerControllerDelegate

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    // Class property for setting text attributes.
    let memeTextAttributes: [String: Any] = [
        
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.backgroundColor.rawValue: UIColor.clear,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : NSNumber(value: -3.0)
    ]
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign textField outlets to utilize UITextFieldDelegate.
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        // Create default text for topText using memeTextAttributes. Center text and set text to TOP.
        topText.defaultTextAttributes = memeTextAttributes
        self.topText.textAlignment = .center
        topText.text = "TOP"
        
        // Create default text for bottomText using memeTextAttributes. Center text and set text to BOTTOM.
        bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.textAlignment = .center
        bottomText.text = "BOTTOM"
        
        // Change view background color to black.
        view.backgroundColor = UIColor.black
    }
    
    // Clear default text to empty string when text editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Once return is selected, exit text field editing.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check if camera source is available. If not disable camera button.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Actions
    
    // When albumButton is selected present user with photo album picker.
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // When cameraButton is selected, open camera app so user can take a photo.
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Function shifts view up or leaves it in default position.
    @objc func keyboardWillShow(_ notification: Notification) -> Void {
        
        // If bottomText is being edited shift view up to move so keyboard does not cover the text field.
        if bottomText.isFirstResponder {
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        // Leave view in original position if topText is being edited.
        else if topText.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    // Function gets heighth of keyboard and returns value to keyboardWillShow.
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Notifies view that keyboard will appear.
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    // Notifies view that keyboard will be dismissed.
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    // MARK: Utility
    
    // Function takes user selection from a dictionary of images and displays selected image as originalImage.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage.image = image
        }
    }
    

}

