//
//  ViewController.swift
//  MemeMe
//
//  Created by James Whitney on 1/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController: UIController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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
    
    // Check if camera source is available. If not disable camera button.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
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
    
    // cancelButton resets view and text to default settings.
    @IBAction func resetMemeView(_ sender: Any) {
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        originalImage.image = nil
        
    }
    
    
    // Function shifts view up so bottomText can be seen while using keyboard.
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if bottomText.isFirstResponder {
            self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
        else if topText.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    // Hide keyboard and reset view to default position
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Notifies view that keyboard will be dismissed.
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
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

