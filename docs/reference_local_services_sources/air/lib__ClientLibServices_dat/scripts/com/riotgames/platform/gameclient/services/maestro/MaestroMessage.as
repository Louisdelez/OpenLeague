package com.riotgames.platform.gameclient.services.maestro
{
   import flash.utils.ByteArray;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MaestroMessage
   {
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.services.maestro.MaestroMessage");
      
      public static const MESSAGE_HEADERSIZE:int = 16;
      
      public static const MESSAGE_VERSION:int = 1;
      
      private var payloadSize:int = 0;
      
      private var type:int = 0;
      
      private var payloadBytes:ByteArray;
      
      private var payloadString:String;
      
      public function MaestroMessage(param1:String = null)
      {
         super();
         this.payloadString = param1;
      }
      
      public function getVersion() : int
      {
         return MESSAGE_VERSION;
      }
      
      public function getPayloadString() : String
      {
         return this.payloadString;
      }
      
      public function getPayloadBytes() : ByteArray
      {
         return this.payloadBytes;
      }
      
      public function setPayload(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = String.fromCharCode(0);
            while(param1.indexOf(_loc2_) != -1)
            {
               param1 = param1.replace(_loc2_,"?");
            }
            this.payloadBytes = new ByteArray();
            this.payloadBytes.writeUTFBytes(param1);
            this.setPayloadSize(this.payloadBytes.length);
            this.payloadBytes.position = 0;
         }
         else
         {
            this.setPayloadSize(0);
         }
         this.payloadString = param1;
      }
      
      public function setPayloadSize(param1:int) : void
      {
         this.payloadSize = param1;
      }
      
      public function getType() : int
      {
         return this.type;
      }
      
      public function getSize() : int
      {
         return MESSAGE_HEADERSIZE;
      }
      
      public function getPayloadSize() : int
      {
         return this.payloadSize;
      }
      
      public function setType(param1:int) : void
      {
         this.type = param1;
      }
   }
}

