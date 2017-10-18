//
//  MemeEditorViewController.swift
//  MemeMeV2
//
//  Created by Jennifer Liu on 06/10/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - MemeEditorViewController: UIViewController, UINavigationControllerDelegate

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    // MARK: Text Field Delegate Object
    
    let textFieldDelegate = TextFieldDelegate()
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Disable cameraButton if device has no camera and disable shareButton before an image is picked
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.shareButton.isEnabled = false
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(textField: self.topTextField)
        configureTextField(textField: self.bottomTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Configuration Functions
    
    func configureTextField (textField: UITextField) {
        textField.delegate = textFieldDelegate
        
        textField.defaultTextAttributes = textFieldDelegate.memeTextAttributes
        textField.textAlignment = .center
    }
    
    func configureNavToolbars (isHidden: Bool) {
        self.topToolbar.isHidden = isHidden
        self.bottomToolbar.isHidden = isHidden
        self.navigationController?.navigationBar.isHidden = isHidden
    }
    
    // MARK: Keyboard Adjustment Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Meme Generating Functions
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        print(appDelegate.memes)
    }
    
    func generateMemedImage() -> UIImage {
        
        configureNavToolbars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureNavToolbars(isHidden: false)
        
        return memedImage
    }
    
    // MARK: Actions
    
    @IBAction func captureImage(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        shareController.excludedActivityTypes = [UIActivityType.print, UIActivityType.addToReadingList, UIActivityType.assignToContact]
        
        shareController.completionWithItemsHandler = {
            (UIActivityType, completed: Bool, returnedItems: [Any]?, activityError: Error?) -> Void in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIImagePicker Delegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        // Enable shareButton after an image is picked
        dismiss(animated: true, completion: { () -> Void in
            self.shareButton.isEnabled = true
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func chooseSourceType (sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
    }
}
