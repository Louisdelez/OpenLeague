package mx.utils
{
   import flash.net.registerClassAlias;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.AcknowledgeMessageExt;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.AsyncMessageExt;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.CommandMessageExt;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.MessagePerformanceInfo;
   import mx.messaging.messages.RemotingMessage;
   import mx.messaging.messages.SOAPMessage;
   
   public class RpcClassAliasInitializer
   {
      
      public function RpcClassAliasInitializer()
      {
         super();
      }
      
      public static function registerClassAliases() : void
      {
         registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
         registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
         registerClassAlias("flex.messaging.messages.AcknowledgeMessage",AcknowledgeMessage);
         registerClassAlias("DSK",AcknowledgeMessageExt);
         registerClassAlias("flex.messaging.messages.AsyncMessage",AsyncMessage);
         registerClassAlias("DSA",AsyncMessageExt);
         registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
         registerClassAlias("DSC",CommandMessageExt);
         registerClassAlias("flex.messaging.config.ConfigMap",ConfigMap);
         registerClassAlias("flex.messaging.messages.ErrorMessage",ErrorMessage);
         registerClassAlias("flex.messaging.messages.HTTPMessage",HTTPRequestMessage);
         registerClassAlias("flex.messaging.messages.MessagePerformanceInfo",MessagePerformanceInfo);
         registerClassAlias("flex.messaging.messages.RemotingMessage",RemotingMessage);
         registerClassAlias("flex.messaging.messages.SOAPMessage",SOAPMessage);
      }
   }
}

