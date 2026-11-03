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
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("messaging")]
   public class StreamingHTTPChannel extends HTTPChannel
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var streamingConnectionHandler:StreamingConnectionHandler;
      
      public function StreamingHTTPChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
         internalPollingEnabled = false;
      }
      
      private function streamOpenHandler(event:Event) : void
      {
         connectSuccess();
      }
      
      private function streamSecurityErrorHandler(event:SecurityErrorEvent) : void
      {
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel encountered a security error: {1}",id,event.text);
         }
      }
      
      override protected function connectFailed(event:ChannelFaultEvent) : void
      {
         if(streamingConnectionHandler != null)
         {
            streamingConnectionHandler.closeStreamingConnection();
         }
         super.connectFailed(event);
      }
      
      override protected function internalPingComplete(msg:AsyncMessage) : void
      {
         if(msg != null)
         {
            ServerConfig.updateServerConfigData(msg.body as ConfigMap,endpoint);
            if(FlexClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
            {
               FlexClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
            }
         }
         if(credentials != null && !(msg is ErrorMessage))
         {
            setAuthenticated(true);
         }
         if(streamingConnectionHandler == null)
         {
            streamingConnectionHandler = new StreamingHTTPConnectionHandler(this,_log);
            streamingConnectionHandler.addEventListener(Event.OPEN,streamOpenHandler);
            streamingConnectionHandler.addEventListener(Event.COMPLETE,streamCompleteHandler);
            streamingConnectionHandler.addEventListener(HTTPStatusEvent.HTTP_STATUS,streamHttpStatusHandler);
            streamingConnectionHandler.addEventListener(IOErrorEvent.IO_ERROR,streamIoErrorHandler);
            streamingConnectionHandler.addEventListener(SecurityErrorEvent.SECURITY_ERROR,streamSecurityErrorHandler);
            streamingConnectionHandler.addEventListener(StatusEvent.STATUS,streamStatusHandler);
         }
         streamingConnectionHandler.openStreamingConnection(appendToURL);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get realtime() : Boolean
      {
         return true;
      }
      
      private function streamIoErrorHandler(event:IOErrorEvent) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         if(connected)
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error"," url: \'" + endpoint + "\'");
            faultEvent.rootCause = event;
            dispatchEvent(faultEvent);
            internalDisconnect();
         }
         else
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error"," url: \'" + endpoint + "\'");
            faultEvent.rootCause = event;
            connectFailed(faultEvent);
         }
      }
      
      override public function set pollingInterval(value:Number) : void
      {
         var message:String = resourceManager.getString("messaging","pollingNotSupportedHTTP");
         throw new Error(message);
      }
      
      private function streamCompleteHandler(event:Event) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         if(connected)
         {
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Stream.Failed","error","Remote endpoint has closed the streaming connection.");
            faultEvent.rootCause = event;
            dispatchEvent(faultEvent);
            internalDisconnect();
         }
      }
      
      private function streamHttpStatusHandler(event:HTTPStatusEvent) : void
      {
      }
      
      private function streamStatusHandler(event:StatusEvent) : void
      {
         if(event.code == StreamingConnectionHandler.DISCONNECT_CODE)
         {
            streamingConnectionHandler.closeStreamingConnection();
            disconnectSuccess(true);
         }
      }
      
      override protected function internalDisconnect(rejected:Boolean = false) : void
      {
         if(streamingConnectionHandler != null)
         {
            streamingConnectionHandler.closeStreamingConnection();
         }
         super.internalDisconnect(rejected);
      }
      
      override public function set pollingEnabled(value:Boolean) : void
      {
         var message:String = resourceManager.getString("messaging","pollingNotSupportedHTTP");
         throw new Error(message);
      }
      
      override public function poll() : void
      {
         var message:String = resourceManager.getString("messaging","pollingNotSupportedHTTP");
         throw new Error(message);
      }
   }
}

import flash.net.ObjectEncoding;
import flash.utils.ByteArray;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.Channel;
import mx.messaging.channels.StreamingConnectionHandler;
import mx.messaging.channels.amfx.AMFXContext;
import mx.messaging.channels.amfx.AMFXDecoder;
import mx.messaging.messages.IMessage;

class StreamingHTTPConnectionHandler extends StreamingConnectionHandler
{
   
   public function StreamingHTTPConnectionHandler(channel:Channel, log:ILogger)
   {
      super(channel,log);
   }
   
   override protected function readMessage() : IMessage
   {
      var messageBytes:ByteArray;
      var message:IMessage = null;
      var messageString:String = null;
      var messageObject:Object = null;
      chunkBuffer.position = dataOffset - 1;
      messageBytes = new ByteArray();
      messageBytes.objectEncoding = ObjectEncoding.AMF3;
      try
      {
         chunkBuffer.readBytes(messageBytes,0,dataBytesToRead);
         messageString = messageBytes.readUTFBytes(dataBytesToRead);
         messageObject = AMFXDecoder.decodeValue(XML(messageString),new AMFXContext());
         message = IMessage(messageObject);
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
