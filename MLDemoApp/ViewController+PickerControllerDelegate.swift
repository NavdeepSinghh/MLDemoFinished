//
//  ViewController+PickerControllerDelegate.swift
//  MLDemoApp
//
//  Created by Navdeep Singh on 21/10/19.
//  Copyright © 2019 Navdeep Singh. All rights reserved.
//
import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        let image = info[.originalImage] as! UIImage
        imageView.image = image

        classify(image: image)
    }
}
