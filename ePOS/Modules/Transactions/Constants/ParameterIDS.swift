//
//  ParameterIDS.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public enum ParameterIDs
{
    static let  _Invalid =   0
    static let  _Serial_Initialization_IP =    101
    static let  _Serial_Initialization_Port =    102
    static let  _Serial_Transaction_IP =    103
    static let  _Serial_Transaction_Port =    104
    static let  _Serial_Transaction_SSL_IP =    105
    static let  _Serial_Transaction_SSL_Port =    106
    static let  _Serial_Connect_Timeout = 107
    static let  _Serial_Send_Rec_Timeout = 108
    static let  _Serial_User_Id = 109
    static let  _Serial_Password = 110
    static let  _Serial_IP_Com_Port =    111
    static let  _Serial_Secondary_Initialization_IP =    112
    static let  _Serial_Secondary_Initialization_Port =    113
    static let  _Serial_Secondary_Transaction_IP =    114
    static let  _Serial_Secondary_Transaction_Port =    115
    static let  _Serial_Secondary_Transaction_SSL_IP =    116
    static let  _Serial_Secondary_Transaction_SSL_Port =    117
    
    static let  _GPRS_Primary_Phone_Number =    401
    static let  _GPRS_Secondary_Phone_Number =    402
    static let  _GPRS_Initialization_IP =    403
    static let  _GPRS_Initialization_Port =    404
    static let  _GPRS_Transaction_IP =    405
    static let  _GPRS_Transaction_Port =    406
    static let  _GPRS_Transaction_SSL_IP =    407
    static let  _GPRS_Transaction_SSL_Port =    408
    static let  _GPRS_Connect_Timeout =    409
    static let  _GPRS_Send_Rec_Timeout =    410
    static let  _GPRS_User_Id =    411
    static let  _GPRS_Password =    412
    static let  _GPRS_GPRS_Service_provider =    413
    static let  _GPRS_Secondary_Initialization_IP =   414
    static let  _GPRS_Secondary_Initialization_Port =   415
    static let  _GPRS_Secondary_Transaction_IP =   416
    static let  _GPRS_Secondary_Transaction_Port =   417
    static let  _GPRS_Secondary_Transaction_SSL_IP =   418
    static let  _GPRS_Secondary_Transaction_SSL_Port =   419
    static let  _GPRS_APN_Name =    420
    
    static let  _Batch_Size =    501
    static let  _Log_File_Size =    502
    static let  _Log_Shipping_Flag =    503
    static let  _Logging_Level =    504
    
    
    static let  _Auto_Settlement_Enabled =    505
    static let  _Settlement_Start_Time =    506
    static let  _Settlement_Frequency =    507
    static let  _Settlement_Retry_Count =    508
    static let  _Settlement_Retry_Interval =    509
    static let  _Secondary_IP_Max_Retry_Count =   510
    
    static let  _Auto_Reversal_Enabled =    511
    static let  _Auto_Reversal_First_Try_Interval =    512
    static let  _Auto_Reversal_Max_Retry_Count =   513
    static let  _Auto_Reversal_Retry_Interval =   514
    
    static let  _Always_On_GPRS_PPP =    515
    static let  _Always_On_GPRS_TCP =    516
    
    static let  _Auto_Gprs_Always_On_Enabled =    517
    static let  _Auto_Gprs_Always_On_Retry_Interval =    518
    
    static let  _Amex_Gprs_EMV_Field55_Hex_Data_Tag_Enable =    519
    static let  _Amex_Gprs_EMV_Receipt_61_Dump_Enable =    520
    
    static let  _Sign_Upload_Chunk_size =    521
    
    static let  _Auto_Premium_Service_Enabled =    522
    static let  _Auto_Premium_Service_Retry_Interval =    523
    
    static let  _Current_Tls_Ver_Supported =    524
    
    static let  _Auto_Premium_Service_Start_Time =     525
    
    static let  _Auto_Premium_Service_Frequency =     526
    static let  _Auto_Premium_Service_Retry_Count =     527
    
    static let  _Cless_PreProcessing_Amount =    529
    static let  _Cless_PreProcessing_TxnType =    530
    static let  _Cless_MaxIntegration_TxnAmt =    531
    
    static let  _IS_BIOMETRIC_ENABLED =    532
    
    static let  _NO_PRINT_CHARGESLIP_DATA =    533
    
    static let _IS_PASSWORD_NEEDED_FOR_SPECIFIC_TXNS =    542
    static let _CIMB_PRINCIPLE_OPERATOR_PASSWORD =    540
    static let _CIMB_IS_PASSWORD_SETTLEMENT =   547
    
    static let _IS_CRIS_SUPPORTED =    551
    
    static let _EMV_MERCHANT_CATEGORY_CODE =   553
    
    static let _EMVFallbackChipRetryCounter =    601
    
    static let  _Online_Pin_First_Char_Timeout =    602
    static let  _Online_Pin_Interchar_Timeout =    603
    static let  _Min_Pin_Length =    604
    static let  _Max_Pin_Length =    605
    static let  _Display_Menu_Timeout =    606
    static let  _Display_Message_Timeout =    607
    static let  _HotKey_Confirmation_Timeout =    608
    static let  _Is_Pin_Required_Service_Code_6 =   609
    static let  _Is_Pin_Bypass_Service_Code_6 =   610
    static let  _Ignore_Integrated_TXN_Amount_EMV_TXN =    611
    
    static let  _Ethernet_Initialization_IP =    701
    static let  _Ethernet_Initialization_Port =    702
    static let  _Ethernet_Transaction_IP =    703
    static let  _Ethernet_Transaction_Port =    704
    static let  _Ethernet_Transaction_SSL_IP =    705
    static let  _Ethernet_Transaction_SSL_Port =    706
    static let  _Ethernet_Connect_Timeout =    707
    static let  _Ethernet_Send_Rec_Timeout =    708
    static let  _Ethernet_Secondary_Initialization_IP         =    709
    static let  _Ethernet_Secondary_Initialization_Port     =    710
    static let  _Ethernet_Secondary_Transaction_IP         =    711
    static let  _Ethernet_Secondary_Transaction_Port         =    712
    static let  _Ethernet_Secondary_Transaction_SSL_IP     =    713
    static let  _Ethernet_Secondary_Transaction_SSL_Port     =    714
    
    static let  _HSM_Primay_IP =    801
    static let  _HSM_Primay_Port =    802
    static let  _HSM_Secondary_IP =    803
    static let  _HSM_Secondary_Port =    804
    static let  _HSM_Retry_Count =    805
    static let  _Initialization_Parameter_Enabled_Central    =    806
    static let  _Initialization_Parameter_Enabled_HUB        =    807
    static let  _Packet_Send_320 =    808
    static let  _Packet_Send_440 =    809
    static let  _Packet_Send_500 =    810
    static let  _Use_Pine_Key_Encryption =    811
    static let  _Use_Default_KeySlotID_Only =    812
    
    static let  _Content_Server_Enabled =   1010
    static let  _Content_Server_Download_Url =   1011
    static let  _Content_Server_Upload_Url =   1012
    static let  _Content_Server_Download_Apk_Url =   1013
    static let  _Content_Server_Download_Dll_Url =   1014
    static let  _Content_Server_Connection_Time_Out =   1015
    static let  _Content_Server_Socket_Time_Out =   1016
    
}
