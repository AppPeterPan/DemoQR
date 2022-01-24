//
//  ViewController.swift
//  DemoQR
//
//  Created by Peter Pan on 2022/1/24.
//

import UIKit

import AVFoundation
import Vision
import VisionKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func scan(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectBarcodesRequest { request, error in
            if let observation = request.results?.first as? VNBarcodeObservation,
               observation.symbology == .qr {
                print(observation.payloadStringValue ?? "")
            }
        }
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: scan.pageCount - 1)
        processImage(image: image)
        dismiss(animated: true, completion: nil)
    }
}
