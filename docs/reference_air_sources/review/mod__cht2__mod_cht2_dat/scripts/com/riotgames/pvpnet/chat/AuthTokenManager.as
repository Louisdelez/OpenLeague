package com.riotgames.pvpnet.chat
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class AuthTokenManager
   {
      
      public static var instance:AuthTokenManager = new AuthTokenManager();
      
      private var _session:Session;
      
      private var _authToken:String;
      
      private var _authError:Error;
      
      private var _expireTime:Date = new Date();
      
      private var _authUrlConfig:ConfigurationModel;
      
      private var _authPlatform:ConfigurationModel;
      
      private var _authBasicAuthentication:ConfigurationModel;
      
      private var _authTokenErrorCacheTimeout:ConfigurationModel;
      
      private var _notifySignal:Signal = new Signal();
      
      private var _loadInProgress:Boolean = false;
      
      private var _accountId:Number;
      
      private var _platformId:String;
      
      public function AuthTokenManager()
      {
         super();
         this._session = Session.instance;
         this._authUrlConfig = DynamicClientConfigManager.getConfiguration("AuthTokenManager","AuthUrl","https://auth.i.riotgames.com/ras/oauth/token");
         this._authPlatform = DynamicClientConfigManager.getConfiguration("AuthTokenManager","AuthPlatform","");
         this._authBasicAuthentication = DynamicClientConfigManager.getConfiguration("AuthTokenManager","AuthBasicAuthentication","cmlvdC1wbGF5ZXItaWRlbnRpdHk6NWUxYzFmYTAtNjUwMy0yY2MwLTZmMTEtOTA2N2NkZWMxMDk4");
         this._authTokenErrorCacheTimeout = DynamicClientConfigManager.getConfiguration("AuthTokenManager","AuthErrorCacheTimeoutMillis",5 * 60 * 1000);
      }
      
      public function reloadAuthToken() : void
      {
         var _loc5_:String = null;
         var _loc6_:URLVariables = null;
         var _loc7_:URLRequest = null;
         var _loc8_:URLLoader = null;
         if(this._loadInProgress)
         {
            return;
         }
         var _loc1_:String = this._authUrlConfig.getString();
         var _loc2_:String = this._session.accountSummary.username;
         var _loc3_:String = this._session.password;
         var _loc4_:String = this._authBasicAuthentication.getString();
         this._accountId = this._session.accountSummary.accountId;
         this._platformId = this._authPlatform.getString();
         if(_loc1_ != "" && this._platformId != "")
         {
            _loc5_ = "riot.account.read.all";
            _loc6_ = new URLVariables();
            _loc6_.grant_type = "password";
            _loc6_.username = this._platformId + "_" + _loc2_;
            _loc6_.password = _loc3_;
            _loc6_.scope = _loc5_;
            _loc7_ = new URLRequest(_loc1_);
            _loc7_.method = URLRequestMethod.POST;
            _loc7_.data = _loc6_;
            _loc7_.requestHeaders.push(new URLRequestHeader("Authorization","Basic " + _loc4_));
            _loc8_ = new URLLoader();
            _loc8_.addEventListener(Event.COMPLETE,this.httpRequestComplete);
            _loc8_.addEventListener(IOErrorEvent.IO_ERROR,this.httpRequestError);
            _loc8_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.httpRequestError);
            _loc8_.load(_loc7_);
            this._loadInProgress = true;
         }
         else
         {
            this.setAuthError(new Error("Authentication has not been configured"));
         }
      }
      
      private function httpRequestComplete(param1:Event) : void
      {
         var _loc2_:Object = JSON.parse(param1.target.data);
         this._authToken = _loc2_.access_token;
         this._authError = null;
         this._loadInProgress = false;
         this._expireTime.setTime(new Date().getTime() + _loc2_.expires_in * 1000);
         this._notifySignal.dispatch(this._authError,this._authToken);
      }
      
      private function setAuthError(param1:Error) : void
      {
         this._authToken = null;
         this._authError = param1;
         this._loadInProgress = false;
         this._expireTime.setTime(new Date().getTime() + this._authTokenErrorCacheTimeout.getInt());
         this._notifySignal.dispatch(this._authError,this._authToken);
      }
      
      private function httpRequestError(param1:ErrorEvent) : void
      {
         this.setAuthError(new Error("Error " + param1.toString() + " data:" + param1.target.data));
      }
      
      public function callWithAuthToken(param1:Function, param2:Object = null) : void
      {
         var cb:Function = param1;
         var that:Object = param2;
         if(new Date().getTime() < this._expireTime.getTime())
         {
            cb.call(that,this._authError,this._authToken);
         }
         else
         {
            this._notifySignal.addOnce(function(param1:Error, param2:String):void
            {
               cb.call(that,param1,param2);
            });
            this.reloadAuthToken();
         }
      }
      
      public function getAccountId() : Number
      {
         return this._accountId;
      }
      
      public function getPlatformId() : String
      {
         return this._platformId;
      }
   }
}

