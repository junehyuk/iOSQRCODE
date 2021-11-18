//
//  ScannerViewController.swift
//  joylolqr
//
//  Created by 양준혁 on 27/06/2018.
//  Copyright © 2018 양준혁. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation
import AudioToolbox

// QR코드 스캐너 뷰 소스코드 시작
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    
    func testObject () {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AVCapture대상을 비디오로 설정한다.
        captureDevice = AVCaptureDevice.default(for: .video)
        
        if let captureDevice = captureDevice {
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                
                // 읽어들일 양식의 MetaData를 설정한다.
                //AVMetadataObject.ObjectType
                //QR코드의 종류를 바꾸려면 QR제외 메타 종류 데이터 값을 없애면 됨.
                
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39]
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                print("Error Device Input")
            }
        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let stringCodeValue = metadataObject.stringValue else { return }
        captureSession?.stopRunning()
        
        
    }
    
    
}
