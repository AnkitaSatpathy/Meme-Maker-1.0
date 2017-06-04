//
//  ViewController.swift
//  Lets meme
//
//  Created by Ankita Satpathy on 03/06/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,  UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var camBtn: UIBarButtonItem!
    
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var bottomTF: UITextField!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName:6]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // bottomTF.isEnabled = false
        //topTF.isEnabled = false
        
       camBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTF.defaultTextAttributes = memeTextAttributes
        bottomTF.defaultTextAttributes = memeTextAttributes
        topTF.text = "TOP"
        bottomTF.text = "BOTTOM"
        
        topTF.delegate = self
        bottomTF.delegate = self
        
        topTF.textAlignment = .center
        bottomTF.textAlignment = .center
    }
    
    @IBAction func PickTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageview.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraBtntapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)

    }

    @IBAction func cancelTapped(_ sender: Any) {
        shareBtn.isEnabled = false
        topTF.text = "TOP"
        bottomTF.text = "BOTTOM"
        imageview.image = nil
    }
    
    //MARK: TEXTFIELD METHODS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    //MARK: Keyboard Notifications
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
   
    //When the keyboardWillShow notification is received, shift the view's frame up
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTF.isFirstResponder {
        view.frame.origin.y -= getKeyboardHeight(notification)
      }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTF.isFirstResponder{
         view.frame.origin.y += getKeyboardHeight(notification)
      }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage {
        
        self.navBar.isHidden = true
        self.toolBar.isHidden =  true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }

    func saveMemedImage(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTF.text!, bottomText: bottomTF.text!, originalImage: imageview.image!, memedImage: memedImage)
    }
    @IBAction func shareBtnTapped(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        present(shareController, animated: true, completion: nil)
    
    }
    
   }

