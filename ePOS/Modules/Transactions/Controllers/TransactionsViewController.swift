//
//  TransactionsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        debugPrint("Hello World!")
        
        let globalData = GlobalData.singleton
        _ = globalData.FirstInitialize()
        
        let isoprocessor = ISOProcessor()
        _ = isoprocessor.DoHUBActivation()
        

        /*globalData.UpdateMasterCTFile()
        globalData.UpdateMasterIMFile()
        globalData.UpdateMasterCLRDIMFile()
        globalData.UpdateMasterFCGFile()
        globalData.UpdateMasterFONTFile()
        globalData.UpdateMasterLIBFile()
        globalData.UpdateMasterMINIPVMFile()*/

        var iInitResponse = RetVal.RET_NOT_OK
        debugPrint("before DoHUBInitialization")
        iInitResponse = isoprocessor.DoHUBInitialization()

        //Update master CT file and master IM
        //CUIHelper.SetMessage("PROCESSING");
        /*globalData.UpdateMessageFile()
        globalData.UpdateMasterCTFile()
        globalData.UpdateMasterIMFile()
        globalData.UpdateMasterCLRDIMFile()
        globalData.UpdateMasterFCGFile()
        globalData.UpdateMasterFONTFile()
        globalData.UpdateMasterLIBFile()
        globalData.UpdateMasterMINIPVMFile()*/
        
        
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
