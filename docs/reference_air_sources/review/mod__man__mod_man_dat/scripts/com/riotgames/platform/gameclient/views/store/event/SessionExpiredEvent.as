package com.riotgames.platform.gameclient.views.store.event
{
   import flash.events.Event;
   
   public class SessionExpiredEvent extends Event
   {
      
      public static const SESSION_EXPIRED:String = "sessionExpired";
      
      public var queryString:String;
      
      public var path:String;
      
      public function SessionExpiredEvent(param1:String, param2:String, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.path = param2;
         this.queryString = param3;
      }
      
      override public function clone() : Event
      {
         return new SessionExpiredEvent(type,this.path,this.queryString,bubbles,cancelable);
      }
   }
}

