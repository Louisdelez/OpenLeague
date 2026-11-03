package com.riotgames.platform.common.event
{
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import flash.events.Event;
   
   public class ServerStatusEvent extends Event
   {
      
      public static const STATUS_RECEIVED:String = "ServerStatusEvent.STATUS_RECEIVED";
      
      public static const STATUS_FAILED:String = "ServerStatusEvent.STATUS_FAILED";
      
      public var messages:Vector.<BroadcastMessage>;
      
      public function ServerStatusEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:ServerStatusEvent = new ServerStatusEvent(type,bubbles,cancelable);
         _loc1_.messages = this.messages;
         return _loc1_;
      }
   }
}

