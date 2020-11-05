//
//  PrinterHandler.swift
//  ePOS
//
//  Created by Vishal Rathore on 03/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class PrinterHandler{
    
    var m_iPrinterType: Int
    var m_bArrPrintDump: [Byte]?
    var m_iPrintDumpLen: Int

    static let AMEX_LOGO_TAG: Int = 0x01
    
    static let AMEX_BASE_AMT_TAG: Int = 0x19
    static let AMEX_TIP_AMT_TAG: Int = 0x1A
    static let AMEX_SEPARATOR_LINE_TAG: Int = 0x1B
    static let AMEX_TOTAL_AMT_TAG: Int = 0x1C
    static let AMEX_CVM_LINE_TAG: Int = 0x1D
    static let AMEX_MERCHANT_CUSTOMER_COPY_TAG: Int = 0x1F
    static let AMEX_SIGNATURE_IMAGEID_TAG: Int = 0x23
    static let AMEX_DYNAMIC_CHARGESLIP_TMPL_ID: Int = 0x50
    
    static let NotAligned: Int = 0
    static let CenterAligned: Int = 1
    static let RightAligned: Int = 2
    static let Justified: Int = 3
    static let PrintTextNormal: Int = 0
    static let PrintTextDoubleHeight: Int = 1
    
    static let PrintWidth24: Int = 0
    static let PrintWidth40: Int = 1
    static let PrintWidth48: Int = 2
    
    static let m_iPrintLen: Int = 0
    
    var dataToPrint: String = ""
    var globalData = GlobalData.singleton
    var strDisplayDialogMessage: String = ""
    
    var bIsBufferRemaining: Bool = true;
    
    init() {
        m_iPrinterType = 1
        m_iPrintDumpLen = 0x00
    }
    
    func ProcessPrintDump(bArrPrintData: [Byte], iPrintDumpLength: Int) -> Bool {
        var printerDataDisplayArrayList = [PrinterDataDisplay]()
        var printDataToPrint: String = ""
        var strBarCodeData = [String]()
        var strQRCode = [String]()
        var printDataImage = [[Byte]]()
        
        do{
            debugPrint("Inside method ProcessPrintDump")
            bIsBufferRemaining = true;

            //TODO: Context, Toast Incomplete
            /*    if (context == null) {
                context = MainActivity.m_context;
            }
            toast = Toast.makeText(context, "", Toast.LENGTH_SHORT) */
            
            globalData.m_bPrinterData = Array(bArrPrintData[0 ..< iPrintDumpLength])
            //System.arraycopy(bArrPrintData, 0, globalData.m_bPrinterData, 0, iPrintDumpLength);
            globalData.m_iPrintLen = iPrintDumpLength

            if (iPrintDumpLength <= 0) {
                //TODOD dialog Imcomplete
                /*if (dialog != null) {
                    if (dialog.isShowing()) {
                        dialog.dismiss();
                    }
                    dialog = null;
                }*/
                dataToPrint += "NO CHARGESLIP FOUND. Transaction Error.";
                _ = bFnPrintRawDump(PrintSize: dataToPrint.count, dataToPrint: dataToPrint, printerDataDisplayArrayList: printerDataDisplayArrayList, printDataImage: printDataImage, listPrintDataImage: printDataImage, listBarCodeData: strBarCodeData, listQRCode: strQRCode, bArrPrintData: bArrPrintData)
                    //StartPrint(null, 0, null,1);
                    return false
                }

            var p = [Byte](repeating: 0x00, count: iPrintDumpLength)
            let length: Int = iPrintDumpLength

            p = Array(bArrPrintData[0 ..< iPrintDumpLength])
            //System.arraycopy(bArrPrintData, 0, p, 0, iPrintDumpLength);

            var iOffset: Int = 0;

                //Print size
            var iPrintSize: Int = AppConstant.PRINTDUMP_SIZE24;

            var _: Int = 0x00;
            var iLocalOffsetToUse: Int = 0x00;
            var iLocalLoopDataLength: Int = 0x00;
            var _: Int = 0x00;
            var iTotalLength: Int = 0x00;
            var iDumpOffset: Int = 0x00;
            var _: Int = 0x00;
            var _: Int = 0x00;
            var iPrintDumpLen: Int = 0x00;
            var uiLocalBarcodeDataLen: Int = 0x00;
            var _: Int = 0x00;
            var _: Int = 0x00;
            var iLastPrintMode: Int = 0x00;
            var bIsPrintModeChanged: Bool = false;
            var _:  Bool = false;
            var bIsDisplayModePresent: Bool = false;
            var _: Bool = false


                // iOffset = 4;
                repeat {
                    //  dataToPrint = "";
                    let bPrintMode = p[iOffset]
                    iOffset += 1
                    if (iLastPrintMode == 0x00) {
                        iLastPrintMode = Int(bPrintMode & 0x0000000FF)

                    } else if (bPrintMode != iLastPrintMode) {
                        bIsPrintModeChanged = true;
                    }
                    //chargeslip Mode
                    if (bPrintMode == AppConstant.PRINTDUMP_CHARGESLIPMODE) { //this is a TLV data
                        //iLocalOffsetToUse =
                        iLocalLoopDataLength = 0x00;
                        iLocalLoopDataLength = Int(Int(p[iOffset] << 8) & Int(0x0000FF00))
                        iOffset += 1
                        iLocalLoopDataLength |= Int(p[iOffset] & 0x000000FF)
                        iOffset += 1
                        iLocalOffsetToUse = iOffset;
                        //iOffset += 0x02; //discarding first length
                        //first 2 bytes tag then length , length == 0x04 for templates , and 0x02 for tags
                        iOffset += iLocalLoopDataLength;
                        //Raw Dump Mode
                    } else if (bPrintMode == AppConstant.PRINTDUMP_RAWMODE) {
                        iDumpOffset = 0x00;
                        iTotalLength = 0x00;
                        iTotalLength = Int(Int(p[iOffset] << 8) & Int(0x0000FF00))
                        iOffset += 1
                        iTotalLength |= Int(p[iOffset] & 0x000000FF)
                        iOffset += 1
                        iDumpOffset = iOffset;
                        m_bArrPrintDump = [Byte](repeating: 0x00, count: iTotalLength + iTotalLength / 10)
                        m_iPrintDumpLen = 0x00;
                        var _: Int = 0;
                        repeat {
                            //                iOffset++; //ignore the field for print attribute
                            let bFontType = p[iOffset]
                            iOffset += 1
                            if (bFontType == 0x01 || bFontType == 0x03) {
                                iPrintSize = AppConstant.PRINTDUMP_SIZE24;
                            } else {
                                iPrintSize = AppConstant.PRINTDUMP_SIZE48;
                            }

                            iPrintDumpLen = 0x00;
                            iPrintDumpLen = Int(Int(p[iOffset] << 8) & Int(0x0000FF00))
                            iOffset += 1
                            iPrintDumpLen |= Int(p[iOffset] & 0x000000FF)
                            iOffset += 1
                            var count: Int = 0
                            var bArrPrintDumpData = [Byte](repeating: 0x00, count: iPrintDumpLen + 100)

                            var iPosNull: Int = 0;
                            //int i = m_iPrintDumpLen;
                            var k: Int = 0;
                            for _ in 0 ..< iPrintDumpLen {
                                // m_bArrPrintDump[i] = p[iOffset++];
                                //m_iPrintDumpLen++;

                                //if newline encountered, then Pos is set to 0
                                //else incremented
                                if (Character(UnicodeScalar(p[iOffset])) != "\n") {
                                    iPosNull += 1
                                } else {
                                    iPosNull = 0;
                                }
                                //if position is greater than printsize
                                //put newline in the buffer.
                                //thereby text would be printed in next line
                                //no cut would take place.
                                if (iPosNull > iPrintSize) {
                                    bArrPrintDumpData[k] = Array(String("\n").utf8)[0]
                                    count += 1
                                    k += 1
                                    bArrPrintDumpData[k] = Array(String("\r").utf8)[0]
                                    count += 1
                                    k += 1
                                    iPosNull = 1;
                                }

                                bArrPrintDumpData[k] = p[iOffset]
                                k += 1
                                iOffset += 1
                                count += 1
                            }


                            var bArrFinalDump = [Byte](repeating: 0x00, count: count)
                            bArrFinalDump = Array(bArrPrintDumpData[0 ..< count])
                            //System.arraycopy(bArrPrintDumpData, 0, bArrFinalDump, 0, count);
                            var finalData = String(bytes: bArrFinalDump, encoding: .utf8)!
                    
                            if (finalData[finalData.index(finalData.startIndex, offsetBy: finalData.count - 1)] == "\n") {
                                if (printDataToPrint.isEmpty) {
                                    printDataToPrint = finalData
                                } else {
                                    printDataToPrint = printDataToPrint + finalData;
                                }
                                finalData = finalData.substring(from: 0, to: finalData.count - 1);
                            }

                            while (finalData.count > GlobalData.m_iMaxBytesToAddPrinter) {
                                var _: String = finalData.substring(from: 0, to: GlobalData.m_iMaxBytesToAddPrinter)
                                finalData = finalData.substring(from: GlobalData.m_iMaxBytesToAddPrinter, to: finalData.count - 1)
                                if (printDataToPrint.isEmpty) {
                                    printDataToPrint = finalData;
                                } else {
                                    printDataToPrint = printDataToPrint + finalData
                                }
                            }

                        } while (iTotalLength > (iOffset - iDumpOffset));


                        m_iPrintDumpLen = 0x00;
                        m_bArrPrintDump = nil

                        //Image Mode
                    } else if (bPrintMode == AppConstant.PRINTDUMP_IMAGEMODE) {
                        var iImageID: Int = 0
                        iImageID = Int(Int(p[iOffset] << 24) & Int(0xFF000000))
                        iOffset += 1
                        iImageID |= Int(Int(p[iOffset] << 16) & Int(0x00FF0000))
                        iOffset += 1
                        iImageID |= Int(Int(p[iOffset] << 8) & Int(0x0000FF00))
                        iOffset += 1
                        iImageID |= Int(p[iOffset] & 0x000000FF);
                        iOffset += 1
                        debugPrint("ImageID= \(iImageID)")
                        let strImageID: String = String(format:"%X", iImageID)
                        debugPrint("ImageID in HEX= \(strImageID)")

                        //iOffset += 4;
                        do {
                            let strImageID8Digit: String = TransactionUtils.StrLeftPad(data: strImageID, length: 8, padChar: "0")
                            let strFileName: String = "im" + strImageID8Digit;     //Same as im%80d imageID
                            let bArrImageDump: [Byte] = FileSystem.ReadFile(strFileName: strFileName)!
                            if (bArrImageDump.isEmpty) {
                                let strNewLine: String = "\n";
                                var _: Int = AppConstant.PRINTDUMP_SIZE24;
                                if (printDataToPrint.isEmpty) {
                                    printDataToPrint = strNewLine;
                                } else {
                                    printDataToPrint = printDataToPrint + strNewLine;
                                }
                            } else if (bArrImageDump.count != 0) {
                                printDataImage.append(bArrImageDump);

                            }

                        } catch  {
                            debugPrint("Exception Occurred : \(error)")
                        }

                        //BarCode Mode
                    } else if (bPrintMode == AppConstant.PRINTDUMP_BARCODEMODE) {
                        uiLocalBarcodeDataLen = 0x00;
                        var ushBarcodeType: Byte = 0x00
                        var ushBarcodeDimension: Byte = 0x00;
                        let uchBarcodeAttribute = Byte(p[iOffset] & 0x000000FF)
                        iOffset += 1
                        ushBarcodeType = Byte(uchBarcodeAttribute & 0x0F)
                        ushBarcodeDimension = Byte((uchBarcodeAttribute >> 4) & 0x0F)
                        uiLocalBarcodeDataLen = Int(p[iOffset] & 0x000000FF)
                        iOffset += 1

                        var bArrBarCodeData = [Byte](repeating: 0x00, count: uiLocalBarcodeDataLen)
                        bArrBarCodeData = Array(p[iOffset ..< iOffset + uiLocalBarcodeDataLen])
                        //System.arraycopy(p, iOffset, bArrBarCodeData, 0, uiLocalBarcodeDataLen);
                        iOffset += uiLocalBarcodeDataLen;


                        strBarCodeData.append(String(bytes: bArrBarCodeData, encoding: .utf8)!)

                        //Print Message Mode
                    } else if (bPrintMode == AppConstant.PRINTDUMP_PRINTMESSAGEMODE) {
                        iOffset += 4;
                        //do file handling at the time of printing
                        //Display Message Mode
                    } else if (bPrintMode == AppConstant.PRINTDUMP_QRCODEPD) {

                        var uiLocalQRcodeDataLen: Int = 0x00;

                        uiLocalQRcodeDataLen = Int(p[iOffset] & 0x000000FF)
                        iOffset += 1
                        uiLocalQRcodeDataLen = uiLocalQRcodeDataLen << 8;
                        uiLocalQRcodeDataLen |= Int(p[iOffset] & 0x000000FF)
                        iOffset += 1
                        var chTempArrBCD = [Byte](repeating: 0x00, count: uiLocalQRcodeDataLen)

                        debugPrint("QRCodeDump : iOffset = \(iOffset) uiLocalQRcodeDataLen = \(uiLocalQRcodeDataLen)");

                        chTempArrBCD = Array(p[iOffset ..< iOffset + uiLocalBarcodeDataLen])
                        //System.arraycopy(p, iOffset, chTempArrBCD, 0, uiLocalQRcodeDataLen);
                        debugPrint( "QRCodeDump : chTempArrBCD = \(chTempArrBCD)");
                        iOffset += uiLocalQRcodeDataLen;

                        strQRCode.append(String(bytes: chTempArrBCD, encoding: .utf8)!)
    //                    if (uiLocalQRcodeDataLen > 0)
    //                    {
                        // bFnPrintQRCode(strQRCode,context);
    //                        if(dialog != null)
    //                        {
    //                            if(dialog.isShowing())
    //                            {
    //                                dialog.dismiss();
    //                            }
    //                            dialog = null;
    //                        }
    //                    }

                    } else if (bPrintMode == AppConstant.PRINTDUMP_QRCODEMODE) {
                        let strTxnField52Name: String = String(format: "%s", FileNameConstants.TXNFEILD52NAME)
                        debugPrint("txn field 52 file name[\(FileNameConstants.TXNFEILD52NAME)]")

                        let bArrField52Data: [Byte] = FileSystem.ReadFile(strFileName: strTxnField52Name)!

                        let strField52Data: String = String(bytes: bArrField52Data, encoding: .utf8)!
                        debugPrint("\(strTxnField52Name) file len[\(bArrField52Data.count)] and Buffer=[\(strField52Data)]")
                        if (!strField52Data.isEmpty) {
                            // bFnPrintQRCode(strField52Data,context);
                            strQRCode.append(strField52Data);
                        }
                    } else if (bPrintMode == AppConstant.PRINTDUMP_QRCODEMODEBASE64) {
                        let strTxnField52Name = String(format: "%s", FileNameConstants.TXNFEILD52NAME)
                        debugPrint("txn field 52 file name[\(FileNameConstants.TXNFEILD52NAME)]")

                        let bArrField52Data: [Byte] = FileSystem.ReadFile(strFileName: strTxnField52Name)!
                        
                        let strField52Data: String = String(bytes: bArrField52Data, encoding: .utf8)!
                        debugPrint("\(strTxnField52Name) file len[\(bArrField52Data.count)] and Buffer=[\(strField52Data)]")

                        let strPlainData = String(bytes: bArrField52Data, encoding: .utf8)!
                        
                        let strBase64data = Data(base64Encoded: strPlainData, options: .ignoreUnknownCharacters)!
                        let strBase64Data = String(data: strBase64data, encoding: .utf8)
                        //String strBase64Data = Base64.encodeToString(bArrField52Data, Base64.DEFAULT);
                        if (!strBase64Data!.isEmpty) {
                            strQRCode.append(strPlainData)
                        }
                    } else if (bPrintMode == AppConstant.PRINTDUMP_DISPLAYMODE) {
    //                confirm whether to print customer copy or not or vice versa
    //                also parse field 58 of ISO 230 with the same logic
                        var iDisplayLen: Int = 0x00
                        var iPrintDataLen: Int = 0x00
                        iDisplayLen = Int(p[iOffset])
                        iOffset += 1
                        iDisplayLen <<= 8
                        iDisplayLen |= Int(p[iOffset])
                        iOffset += 1
                        
                        var chArrDisplayMessage = [Byte](repeating: 0x00, count: 250)

                        var iDispArrOffset: Int = 0x00
                        //parse display message here
                        var iLocalOffset: Int = 0x00
                        var iDumpLocalOffset: Int = iOffset
                        repeat {
                            let uchAction: Byte = p[iDumpLocalOffset]
                            iDumpLocalOffset += 1
                            iLocalOffset += 1
                            if (uchAction == 0x02) {
                                var iLocalDataLen: Int = 0x00;
                                iLocalDataLen = Int(p[iDumpLocalOffset])
                                iDumpLocalOffset += 1
                                iLocalDataLen <<= 8;
                                iLocalDataLen |= Int(p[iDumpLocalOffset])
                                iDumpLocalOffset += 1
                                
                                iLocalOffset += 2;
                                //ASCII display message dump
                                //memcpy_s(chArrDisplayMessage+iDispArrOffset,250-iDispArrOffset,p+iDumpLocalOffset,iLocalDataLen);
                                chArrDisplayMessage[iDispArrOffset ..< iDispArrOffset + iLocalDataLen] = ArraySlice<Byte>(p[iDumpLocalOffset ..< iDumpLocalOffset + iLocalDataLen])
                                //System.arraycopy(p, iDumpLocalOffset, chArrDisplayMessage, iDispArrOffset, iLocalDataLen);
                                iDispArrOffset += iLocalDataLen;
                                iDumpLocalOffset += iLocalDataLen;
                                iLocalOffset += iLocalDataLen;

                                strDisplayDialogMessage = (String(bytes: chArrDisplayMessage, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!
                                debugPrint("Dialgog Message= \(strDisplayDialogMessage)");
                                //do paper cutting at this place
                            } else if (uchAction == 0x05) {
                                //parse message id carry out look up concatenate in chArrDisplayMessage
                                iLocalOffset += 4;
                            } else {
                                break;
                            }

                        } while (iLocalOffset < iDisplayLen);

                        //field 58 of ISO 230 parsing logic ends here.
                        let printerDataDisplay = PrinterDataDisplay()
                        printerDataDisplay.setPrintData(printDataToPrint)
                        printerDataDisplay.setImageData(printDataImage)
                        printerDataDisplay.setQrcodeData(strQRCode)
                        printerDataDisplay.setBarcodeData(strBarCodeData)

                        printerDataDisplayArrayList.append(printerDataDisplay);
                        printDataToPrint = "";
                        printDataImage = []
                        strQRCode = []
                        strBarCodeData = []

                        iOffset += iDisplayLen;

                        iPrintDataLen = Int(p[iOffset])
                        iOffset += 1
                        iPrintDataLen <<= 8
                        iPrintDataLen |= Int(p[iOffset])
                        iOffset += 1
                        //   bIsDisplayModePresent = true;

                    }
                    bIsPrintModeChanged = false;
                } while (length > iOffset);//length > iOffset && !bIsDisplayModePresent);
                bIsDisplayModePresent = false;
                //Added Blank line after fill buffer
                var _: String = "\n"
            /*    if (printDataToPrint.isEmpty()){
                    printDataToPrint = strNewLine;
                }else {
                    printDataToPrint = printDataToPrint + strNewLine;
                }*/
                
                let printerDataDisplay = PrinterDataDisplay()
                printerDataDisplay.setPrintData(printDataToPrint)
                printerDataDisplay.setImageData(printDataImage)
                printerDataDisplay.setQrcodeData(strQRCode)
                printerDataDisplay.setBarcodeData(strBarCodeData)

                printerDataDisplayArrayList.append(printerDataDisplay)
                printDataToPrint = "";
                printDataImage = []
                strQRCode = []
                strBarCodeData = []
                let printsize: Int = AppConstant.PRINTDUMP_SIZE24;
                _ = bFnPrintRawDump(PrintSize: printsize, dataToPrint: printDataToPrint, printerDataDisplayArrayList: printerDataDisplayArrayList, printDataImage: printDataImage, listPrintDataImage: printDataImage, listBarCodeData: strBarCodeData, listQRCode: strQRCode, bArrPrintData: bArrPrintData);

                var p1: [Byte]
                var length1: Int = 0
                //TODO: Context Incomplete
                //final Context context1 = context;
                if (iOffset < length) {
                    bIsBufferRemaining = true;
                    p1 = [Byte](repeating: 0x00, count: length - iOffset)
                    p1 = Array(p[iOffset ..< length])
                    //System.arraycopy(p, iOffset, p1, 0, length - iOffset)
                    length1 = length - iOffset;
                } else {
                    bIsBufferRemaining = false;
                }

                return true;
            } catch {
                debugPrint("Exception Occurred : \(error)")
                //TODO: dialog Incomplete
                /*if (dialog != null) {
                    if (dialog.isShowing()) {
                        dialog.dismiss();
                    }
                    dialog = null;
                }*/
                return false;
            }
    }
    
    public func bFnPrintRawDump(PrintSize: Int, dataToPrint: String, printerDataDisplayArrayList: [PrinterDataDisplay], printDataImage: [[Byte]], listPrintDataImage: [[Byte]], listBarCodeData: [String], listQRCode: [String], bArrPrintData: [Byte]) -> Bool {

 
        //TODO: dialog Intent Incomplete
        /*if (dialog != null) {
            if (dialog.isShowing()) {
                dialog.dismiss();
            }
            dialog = null;
        }
        if (null == dataToPrint) {
            dataToPrint = "";
        }
        //TransactionHUB.getInstance().finishTransactionHubActivity("");
        Intent intent = new Intent(context, PrinterTextDisplayActivity.class);
        intent.putExtra(StringConstant.PRINTDATA_TAG, printerDataDisplayArrayList);
        intent.putExtra(StringConstant.PRINT_IMAGEDATA_TAG, listPrintDataImage);
        intent.putExtra(StringConstant.PRINT_BARCODEDATA_TAG, listBarCodeData);
        intent.putExtra(StringConstant.PRINT_QRDATA_TAG, listQRCode);
        intent.putExtra(StringConstant.PRINT_QRDATA_TAG, listQRCode);
        intent.putExtra("byteData", bArrPrintData);
        context.startActivity(intent);
        */
        
        return true
    }

    
    
}
