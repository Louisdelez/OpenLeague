package com.riotgames.platform.common.event
{
   import flash.events.Event;
   
   public class RosterProviderEvent extends Event
   {
      
      public static const ROSTER_CHANGED:String = "rosterChanged";
      
      public function RosterProviderEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

