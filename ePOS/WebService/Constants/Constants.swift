//
//  Constants.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class Constants{
public static let URL_TERM_AND_CONDITION = "http://www.example.com/terms";
public static let URL_PRIVACY_POLICY = "http://www.example.com/privacy";
public static let TERMCONDITIONS_PRIVACYPOLICY="I Agree Terms of Use & Privacy Policy"
public static let PRIVACY_POLICY="Privacy Policy"
public static let TERM_CONDITIONS="Terms of Use"
public static let QUERY_KEY1="mobileNumber"

// MARK:- Fields from product flavor: devOrTest
public static let GOOGLE_API_KEY = "AIzaSyBmuQsDr5_QLRy-GJIeiV8O_d8h4O2BpVw";
public static let REQUEST_HEADER_CLIENT_ID = "oaFxIR0VEh8yFTP9wSGSh8wBjmO9sKwU";
public static let SERVER_FINGERPRINT1 = "sha256/9BhqjcEW33HLSLYU3MslFVBSV9CjnC4yjxV6pTFlkWo=";
public static let SERVER_FINGERPRINT2 = "sha256/8Rw90Ej3Ttt8RRkrg+WYDS9n7IS03bk5bjP/UXPtaY8=";
public static let SERVER_FINGERPRINT3 = "sha256/Ko8tivDrEjiY90yGasP6ZpBU4jwXvHqVvQI0GS3GNdA=";

// MARK:-API URL EndPoints

public static let CONFIGURATION_URL = "/rest/configuration/list";
// MARK:-Authentication Urls
public static let CHECk_USER_URL = "rest/authentication/epos/checkUser";
public static let VERIFY_OTP_URL = "rest/authentication/epos/verify";// VerifyOTP URL
public static let LOGIN_URL = "rest/authentication/epos/login";
public static let SIGNUP_URL = "rest/authentication/epos/register";// REGISTRATION URL
public static let SEND_OTP_URL = "rest/authentication/epos/sendOTP";// SendOTP URL
public static let FORGOT_PASSWORD_URL = "rest/authentication/epos/forgotPassword";// For
public static let RESET_PASSWORD_URL = "rest/authentication/epos/resetPassword";// Reset Password URL
public static let CHECK_UPGRADE_URL = "/rest/configuration/application/upgradeAvailable";// Check App public static letgrade URL
public static let ADD_USER_URL = "/rest/data/epos/createUser";// ADD user URL(POST)
public static let FETCH_USERS_URL = "/rest/data/epos/merchant/fetchUser";// Fetch user URL(GET)
public static let LOGOUT_URL = "/rest/data/logout";// Logout user URL(POST)
public static let GET_PROFILE_URL = "/rest/data/epos/getProfile";// Logout user URL(POST)
public static let CHANGE_PASSWORD_URL = "/rest/data/epos/changePassword";// Reset Password URL
public static let UPDATE_PROFILE_URL = "/rest/data/epos/updateProfile";// Reset Password URL
public static let GET_GST_DETAIL = "rest/data/mvs/gst/details";// GST Detail URL
public static let GET_Director_Data_By_GST_DETAIL = "rest/data/mvs/directors/ByGst";// GST Detail URL
public static let GET_MVS_DETAIL = "rest/data/mvs/merchantData/{proof}";// Other proof Detail URL
public static let SEARCH_IFSC = "/rest/data/mvs/ifsc/details";// search ifsc code
public static let DELETE_INDIVIDUAL_URL = "/rest/data/epos/lead/deleteIndividual";// Delete public static letdivisual from Lead
public static let CREATE_LEAD_URL = "/rest/data/epos/lead/create";// create Lead
public static let UPDATE_LEAD_URL = "/rest/data/epos/lead/update";// update Lead
public static let GET_LEAD_ID_URL = "/rest/data/epos/lead/{lead_id}";// get Lead by id
public static let MASTER_DATA_URL = "/rest/data/epos/masterData/getMasterDataV1";// get Lead by id
public static let PACKAGE_DETAILS_URL = "/rest/data/epos/lead/getAllPackages";// get Lead by id
public static let CREATE_TASK_URL = "/rest/data/epos/lead/createTask";// to verify bank with amount public static letedit
public static let UPLOAD_DOC_URL = "/rest/data/epos/lead/uploadDocument";// upload doc
public static let CREATE_ORDER_URL = "/rest/data/epos/payment/createorder";// create order
public static let GET_PG_URL = "/rest/data/epos/payment/initiate";// create order
public static let GET_PG_STATUS_URL = "/rest/data/epos/payment/status";// get payment status
public static let UPDATE_DEVICE_TOKEN_URL = "/rest/data/deviceToken/updateDeviceToken";// update public static letshnotification token
public static let GET_CITY_LIST = "/rest/data/epos/city/getCityListV5";// Get City Details
public static let DELETE_DOC = "/rest/data/epos/lead/document/delete";// Get City Details
public static let GET_DEVICE_INFO = "/rest/data/epos/terminal/deviceInfo";// Get Device Info
public static let CHECK_DEVICE_STATUS = "/rest/data/epos/terminal/checkStatus/{refrenceId}";// Check public static letvice Status
public static let GET_OEM_MASTER_DATA = "/rest/data/masterData/oem";// Oem master data
public static let ADD_UPDATE_OEM_DEALER_MAPPING = "/rest/data/epos/createUpdateOemDealerMapping";// public static letd update oem dealer mapping
public static let GET_OEM_DEALER_MAPPING_LIST = "/rest/data/epos/oemDealerMappingList";// Get oem public static letaler mapping list
public static let GET_STORE_BY_EXTERNAL_ID = "/rest/data/epos/store/search";// Get store by external public static let
public static let UPDATE_SUB_USER = "/rest/data/epos/merchant/updateSubUser";// updated user status
public static let GET_QR_LIST = "/rest/data/epos/lead/getQrList";// get QR list linked to user
public static let GET_QR_STATUS = "/rest/data/epos/lead/getQrStatus ";// get QR status
public static let UPDATE_QR_LINKING = "/rest/data/epos/lead/addRemoveQr";// update QR Linking
public static let DELETE_ALL_DOCS = "/rest/data/epos/lead/v1/document/deleteAllDoc";// delete all docs
public static let GET_LEAD_PROFILE_DETAIL = "/rest/data/epos/lead/getLeadProfileById";// Get lead profile in detail



// MARK:- UWebService HEADER Attr
public static let REQUEST_HEADER_CLIENT_ID_KEY = "X-app-clnt-id";
public static let REQUEST_HEADER_DEVICE_ID_KEY = "X-dev-id";
public static let REQUEST_HEADER_ACCESS_TOKEN_ID_KEY = "X-acs-tkn";
public static let REQUEST_HEADER_BUILD_VERSION_KEY = "X-bld-ver";
public static let REQUEST_HEADER_IMEI_KEY = "X-imei-num";
public static let REQUEST_HEADER_CLIENT_TYPE_KEY = "X-dev-clnt";
public static let REQUEST_HEADER_ADVERTISING_ID_KEY = "X-dev-adv-id";
public static let REQUEST_HEADER_UUID_KEY = "X-app-uuid";
public static let REQUEST_HEADER_CONTENT_TYPE_KEY = "Content-Type";
public static let REQUEST_DEVICE_TYPE = "MOBILE";
public static let REQUEST_DEVICE_OS = "android_";
public static let REQUEST_HEADER_CLIENT_TYPE_VALUE = "APP";
public static let REQUEST_HEADER_CONTENT_TYPE_VALUE = "multipart/form-data";


// MARK:- Perference Keys

public static let KEY_SP_LEAD = "lead_details";
public static let KEY_RAM_SIZE = "key_ram_size";
public static let KEY_SP_APP_THEME = "themeColorModel";
public static let KEY_SP_DOCUMENT = "document_details";
public static let KEY_SP_MOBILE_NUMBER = "mob_number";
public static let KEY_SP_MASTER_DATA = "master_data";
public static let KEY_SP_STATE_DATA = "state_data";
public static let KEY_SP_CONFIG_DATA = "config_data";
public static let KEY_SP_ALARM_CONFIG_DATA = "config_alarms";
public static let KEY_SP_CURRENT_APP_VERSION = "current_app_version";
public static let KEY_SP_UNIQUE_USER_ID = "unique_user_id";
public static let KEY_SP_ACCESS_TOKEN = "access_token";
public static let KEY_SP_USER_PROFILE = "user_profile";
public static let KEY_SP_MOBILE_NUMBER_LIST = "mobile_number_list";
public static let KEY_SP_CONFIG_NUM = "config_cNum";
public static let KEY_SP_STATE_MDATE = "state_mdate";
public static let KEY_SP_LAST_RECORD = "last_record";
public static let KEY_SP_CURRENT_WORKFLOW_STATE = "curr_state";
public static let KEY_SP_FIRM_TYPE = "firm_type";
public static let KEY_SP_BACKGROUND_API_RUNNING_STATE = "backgrnd_api_running_state";
public static let KEY_SP_DEVICE_REFERENCE_ID = "device_reference_id";
public static let KEY_SP_PAYMENT_REFERENCE_ID = "payment_reference_id";
public static let KEY_SP_HARDWARE_SERIAL_NO = "hardware_serial_no";
public static let KEY_SP_POS_ID = "pos_id";
public static let KEY_SP_IMEI = "imei";
public static let KEY_SP_ADVERTISING_ID = "advertising_id";
public static let KEY_SP_APP_UUID = "app_uuid";
public static let KEY_SP_NOTIFICATION_TOKEN = "notification_token";
public static let KEY_SP_NOTIFICATION_TOKEN_UPDATED = "notification_token_updated_to_server";
public static let KEY_SP_APP_LANGUAGE = "app_language";
public static let KEY_SP_APP_WALK_THROUGH = "app_walk_through";
public static let KEY_SP_IS_AUTO_OTP_READ = "is_otp_auto_read";
}
