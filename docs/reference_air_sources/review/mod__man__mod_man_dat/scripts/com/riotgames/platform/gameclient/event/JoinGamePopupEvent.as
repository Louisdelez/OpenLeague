package com.riotgames.platform.gameclient.event
{
   import flash.events.Event;
   
   public class JoinGamePopupEvent extends Event
   {
      
      public static const OK_BUTTON_CLICK:String = "okButtonClick";
      
      public static const CANCEL_BUTTON_CLICK:String = "cancelButtonClick";
      
      public var params:*;
      
      public function JoinGamePopupEvent(param1:*, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param2,param3,param4);
         this.params = param1;
      }
   }
}

