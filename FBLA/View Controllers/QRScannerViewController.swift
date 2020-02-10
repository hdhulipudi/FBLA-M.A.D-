//
//  QRScannerViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 1/3/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var currentEventID = ""
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let uuid = Auth.auth().currentUser!.uid
    var qrCodeValidity = true


    @IBOutlet weak var qrView: UIImageView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = UIColor.black
        //Allows the camera to record
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                failed()
                return
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            captureSession.startRunning()
        }
    // MARK: - Failed

//Shows an alert if failed to open camera
        func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }
    // MARK: - QRCode Capture Session


        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }

            dismiss(animated: true)
        }
    // MARK: - Verification

    //Checks if the QR Code matches the the event ID
        func found(code: String) {
            let scannedEventID = code
            if scannedEventID == currentEventID{
                let db = Firestore.firestore()
                db.collection("users").document(uuid).getDocument() { (document, error) in

                              if let error = error {

                                  print(error.localizedDescription)

                              } else {

                                if let document = document, document.exists {
                                let firstName = document.get("firstName") as! String
                                    db.collection("events").document(self.currentEventID).collection("users1").document(self.uuid).setData(["name" : firstName])
                                    self.qrCodeValidity = true
                                    //EventViewController().getSignUpStatus(eventID: self.currentEventID)
                                
                                    
                                  }
                              }
                          }
                
            }
            else{
                qrCodeValidity = false
                
            }
            
            
        }
    //Hides status bar to make the camera view fullscreen
        override var prefersStatusBarHidden: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
    }
