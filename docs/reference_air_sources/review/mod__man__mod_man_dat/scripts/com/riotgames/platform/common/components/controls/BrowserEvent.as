package com.riotgames.platform.common.components.controls
{
   import flash.events.Event;
   
   public class BrowserEvent extends Event
   {
      
      public static const CLOSE_REQUESTED:String = "closeRequested";
      
      public function BrowserEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

