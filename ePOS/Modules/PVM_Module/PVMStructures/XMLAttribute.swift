//
//  XMLAttribute.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct XMLATTRIBUTE {
    var node_type:Int = 0; // node type of the class
    var iName:String = ""; // name of the node.
    var iNameImage:String = ""; // name img.
    var fileName:String = ""; //file name
    var viewType:String = ""; // view type(video/gif)
    var soundTrack:String = "";
    var Timeout:Int = 0; // Timeout parameter for the execution.
    var cascading:Int = 0; // cascading attribute
    var brightnessLevel:Int = 0;//brightness level
    var goToOrignalBrightness:Int = 0;//brightness remain same
    var ListViewcode=2 ; // ListViewcode parameter for the menu screen view.
    var HostTlvtag:Int = 0; // host tag for this node .
    var HostActiontag:Int = 0;
    var iHostType:Int = 0;
    var onOk = PvmNodeActions.exitPvm; // Action to take if excutions is completed successfully.
    var onCancel:Int = 0; // Action to take if execution is cancled.
    var onExit:Int = 0; // Action to take if execution is exited.
    var onTimeout:Int = 0; // Action to take if timeout has happened during
    
    
    var Title:String = ""; // Title of the Menu window.
    var IsLatLong:Bool = false;
    var txtye:String = "";
    var regx:String = "";//regex defined
    var dval:String = "";//default value
    
    // Menu Index class
    var ItemName:String = "";
    var ItemIndex:Int = 0;
    var DisplayMessage:String = "";
    var ScanType:String = "";
    var DisplayMessageLine2:String = "";
    var DisplayMessageLine3:String = "";
    var DisplayMessageLine4:String = "";
    // amitesh:: for UniCode display messages length storage
    var DisplayMessagelen:Int = 0;
    var DisplayMessageLine2len:Int = 0;
    var DisplayMessageLine3len:Int = 0;
    var DisplayMessageLine4len:Int = 0;
    var isIdeFlagEnabled:Bool = false ;
    var numberOFItems:Int = 0;
    var MaxLen:Int16 = 0;
    var MinLen:Int16 = 0;
    var CurrencyName:String = "";
    var Decimals:Int16 = 0;
    var InputMethod:enum_InputMethod?;
    
    // Confirmation class
    var KEY_F1:Int = 0;
    var KEY_F2:Int = 0;
    var KEY_F3:Int = 0;
    var KEY_F4:Int = 0;
    var KEY_ENTER:Int = 0;
    var KEY_CANCEL:Int = 0;
    var KeyF1:String = "";
    var KeyF2:String = "";
    var KeyF3:String = "";
    var KeyF4:String = "";
    
    // event wait class
    var EventMask:Byte = 0;
    
    // Added for Extended event mask
    var IsExtendedEventMask:Bool = false;
    var ExtendedEventMask:[Byte] = [0];
    
    var numberOFItemsInMenuList:Int = 0;
    var numberOFImages:Int = 0;
    var ItemList:[String]?;
    var ItemListImages:[ImageListParserModel]?;
    
    var iKeySlot:Int = 0;
    var SessionKey:[Byte] = [0];
    var IsOnSSL:Int = 0;
    
    var chAmount:String = ""; // Added for amount using XML
    var chCurrencyCode:String = ""; // Added for DCC CurrencyCode using XML
    
    // Added for TLE encryption parameters
    var chPadChar:Byte = 0;
    var iPadStyle = Byte(AppConstant._LEFT_PAD);
    var iTleEnabled:Bool = false;
    
    var iIsIris:Bool = false; // Added for IRIS functionality
    var IsUTF8:Bool = false; // Added for UniCode PVM functionality
    var IsSignCapture:Bool = false;
    
    var fontId:Int = 0; // added for Unicode pvm
    var useHtlForTag:Bool = false;
    var multipleCardPinGrpId:Int = 0;
    var ISOType:Int = 0; // added abhishek for biometric
    var RetryCount:Int = 0; // added abhishek for biometric
    var RetryCountTimeOut:Int = 0; // added abhishek for biometric
    var chQRmsg1:String = "";
    var chQRmsg2:String = "";
    var chQRmsg3:String = "";
    var chQRmsg4:String = "";
    var chQRmsg5:String = "";
    var chDisplayMsgHeader:String = "" ;
    var chDisplayMsgFooter:String = "";
    var pvmListParser:[PvmListParserVO]?;
    var qrcodescanningListParser:[QRCodeScanningParserVO]?;
    var qrCodeParsingData:QRCodeParsingData?;
    var bIsOfflineQrCode:Bool = false;
    var bIsRunTimeQR:Bool = false;
    var iHostCatID:Int = 0;
    var parenNode:CBaseNode?;
}
