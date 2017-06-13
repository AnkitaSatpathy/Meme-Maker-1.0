//
//  ViewController.swift
//  Lets meme
//
//  Created by Ankita Satpathy on 03/06/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,  UINavigationControllerDelegate  {
    
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
        NSStrokeWidthAttributeName: -2.5]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       camBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureTextField(textField: topTF, withText: "TOP")
        configureTextField(textField: bottomTF, withText: "BOTTOM")
    }
    
    func configureTextField(textField: UITextField, withText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = withText
        textField.delegate = self
        textField.textAlignment = .center
        
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    

    @IBAction func cameraBtntapped(_ sender: Any) {
        chooseSourceType(sourceType: .camera)

    }

    @IBAction func cancelTapped(_ sender: Any) {
        shareBtn.isEnabled = false
        topTF.text = "TOP"
        bottomTF.text = "BOTTOM"
        imageview.image = nil
    }
    
    
    
    
    
    
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
   
    
    
    func generateMemedImage() -> UIImage {
        
        configureToolandNavBar(status: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        configureToolandNavBar(status: false)
        return memedImage
    }
    
    func configureToolandNavBar(status: Bool){
        self.navBar.isHidden = status
        self.toolBar.isHidden =  status

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

    
   }


//MARK: IMAGE PICKER METHODS

extension ViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageview.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    
    func  chooseSourceType(sourceType: UIImagePickerControllerSourceType)  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
        
    }
    
}


extension ViewController: UITextFieldDelegate {
    //MARK: TEXTFIELD METHODS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}



