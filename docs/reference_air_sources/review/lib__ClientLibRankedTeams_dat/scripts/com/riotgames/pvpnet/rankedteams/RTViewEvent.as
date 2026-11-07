package com.riotgames.pvpnet.rankedteams
{
   import flash.events.Event;
   
   public class RTViewEvent extends Event
   {
      
      public static const REFRESH_VIEW:String = "REFRESH_VIEW";
      
      public function RTViewEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

