//
//  QRCodeViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 30/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet weak var qrCodeBox: UIImageView?
    @IBOutlet weak var timerLabel: UILabel!
    
    weak var testDelegate: prTransactionTestDelegate?
    // 
    var timeout = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //timeout from node
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeout), userInfo: nil, repeats: true)
        
        guard let QRCodeNode = CStateMachine.currentNode else {return}
        

        if let imageView = qrCodeBox
        {
            var qrCode = ""
            if let qrCodeParsingData = QRCodeNode.qrCodeParsingData
            {
                if (nil != qrCodeParsingData.getQc()) {
                    
                    var arrCodeParsingData: [QRCodeData] = qrCodeParsingData.getQc()!
                    arrCodeParsingData = arrCodeParsingData.sorted { $0.index < $1.index }
                    
                    for i in 0 ..< arrCodeParsingData.count {
                        qrCode.append(arrCodeParsingData[i].getQc())
                    }
                }
            }
            
            imageView.image = createQRFromString(qrCode , imageView.frame.size)
        }
        

        // Do any additional setup after loading the view.
    }

    @objc func updateTimeout() {
        //example functionality
        if timeout > 0 {
            timerLabel.text = "\(timeout)"
            timeout -= 1
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let tempNode = CStateMachine.currentNode?.GotoChild()
        TransactionHUB.goToNode(tempNode, self.navigationController, testDelegate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    func UPIBarcodeClicked() {
//        
//       
//        let img = createQRFromString("upi://pay?pa=TestUPI.100007727@icici&amp;pn=My Bar Private&amp;mc=4812&amp;tr=TES16000099999000004&amp;cu=INR&am=123.45", (qrCodeBox?.frame.size)!)
//        qrCodeBox!.image = img
//    }
    
    func createQRFromString(_ str: String, _ size: CGSize) -> UIImage {
        let stringData = str.data(using: .utf8)

      let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
      qrFilter.setValue(stringData, forKey: "inputMessage")
      qrFilter.setValue("H", forKey: "inputCorrectionLevel")

      let minimalQRimage = qrFilter.outputImage!
      // NOTE that a QR code is always square, so minimalQRimage..width === .height
      let minimalSideLength = minimalQRimage.extent.width

      let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
      let scaleFactor = smallestOutputExtent / minimalSideLength
      let scaledImage = minimalQRimage.transformed(
        by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))

      return UIImage(ciImage: scaledImage,
                     scale: UIScreen.main.scale,
                     orientation: .up)
    }

    
}
