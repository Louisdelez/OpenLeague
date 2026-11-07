package com.riotgames.platform.gameclient.events
{
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import flash.events.Event;
   
   public class AntiIndulgenceEvent extends Event
   {
      
      public static const ANTI_INDULGENCE:String = "antiIndulgence";
      
      public static const AAS_NOTIFICATION:String = XMPPMessageSubjectTypes.AAS_NOTIFICATION;
      
      public var message:AntiIndulgenceMessage;
      
      public function AntiIndulgenceEvent(param1:String, param2:AntiIndulgenceMessage, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.message = param2;
      }
   }
}

