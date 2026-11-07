package com.riotgames.platform.common.services
{
   import blix.signals.ISignal;
   
   public interface LoginService
   {
      
      function get isConnectedToLCDS() : Boolean;
      
      function isLoggedIn(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function getStoreUrl(param1:Function, param2:Function) : void;
      
      function performLCDSHeartBeat(param1:Number, param2:String, param3:int, param4:String, param5:Function, param6:Function, param7:Function) : void;
      
      function login(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Function, param10:Function, param11:Function) : void;
      
      function logout(param1:String, param2:Function, param3:Function) : void;
      
      function getLoggedInAccountView(param1:Function, param2:Function) : void;
      
      function get LCDSconnectionStatusChanged() : ISignal;
      
      function loginWithSuppliedCredentials(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Function, param10:Function, param11:Function) : void;
   }
}

