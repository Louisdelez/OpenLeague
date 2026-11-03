package com.riotgames.pvpnet.game.event
{
   import flash.events.Event;
   
   public class UnexpectedGameErrorEvent extends Event
   {
      
      public static const GAME_FAILED_TO_START:String = "gameFailedToStart";
      
      public static const GAME_TERMINATED_IN_ERROR:String = "gameTerminatedInError";
      
      public function UnexpectedGameErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

