package com.riotgames.platform.gameclient.module.services.lcds
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.domain.AuthenticationCredentials;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.exception.ClientVersionMismatchException;
   import com.riotgames.platform.common.exception.LoginFailedException;
   import com.riotgames.platform.common.services.LoginService;
   import com.riotgames.platform.common.utils.ClientErrorCodes;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   
   public class LoginServiceImpl extends BaseLcdsService implements LoginService
   {
      
      private var _LCDSconnectionStatusChanged:Signal;
      
      public function LoginServiceImpl()
      {
         super();
      }
      
      public function get isConnectedToLCDS() : Boolean
      {
         return this.remoteObjectGenerator.defaultChannelSet.connected;
      }
      
      private function onLCDSChannelEvent(param1:Event) : void
      {
         this._LCDSconnectionStatusChanged.dispatch(this.isConnectedToLCDS);
      }
      
      public function get LCDSconnectionStatusChanged() : ISignal
      {
         if(this._LCDSconnectionStatusChanged == null)
         {
            this._LCDSconnectionStatusChanged = new Signal();
            this.remoteObjectGenerator.addChannelSetListener(ChannelEvent.CONNECT,this.onLCDSChannelEvent);
            this.remoteObjectGenerator.addChannelSetListener(ChannelEvent.DISCONNECT,this.onLCDSChannelEvent);
            this.remoteObjectGenerator.addChannelSetListener(ChannelFaultEvent.FAULT,this.onLCDSChannelEvent);
         }
         return this._LCDSconnectionStatusChanged;
      }
      
      public function validatePlatformConnection(param1:Function, param2:Function, param3:Function, param4:Object) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[ServerError.UNEXPECTED_SERVICE_EXCEPTION] = param3;
         _loc5_[ClientErrorCodes.REQUEST_TIMEOUT] = param3;
         _loc5_[ClientErrorCodes.MESSAGE_SEND] = param3;
         invokeServiceWithoutSession("loginService","performLCDSHeartBeat",[0,"validate-lcds-connection-4-invite",0,""],param1,param2,_loc5_,param4);
      }
      
      public function login(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Function, param10:Function, param11:Function) : void
      {
         var _loc12_:AuthenticationCredentials = new AuthenticationCredentials();
         _loc12_.domain = param4;
         _loc12_.username = param1;
         _loc12_.authToken = param3;
         _loc12_.password = param2;
         _loc12_.macAddress = param5;
         _loc12_.clientVersion = param7;
         _loc12_.locale = param6;
         _loc12_.operatingSystem = param8;
         var _loc13_:Dictionary = new Dictionary();
         _loc13_[ClientVersionMismatchException] = param11;
         _loc13_[LoginFailedException] = param11;
         invokeServiceWithoutSession("loginService","login",[_loc12_],param9,param10,_loc13_);
      }
      
      public function getStoreUrl(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("loginService","getStoreUrl",[],param1,param2);
      }
      
      public function logout(param1:String, param2:Function, param3:Function) : void
      {
         invokeServiceWithSession("loginService","logout",[],param2,param3);
      }
      
      public function performLCDSHeartBeat(param1:Number, param2:String, param3:int, param4:String, param5:Function, param6:Function, param7:Function) : void
      {
         var _loc8_:Dictionary = new Dictionary();
         _loc8_[ServerError.UNEXPECTED_SERVICE_EXCEPTION] = param7;
         _loc8_[ClientErrorCodes.REQUEST_TIMEOUT] = param7;
         _loc8_[ClientErrorCodes.MESSAGE_SEND] = param7;
         _loc8_[ClientErrorCodes.CONNECT_FAILED] = param7;
         invokeServiceWithoutSession("loginService","performLCDSHeartBeat",[param1,param2,param3,param4],param5,param6,_loc8_,param3);
      }
      
      public function loginWithSuppliedCredentials(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Function, param10:Function, param11:Function) : void
      {
         var _loc12_:AuthenticationCredentials = new AuthenticationCredentials();
         _loc12_.username = param1;
         _loc12_.authToken = param3;
         _loc12_.domain = param4;
         _loc12_.partnerCredentials = param2;
         _loc12_.macAddress = param5;
         _loc12_.clientVersion = param7;
         _loc12_.locale = param6;
         _loc12_.operatingSystem = param8;
         var _loc13_:Dictionary = new Dictionary();
         _loc13_[ClientVersionMismatchException] = param11;
         _loc13_[LoginFailedException] = param11;
         invokeServiceWithoutSession("loginService","login",[_loc12_],param9,param10,_loc13_);
      }
      
      public function isLoggedIn(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("loginService","isLoggedIn",[param1],param2,param3);
      }
      
      public function getLoggedInAccountView(param1:Function, param2:Function) : void
      {
         invokeServiceWithSession("loginService","getLoggedInAccountView",[],param1,param2);
      }
   }
}

