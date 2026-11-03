package com.riotgames.platform.gameclient.services.maestro
{
   import flash.events.Event;
   
   public class MaestroUpdatePlayerConnectionEvent extends Event
   {
      
      public var _payload:String;
      
      public function MaestroUpdatePlayerConnectionEvent(param1:String, param2:String)
      {
         this._payload = param2;
         super(param1);
      }
   }
}

