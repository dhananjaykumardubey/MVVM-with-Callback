//
//  UITextField.swift
//  Currency
//
//  Created by Dhananjay Kumar Dubey on 14/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    
    /// Adds a Done button in textFields input accessory view
    func addDoneButton() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    /**
     Adds an image into a right view of textfield
     - parameters:
        - imageName: Image which needs to be added in textfield
     */
    func setupRightImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)?.tinted(with: .lightGray)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        self.rightView = imageContainerView
        self.rightViewMode = .always
        self.tintColor = .lightGray
    }
    
    @objc private func doneButtonAction(){
        self.resignFirstResponder()
    }
}
