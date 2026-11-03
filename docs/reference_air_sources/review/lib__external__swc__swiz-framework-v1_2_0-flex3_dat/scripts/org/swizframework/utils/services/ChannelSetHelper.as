package org.swizframework.utils.services
{
   import mx.messaging.Channel;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.AMFChannel;
   import mx.messaging.channels.SecureAMFChannel;
   import org.swizframework.core.IInitializing;
   
   public class ChannelSetHelper extends ChannelSet implements IInitializing
   {
      
      private static const DEFAULT_CHANNEL_ID:String = "orca-amf";
      
      private static const DEFAULT_PROTOCOL:String = "http";
      
      private static const DEFAULT_SERVER_NAME:String = "localhost";
      
      private static const DEFAULT_SERVER_PORT:int = 8080;
      
      private static const DEFAULT_CONTEXT_ROOT:String = "/";
      
      private static const DEFAULT_ENDPOINT_NAME:String = "messagebroker/amf";
      
      public var channelId:String;
      
      public var protocol:String;
      
      public var serverName:String;
      
      public var serverPort:int;
      
      public var contextRoot:String;
      
      public var endPointName:String;
      
      public var parameterSource:Object;
      
      public var parameterName:String;
      
      private var url:String;
      
      private var channelCreated:Boolean = false;
      
      public function ChannelSetHelper(channelIds:Array = null, clusteredWithURLLoadBalancing:Boolean = false)
      {
         super(channelIds,clusteredWithURLLoadBalancing);
      }
      
      public function afterPropertiesSet() : void
      {
         if(!this.channelCreated)
         {
            this.checkParameters();
            this.createChannel();
         }
      }
      
      private function checkParameters() : void
      {
         if(this.parameterSource != null && this.parameterName != null)
         {
            this.url = this.parameterSource.parameters[this.parameterName];
         }
      }
      
      private function createChannel() : void
      {
         var amfChannel:Channel = null;
         if(!this.channelCreated)
         {
            if(this.PROTOCOL == "https" || this.AMF_ENDPOINT.indexOf("https") > -1)
            {
               amfChannel = new SecureAMFChannel(this.CHANNEL_ID,this.AMF_ENDPOINT);
            }
            else
            {
               amfChannel = new AMFChannel(this.CHANNEL_ID,this.AMF_ENDPOINT);
            }
            addChannel(amfChannel);
            this.channelCreated = true;
         }
      }
      
      private function get AMF_ENDPOINT() : String
      {
         if(this.url != null && Boolean(this.url.length))
         {
            return this.url;
         }
         return this.PROTOCOL + "://" + this.SERVER_NAME + ":" + this.SERVER_PORT + this.CONTEXT_ROOT + "/" + this.ENDPOINT_NAME;
      }
      
      private function get CHANNEL_ID() : String
      {
         return this.channelId != null ? this.channelId : DEFAULT_CHANNEL_ID;
      }
      
      private function get PROTOCOL() : String
      {
         return this.protocol != null ? this.protocol : DEFAULT_PROTOCOL;
      }
      
      private function get SERVER_NAME() : String
      {
         return this.serverName != null ? this.serverName : DEFAULT_SERVER_NAME;
      }
      
      private function get SERVER_PORT() : int
      {
         return this.serverPort != 0 ? this.serverPort : DEFAULT_SERVER_PORT;
      }
      
      private function get CONTEXT_ROOT() : String
      {
         return this.contextRoot != null ? this.contextRoot : DEFAULT_CONTEXT_ROOT;
      }
      
      private function get ENDPOINT_NAME() : String
      {
         return this.endPointName != null ? this.endPointName : DEFAULT_ENDPOINT_NAME;
      }
   }
}

