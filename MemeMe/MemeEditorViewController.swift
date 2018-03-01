//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by James Whitney on 1/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController: UIController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage!
    
    // Class property for setting text attributes.
    let memeTextAttributes: [String: Any] = [
        
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.backgroundColor.rawValue: UIColor.clear,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : NSNumber(value: -3.0)
    ]
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Initialize Meme class struct to save edited meme state.
    // The implementaion for this function came from the iOS ND forum.
    func save() {
        
        _ = Meme(topTextField: topText.text!, bottomTextField: bottomText.text!, originalImage: originalImage.image!, memedImage: memedImage)
    }
    
    // Render text and image and return both as one UIImage.
    func generateMemedImage() -> UIImage {
        
        hideTopAndBottomBars(true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        hideTopAndBottomBars(false)
        
        return memedImage
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        
        if  !hide {
            navBar.isHidden = false
            toolBar.isHidden = false
        } else {
            navBar.isHidden = true
            toolBar.isHidden = true
        }
        
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItemds: [Any]?, error: Error?) -> Void in
            if completed {
                self.save()
            }
        }
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(textField: topText, withText: "TOP")
        configure(textField: bottomText, withText: "BOTTOM")
        
    }
    
    // Check if camera source is available. If not disable camera button.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        hideOrShowShareButton()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    // MARK: Meme Editor
    
    func configure(textField: UITextField, withText text: String) {
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }

    
    // Clear default text to empty string when text editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Once return is selected exit text field editing.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // This function decides decides where image for meme is selected based on sourceType.
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    // Camera button launches camera.
    @IBAction func imageSourceFromCamera(_ sender: Any) {
        pickAnImageFrom(sourceType: .camera)
    }
    
    // Album button launches Photo Library.
    @IBAction func imageSourceFromPhotoLibrary(_ sender: Any) {
        pickAnImageFrom(sourceType: .photoLibrary)
    }
    
    
    
    // MARK: Utilities
    
    // Function takes user selection from a dictionary of images and displays selected image as originalImage.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage.image = image
        }
    }
    
    // Only enable the shareButton when there is an image in the meme editor
    func hideOrShowShareButton() {
        
        shareButton.isEnabled = originalImage.image != nil
        
    }
    
    // cancelButton resets view and text to default settings.
    @IBAction func resetMemeView(_ sender: Any) {
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        originalImage.image = nil
        
        hideOrShowShareButton()
        
    }
    
    // Function shifts view up so bottomText can be seen while using keyboard.
    @objc func keyboardWillShow(_ notification: Notification) {
        
        self.view.frame.origin.y = bottomText.isFirstResponder ? -getKeyboardHeight(notification) : 0
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
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    

}

