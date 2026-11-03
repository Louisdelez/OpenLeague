package org.swizframework.utils.services
{
   import flash.net.ObjectEncoding;
   import mx.core.ByteArrayAsset;
   import mx.messaging.messages.AcknowledgeMessage;
   
   public class AMFUtil
   {
      
      public function AMFUtil()
      {
         super();
      }
      
      public static function getAMF3Data(clazz:Class) : Object
      {
         var mockData:ByteArrayAsset = ByteArrayAsset(new clazz());
         mockData.objectEncoding = ObjectEncoding.AMF3;
         while(mockData.readByte() != 10)
         {
         }
         --mockData.position;
         return AcknowledgeMessage(mockData.readObject()).body;
      }
   }
}

