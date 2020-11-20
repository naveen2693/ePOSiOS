//
//  TransactionsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class TransactionHomeViewController: UIViewController {

//@IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
//       _ =  GlobalData.singleton.FirstInitialize()
        super.viewDidLoad()

        debugPrint("Hello World!")
       let obj = XmlParser()
        obj.parsePVM(xmlType:1)
        
        let globalData = GlobalData.singleton
        _ = globalData.FirstInitialize()
        
        let isoprocessor = ISOProcessor()
        _ = isoprocessor.DoHUBActivation()
        

        _ = globalData.UpdateMasterCTFile()
        _ = globalData.UpdateMasterIMFile()
        _ = globalData.UpdateMasterCLRDIMFile()
        _ = globalData.UpdateMasterFCGFile()
        _ = globalData.UpdateMasterFONTFile()
        _ = globalData.UpdateMasterLIBFile()
        _ = globalData.UpdateMasterMINIPVMFile()

        var iInitResponse = RetVal.RET_NOT_OK
        debugPrint("before DoHUBInitialization")
        iInitResponse = isoprocessor.DoHUBInitialization()

        //Update master CT file and master IM
        //CUIHelper.SetMessage("PROCESSING");
        _ = globalData.UpdateMessageFile()
        _ = globalData.UpdateMasterCTFile()
        _ = globalData.UpdateMasterIMFile()
        _ = globalData.UpdateMasterCLRDIMFile()
        _ = globalData.UpdateMasterFCGFile()
        _ = globalData.UpdateMasterFONTFile()
        _ = globalData.UpdateMasterLIBFile()
        _ = globalData.UpdateMasterMINIPVMFile()
        
        
//        let iso = ISO440.shared // singleton
//        let isoObject = ISO440()
//
//        iso.initiateISO()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension TransactionHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//

//
//extension TransactionHomeViewController :UICollectionViewDelegateFlowLayout
//{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        <#code#>
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
//}
