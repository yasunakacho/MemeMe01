//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID: Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in 
            
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }

            
            if error == nil {
                
                if let data = data {
                
                    let parsedResult: AnyObject!
                    do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    if let photosDictionary =
                        parsedResult [Constants.FlickrResponseKeys.Photos] as? [String: AnyObject],
                        photoArray = photosDictionary [Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]]{
                        
                            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                            let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
                            
                            if let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String,
                                let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String {
//                                    print(imageUrlString)
//                                    print(photoTitle)
                                    
                                    let imageURL = NSURL(string: imageUrlString)
                                    if let imageData = NSData(contentsOfURL: imageURL!){
                                        
                                        performUIUpdatesOnMain(){ self.photoImageView.image = UIImage(data: imageData)
                                            self.photoTitleLabel.text = photoTitle
                                            self.setUIEnabled(true)
                                        }
                                    }
                                    
                            }
                    }
            }
            }
        }

        
        task.resume()
        
        // TODO: Write the network code here!
    }
    
    private func escapedParameters(parameters: [String: AnyObject]) -> String{
    
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
            
                let stringValue = "\(value)"
                
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        
        }
    
    }
}