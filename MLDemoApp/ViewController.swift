//
//  ViewController.swift
//  MLDemoApp
//
//  Created by Navdeep Singh on 21/10/19.
//  Copyright © 2019 Navdeep Singh. All rights reserved.
//
import CoreML
import UIKit
import Vision

class ViewController: UIViewController {


    // MARK: IBOutlets...................
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoLibraryButton: UIButton!
    @IBOutlet var resultsView: UIView!
    @IBOutlet var resultsLabel: UILabel!
    @IBOutlet var resultsConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        resultsLabel.text = "Take a photo or choose from library"
    }

    // MARK: IBActions...................
    @IBAction func takeImageWithCamera(_ sender: Any) {
        presentPicker(with: .camera)
    }

    @IBAction func pickImageFromLibrary(_ sender: Any) {
        presentPicker(with: .photoLibrary)
    }

    lazy var vnRequest: VNCoreMLRequest = {
        let vnModel = try! VNCoreMLModel(for: SnackModel().model)
        let request = VNCoreMLRequest(model: vnModel) { [unowned self] request , _ in
            self.processingResult(for: request)
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()

    func presentPicker(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
        hideResultsView()
    }

    func hideResultsView() {
        self.resultsView.alpha = 0
    }

    func showResultsView() {
        self.resultsView.alpha = 1
    }

    // MARK: Function to classify image using the ML Model
    func classify(image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: image)!
            let imageOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: imageOrientation)
            try! handler.perform([self.vnRequest])
        }
    }

    func processingResult(for request: VNRequest) {
        DispatchQueue.main.async {
            let results = (request.results! as! [VNClassificationObservation]).prefix(2)
            self.resultsLabel.text = results.map { result in
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 1
                let percentage = formatter.string(from: result.confidence * 100 as NSNumber)!
                return "\(result.identifier) \(percentage)%"
            }.joined(separator: "\n")
            self.showResultsView()
        }
    }

}

