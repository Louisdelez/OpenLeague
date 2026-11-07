package com.riotgames.pvpnet.system.maestro
{
   import flash.utils.setTimeout;
   
   public class IronDemoMaestroController extends MaestroController
   {
      
      private var _ipAddress:String;
      
      private var _port:String;
      
      private var _securityKey:String;
      
      private var _playerId:String;
      
      public function IronDemoMaestroController()
      {
         super();
      }
      
      override public function createGame(param1:String, param2:String, param3:String, param4:String) : void
      {
         this._ipAddress = param1;
         this._port = param2;
         this._securityKey = param3;
         this._playerId = param4;
         setTimeout(super.createGame,10000,this._ipAddress,this._port,this._securityKey,this._playerId);
      }
   }
}

