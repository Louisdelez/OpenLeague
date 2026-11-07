package com.riotgames.landing.takeover
{
   import flash.events.Event;
   
   public class TakeoverEvent extends Event
   {
      
      public static const TAKEOVER_CLOSED:String = "TAKEOVER_CLOSED";
      
      public function TakeoverEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TakeoverEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TakeoverEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

