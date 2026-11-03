package mx.messaging.channels
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import mx.logging.Log;
   import mx.messaging.FlexClient;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.config.ServerConfig;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("messaging")]
   public class StreamingAMFChannel extends AMFChannel
   {
      
      private var streamingConnectionHandler:StreamingConnectionHandler;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function StreamingAMFChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
         internalPollingEnabled = false;
      }
      
      override public function set pollingEnabled(value:Boolean) : void
      {
         var message:String = this.resourceManager.getString("messaging","pollingNotSupportedAMF");
         throw new Error(message);
      }
      
      override public function set pollingInterval(value:Number) : void
      {
         var message:String = this.resourceManager.getString("messaging","pollingNotSupportedAMF");
         throw new Error(message);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get realtime() : Boolean
      {
         return true;
      }
      
      override public function poll() : void
      {
         var message:String = this.resourceManager.getString("messaging","pollingNotSupportedAMF");
         throw new Error(message);
      }
      
      override protected function connectFailed(event:ChannelFaultEvent) : void
      {
         if(this.streamingConnectionHandler != null)
         {
            this.streamingConnectionHandler.closeStreamingConnection();
         }
         super.connectFailed(event);
      }
      
      override protected function internalDisconnect(rejected:Boolean = false) : void
      {
         if(this.streamingConnectionHandler != null)
         {
            this.streamingConnectionHandler.closeStreamingConnection();
         }
         super.internalDisconnect(rejected);
      }
      
      override protected function resultHandler(msg:IMessage) : void
      {
         if(msg != null)
         {
            ServerConfig.updateServerConfigData(msg.body as ConfigMap,endpoint);
            if(FlexClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
            {
               FlexClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
            }
         }
         handleReconnectWithSessionId();
         if(credentials != null && !(msg is ErrorMessage))
         {
            setAuthenticated(true);
         }
         if(this.streamingConnectionHandler == null)
         {
            this.streamingConnectionHandler = new StreamingAMFConnectionHandler(this,_log);
            this.streamingConnectionHandler.addEventListener(Event.OPEN,this.streamOpenHandler);
            this.streamingConnectionHandler.addEventListener(Event.COMPLETE,this.streamCompleteHandler);
            this.streamingConnectionHandler.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.streamHttpStatusHandler);
            this.streamingConnectionHandler.addEventListener(IOErrorEvent.IO_ERROR,this.streamIoErrorHandler);
            this.streamingConnectionHandler.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.streamSecurityErrorHandler);
            this.streamingConnectionHandler.addEventListener(StatusEvent.STATUS,this.streamStatusHandler);
         }
         this.streamingConnectionHandler.openStreamingConnection(_appendToURL);
      }
      
      private function streamOpenHandler(event:Event) : void
      {
         connectSuccess();
      }
      
      private function streamCompleteHandler(event:Event) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         if(connected)
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error","Remote endpoint has closed the streaming connection.");
            faultEvent.rootCause = event;
            dispatchEvent(faultEvent);
            this.internalDisconnect();
         }
      }
      
      private function streamHttpStatusHandler(event:HTTPStatusEvent) : void
      {
      }
      
      private function streamIoErrorHandler(event:IOErrorEvent) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         if(connected)
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error"," url: \'" + endpoint + "\'");
            faultEvent.rootCause = event;
            dispatchEvent(faultEvent);
            this.internalDisconnect();
         }
         else
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error"," url: \'" + endpoint + "\'");
            faultEvent.rootCause = event;
            this.connectFailed(faultEvent);
         }
      }
      
      private function streamSecurityErrorHandler(event:SecurityErrorEvent) : void
      {
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel encountered a security error: {1}",id,event.text);
         }
      }
      
      private function streamStatusHandler(event:StatusEvent) : void
      {
         if(event.code == StreamingConnectionHandler.DISCONNECT_CODE)
         {
            this.streamingConnectionHandler.closeStreamingConnection();
            disconnectSuccess(true);
            credentials = null;
         }
      }
   }
}

import flash.net.ObjectEncoding;
import flash.utils.ByteArray;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.Channel;
import mx.messaging.channels.StreamingConnectionHandler;
import mx.messaging.messages.IMessage;

class StreamingAMFConnectionHandler extends StreamingConnectionHandler
{
   
   public function StreamingAMFConnectionHandler(channel:Channel, log:ILogger)
   {
      super(channel,log);
   }
   
   override protected function readMessage() : IMessage
   {
      var messageBytes:ByteArray;
      var message:IMessage = null;
      chunkBuffer.position = dataOffset - 1;
      messageBytes = new ByteArray();
      messageBytes.objectEncoding = ObjectEncoding.AMF3;
      try
      {
         chunkBuffer.readBytes(messageBytes,0,dataBytesToRead);
         message = IMessage(messageBytes.readObject());
      }
      catch(error:Error)
      {
         if(Log.isError())
         {
            _log.error("\'{0}\' channel encountered an error while reading a message from the streaming connection: {1}",channel.id,error.message);
         }
      }
      return message;
   }
}
