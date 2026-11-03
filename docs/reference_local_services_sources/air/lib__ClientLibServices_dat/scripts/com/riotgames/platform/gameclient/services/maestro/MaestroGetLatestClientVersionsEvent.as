package com.riotgames.platform.gameclient.services.maestro
{
   import flash.events.Event;
   
   public class MaestroGetLatestClientVersionsEvent extends Event
   {
      
      public var versionsJson:String;
      
      public function MaestroGetLatestClientVersionsEvent(param1:String, param2:String)
      {
         this.versionsJson = param2;
         super(param1);
      }
   }
}

