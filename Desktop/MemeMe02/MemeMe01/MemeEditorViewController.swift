//
//  MemeEditorViewController.swift
//  MemeMe01
//
//  Created by Yasunaka Cho on 12/17/15.
//  Copyright © 2015 Yasunaka Cho. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName:  UIColor.whiteColor(),
        NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if bottomTextField.isFirstResponder(){
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) ->CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey]as! NSValue
        return keyboardSize.CGRectValue().height
    }
        
    func generateMemedImage() ->UIImage {
        
        //TODO: Hide toolbar and navbar
        navigationController?.navigationBar.hidden = true
        toolBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
        navigationController?.navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image, memedImage: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        let memedImage = self.generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        print("cancel")
    }
    
    
 
}

