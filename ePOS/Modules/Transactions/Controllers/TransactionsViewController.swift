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
        super.viewDidLoad()

        debugPrint("Hello World!")
        if let path = Bundle.main.path(forResource: "COD", ofType: "xml")
        {
            guard let str = try? String.init(contentsOfFile: path)
                else {
                    return
            }
            let obj = XmlParser()
            obj.parsePVM(str)
        }
        
        let globalData = GlobalData.singleton
        _ = globalData.FirstInitialize()
//
        let isoprocessor = ISOProcessor()
        _ = isoprocessor.DoHUBActivation()
        
        
//        DoActivation()
//        DoInitializtion()
//        DoSettlement()
//        DoTransaction()
//        DoSettlement()
            
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



func DoSettlement()
{
    let isoprocessor = ISOProcessor()

    //isoprocessor.SetCommunicationParam(disconnectFlag)

    var iSettlementResponse: Int = 0
    
    iSettlementResponse = isoprocessor.DoHubSettlement()
    debugPrint("iSettlementResponse[\(iSettlementResponse)]")
    
    GlobalData.m_bIsSettleBatchSuccessfullyRun = false
    if (iSettlementResponse == AppConstant.TRUE) {
        GlobalData.m_bIsSettleBatchSuccessfullyRun = true
        //retVal = RET_OK
    } else {
        GlobalData.m_bIsSettleBatchSuccessfullyRun = false
        //retVal = RetVal.RET_NOT_OK
    }
}

func DoActivation()
{
    //let globalData = GlobalData.singleton
    //_ = globalData.FirstInitialize()
    
    let isoprocessor = ISOProcessor()
    _ = isoprocessor.DoHUBActivation()
}

func DoTransaction()
{
    var isopr = ISOProcessor()
    if (TransactionHUB.singleton.m_isoProcessor != nil) {
        isopr = TransactionHUB.singleton.m_isoProcessor!
    } else {
        isopr = ISOProcessor()
        TransactionHUB.singleton.m_isoProcessor = isopr
    }
    var _: Int = isopr.SetCommunicationParam(true)
    var status: Int = 0
    
    //TODO: HAVE TO REMOVE HARDCODED TXNTYPE
    let globalData = GlobalData.singleton
    
    //TODO: Have to Remove
    globalData.m_sNewTxnData.uiTransactionType = HostTransactionType.COD_TXN
    TransactionHUB.AddTLVDataWithTag(uiTag: 0x1015, Data: [Byte]("12345".utf8), length: 5)
    TransactionHUB.AddTLVDataWithTag(uiTag: 0x1021, Data: [Byte]("10000".utf8), length: 5)
    TransactionHUB.AddTLVDataWithTag(uiTag: 0x1112, Data: [Byte]("10000".utf8), length: 5)
    TransactionHUB.AddTLVDataWithTag(uiTag: 0x6101, Data: [Byte]("12345".utf8), length: 5)
    TransactionHUB.AddTLVDataWithTag(uiTag: 0x6102, Data: [Byte]("12345".utf8), length: 5)
    
    
    status = isopr.DoHubOnlineTxn()
    //reset Pay by mobile related flag when dialog hides
    GlobalData.singleton.isPayByMobileEnabled = false
    if (status == 1) {
        GlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = true
        debugPrint("Online Transaction successfully run")
    } else {
        GlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = false
        debugPrint("Online Transaction Failed")
    }
}

func DoInitializtion()
{
    
    let globalData = GlobalData.singleton
    //_ = globalData.FirstInitialize()
    
    let isoprocessor = ISOProcessor()
    //_ = isoprocessor.DoHUBActivation()
    
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
    //CUIHelper.SetMessage("PROCESSING")
    _ = globalData.UpdateMessageFile()
    _ = globalData.UpdateMasterCTFile()
    _ = globalData.UpdateMasterIMFile()
    _ = globalData.UpdateMasterCLRDIMFile()
    _ = globalData.UpdateMasterFCGFile()
    _ = globalData.UpdateMasterFONTFile()
    _ = globalData.UpdateMasterLIBFile()
    _ = globalData.UpdateMasterMINIPVMFile()
}
