package com.riotgames.platform.gameclient.domain.celebration
{
   [RemoteClass(alias="com.riotgames.platform.messaging.persistence.SimpleDialogMessageResponse")]
   public class SimpleDialogMessageResponse
   {
      
      public static const ACKNOWLEDGE_COMMAND:String = "ack";
      
      public var accountId:Number;
      
      public var command:String;
      
      public var msgId:String;
      
      public function SimpleDialogMessageResponse()
      {
         super();
      }
   }
}

