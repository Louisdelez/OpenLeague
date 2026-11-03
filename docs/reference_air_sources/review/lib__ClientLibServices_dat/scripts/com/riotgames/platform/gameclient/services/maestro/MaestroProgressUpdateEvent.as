package com.riotgames.platform.gameclient.services.maestro
{
   import flash.events.Event;
   
   public class MaestroProgressUpdateEvent extends Event
   {
      
      public var progress:String;
      
      public function MaestroProgressUpdateEvent(param1:String, param2:String)
      {
         this.progress = param2;
         super(param1);
      }
   }
}

