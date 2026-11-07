package com.riotgames.platform.common.event
{
   import flash.events.Event;
   
   public class GameCrashedEvent extends Event
   {
      
      public static const CRASHED_EVENT_FROM_GAME:String = "gameClientCrashed";
      
      public var gamePath:String;
      
      public function GameCrashedEvent(param1:String)
      {
         this.gamePath = param1;
         super(CRASHED_EVENT_FROM_GAME,false,false);
      }
   }
}

