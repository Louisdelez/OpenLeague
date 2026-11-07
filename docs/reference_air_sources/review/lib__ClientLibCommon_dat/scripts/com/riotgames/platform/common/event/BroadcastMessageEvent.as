package com.riotgames.platform.common.event
{
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import flash.events.Event;
   
   public class BroadcastMessageEvent extends Event
   {
      
      public var notification:IClientNotification;
      
      public function BroadcastMessageEvent(param1:String, param2:IClientNotification, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.notification = param2;
      }
   }
}

