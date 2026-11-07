package com.riotgames.platform.gameclient.module.login.controller
{
   import com.riotgames.util.json.jsonDecode;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LoginMessageResource
   {
      
      private static const LOGIN_FAIL_CODES:Object = createLoginFailCodes();
      
      private static const BAN_CODES:ArrayCollection = new ArrayCollection(["LOGIN-0003","LOGIN-0004","LOGIN-0005","account_banned","account_banned_for_leaving","account_banned_by_tribunal"]);
      
      private static const ATTEMPT_RETRY_CODE:String = "login_failed_attempt_rate_too_fast";
      
      private static const ACCOUNT_TRANSFERRED_CODE:String = "account_transferred";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function LoginMessageResource()
      {
         super();
      }
      
      private static function createLoginFailCodes() : Object
      {
         var _loc1_:Object = {};
         _loc1_.unknown = "login_failed_unknown";
         _loc1_.invalid_credentials = "login_failed_invalid_credentials";
         _loc1_.server_full = "login_failed_server_full";
         _loc1_.account_inactive = "login_failed_account_inactive";
         _loc1_.account_banned = "LOGIN-0003";
         _loc1_.account_banned_for_leaving = "LOGIN-0004";
         _loc1_.account_banned_by_tribunal = "LOGIN-0005";
         _loc1_.account_transferring_out = "login_failed_transferring_out";
         _loc1_.account_transferring_in = "login_failed_transferring_in";
         _loc1_.account_transferred = "login_failed_transferred";
         _loc1_.account_invalid_credentials = "LOGIN-0006";
         _loc1_.account_bypassed_login_queue = "LOGIN-0007";
         _loc1_.attempt_rate_too_fast = ATTEMPT_RETRY_CODE;
         return _loc1_;
      }
      
      private function isAttemptRetryError(param1:String) : Boolean
      {
         return ATTEMPT_RETRY_CODE == param1;
      }
      
      public function isBannedError(param1:String) : Boolean
      {
         return BAN_CODES.contains(param1);
      }
      
      public function getBanOrPermaBanCodeBasedOnExpirationDate(param1:String, param2:Number) : String
      {
         var _loc3_:Number = new Date().time + 1000 * 60 * 60 * 24 * 365 * 3;
         var _loc4_:Boolean = _loc3_ < param2;
         if(_loc4_)
         {
            return param1 + "-PERMABAN";
         }
         return param1;
      }
      
      public function isAccountTransferred(param1:String) : Boolean
      {
         return ACCOUNT_TRANSFERRED_CODE == param1;
      }
      
      public function getAuthFailedMessage(param1:String) : AuthenticationFailureMessage
      {
         var decoded:Object = null;
         var errorMessage:String = null;
         var failureJson:String = param1;
         var params:AuthenticationFailureMessage = new AuthenticationFailureMessage();
         var reason:String = LoginQueueController.FAIL_UNKNOWN;
         params.expire = 0;
         try
         {
            decoded = jsonDecode(failureJson);
            params.destination = decoded["destination"];
            reason = decoded["reason"];
            params.retryWait = decoded["retryWait"] == null ? 30 : int(parseInt(decoded["retryWait"]));
            params.expire = decoded["banned"] == null ? 0 : parseFloat(decoded["banned"]);
            params.banReason = decoded["banReason"];
         }
         catch(error:Error)
         {
            reason = LoginQueueController.FAIL_UNKNOWN;
            errorMessage = "loginView.displayAuthFailure: " + error.name + " #" + error.errorID + ": " + error.message + "\n" + error.getStackTrace();
            logger.error(errorMessage);
         }
         params.reason = reason;
         if(LOGIN_FAIL_CODES.hasOwnProperty(reason))
         {
            params.localeCode = LOGIN_FAIL_CODES[reason];
         }
         else
         {
            params.localeCode = reason;
         }
         if(this.isBannedError(params.localeCode))
         {
            params.isBannedError = true;
            if(params.banReason != null)
            {
               params.localeCode = params.localeCode + "-" + params.banReason;
            }
            params.localeCode = this.getBanOrPermaBanCodeBasedOnExpirationDate(params.localeCode,params.expire);
         }
         else if(this.isAttemptRetryError(params.localeCode))
         {
            params.isRetryWait = true;
         }
         else if(this.isAccountTransferred(params.localeCode) && Boolean(params.destination))
         {
            params.isAccountTransferred = true;
         }
         return params;
      }
   }
}

