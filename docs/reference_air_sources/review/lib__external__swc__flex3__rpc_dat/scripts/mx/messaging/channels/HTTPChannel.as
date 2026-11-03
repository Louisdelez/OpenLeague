package mx.messaging.channels
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import mx.messaging.FlexClient;
   import mx.messaging.MessageAgent;
   import mx.messaging.MessageResponder;
   import mx.messaging.channels.amfx.AMFXDecoder;
   import mx.messaging.channels.amfx.AMFXEncoder;
   import mx.messaging.channels.amfx.AMFXHeader;
   import mx.messaging.channels.amfx.AMFXResult;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.config.LoaderConfig;
   import mx.messaging.config.ServerConfig;
   import mx.messaging.errors.MessageSerializationError;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.IMessage;
   import mx.messaging.messages.MessagePerformanceInfo;
   import mx.messaging.messages.MessagePerformanceUtils;
   import mx.netmon.NetworkMonitor;
   
   public class HTTPChannel extends PollingChannel
   {
      
      private static const APPEND_TO_URL_HEADER:String = "AppendToGatewayUrl";
      
      private var _appendToURL:String;
      
      private var _pendingRequest:ChannelRequestLoader = null;
      
      private var _encoder:AMFXEncoder;
      
      private var _connectLoader:ChannelRequestLoader;
      
      private var _messageQueue:Array;
      
      public function HTTPChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
         _encoder = new AMFXEncoder();
         _appendToURL = "";
         _messageQueue = [];
      }
      
      private function AppendToGatewayUrl(value:String) : void
      {
         if(value != null)
         {
            appendToURL = value;
         }
      }
      
      public function get polling() : Boolean
      {
         return pollOutstanding;
      }
      
      private function processHeaders(packet:AMFXResult) : void
      {
         var i:uint = 0;
         var header:AMFXHeader = null;
         if(packet.headers != null)
         {
            try
            {
               for(i = 0; i < packet.headers.length; i++)
               {
                  header = packet.headers[i];
                  if(header != null && header.name == APPEND_TO_URL_HEADER)
                  {
                     AppendToGatewayUrl(String(header.content));
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function set piggybackingEnabled(value:Boolean) : void
      {
         internalPiggybackingEnabled = value;
      }
      
      public function set pollingInterval(value:Number) : void
      {
         internalPollingInterval = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function connectionError(msg:ErrorMessage) : void
      {
         var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","error",msg.faultDetail + " url: \'" + endpoint + (_appendToURL != null ? _appendToURL : "") + "\'");
         faultEvent.rootCause = msg;
         connectFailed(faultEvent);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createURLRequest(message:IMessage) : URLRequest
      {
         var result:URLRequest = new URLRequest();
         if(Boolean(_appendToURL))
         {
            result.url = endpoint + _appendToURL;
         }
         else
         {
            result.url = endpoint;
         }
         monitorRpcMessage(message,result);
         result.contentType = HTTPRequestMessage.CONTENT_TYPE_XML;
         var packet:XML = _encoder.encode(message,null);
         result.data = packet.toString();
         result.method = "POST";
         return result;
      }
      
      private function decodePacket(event:Event) : AMFXResult
      {
         var raw:String = String(URLLoader(event.target).data);
         var xmlData:XML = new XML(raw);
         var _decoder:AMFXDecoder = new AMFXDecoder();
         return _decoder.decode(xmlData);
      }
      
      override public function get protocol() : String
      {
         return "http";
      }
      
      private function requestProcessedHandler(loader:ChannelRequestLoader, event:Event) : void
      {
         if(_pendingRequest == loader)
         {
            _pendingRequest = null;
         }
         while(_messageQueue.length > 0 && _pendingRequest == null)
         {
            internalSend(MessageResponder(_messageQueue.shift()));
         }
      }
      
      private function monitorRpcMessage(message:IMessage, result:URLRequest) : void
      {
         var redirectedUrl:String = null;
         if(NetworkMonitor.isMonitoring())
         {
            redirectedUrl = NetworkMonitor.adjustNetConnectionURL(LoaderConfig.url,result.url);
            if(redirectedUrl != null)
            {
               result.url = redirectedUrl;
            }
         }
      }
      
      private function pingErrorHandler(event:Event) : void
      {
         _log.debug("\'{0}\' fault handler called. {1}",id,event.toString());
         var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Ping.Failed","error"," url: \'" + endpoint + (_appendToURL == null ? "" : _appendToURL + "\'") + "\'");
         faultEvent.rootCause = event;
         connectFailed(faultEvent);
      }
      
      override protected function internalSend(msgResp:MessageResponder) : void
      {
         var urlLoader:ChannelRequestLoader = null;
         var urlRequest:URLRequest = null;
         var mpii:MessagePerformanceInfo = null;
         var httpMsgResp:HTTPMessageResponder = null;
         var responderWrapper:HTTPWrapperResponder = null;
         if(_pendingRequest != null)
         {
            _messageQueue.push(msgResp);
         }
         else
         {
            setFlexClientIdOnMessage(msgResp.message);
            try
            {
               if(mpiEnabled)
               {
                  mpii = new MessagePerformanceInfo();
                  if(recordMessageTimes)
                  {
                     mpii.sendTime = new Date().getTime();
                  }
                  msgResp.message.headers[MessagePerformanceUtils.MPI_HEADER_IN] = mpii;
               }
               urlRequest = createURLRequest(msgResp.message);
               if(msgResp is HTTPMessageResponder)
               {
                  httpMsgResp = HTTPMessageResponder(msgResp);
                  urlLoader = httpMsgResp.urlLoader;
                  urlLoader.completeCallback = httpMsgResp.completeHandler;
                  urlLoader.errorCallback = httpMsgResp.errorHandler;
                  urlLoader.ioErrorCallback = httpMsgResp.ioErrorHandler;
                  urlLoader.securityErrorCallback = httpMsgResp.securityErrorHandler;
               }
               else
               {
                  responderWrapper = new HTTPWrapperResponder(msgResp);
                  urlLoader = new ChannelRequestLoader();
                  urlLoader.completeCallback = responderWrapper.completeHandler;
                  urlLoader.setErrorCallbacks(responderWrapper.errorHandler);
               }
               urlLoader.requestProcessedCallback = requestProcessedHandler;
               if(!(msgResp.message is CommandMessage && CommandMessage(msgResp.message).operation == CommandMessage.POLL_OPERATION))
               {
                  _pendingRequest = urlLoader;
               }
               urlLoader.load(urlRequest);
            }
            catch(e:MessageSerializationError)
            {
               msgResp.agent.fault(e.fault,msgResp.message);
            }
         }
      }
      
      public function get piggybackingEnabled() : Boolean
      {
         return internalPiggybackingEnabled;
      }
      
      public function get pollingInterval() : Number
      {
         return internalPollingInterval;
      }
      
      override protected function getDefaultMessageResponder(agent:MessageAgent, msg:IMessage) : MessageResponder
      {
         return new HTTPMessageResponder(agent,msg,this);
      }
      
      protected function internalPingComplete(msg:AsyncMessage) : void
      {
         if(msg != null)
         {
            ServerConfig.updateServerConfigData(msg.body as ConfigMap,endpoint);
            if(FlexClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
            {
               FlexClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
            }
         }
         connectSuccess();
         if(credentials != null && !(msg is ErrorMessage))
         {
            setAuthenticated(true);
         }
      }
      
      override public function applySettings(settings:XML) : void
      {
         super.applySettings(settings);
         applyPollingSettings(settings);
      }
      
      override protected function connectTimeoutHandler(event:TimerEvent) : void
      {
         _connectLoader.close();
         super.connectTimeoutHandler(event);
      }
      
      override protected function internalConnect() : void
      {
         var msg:CommandMessage = new CommandMessage();
         if(credentials != null)
         {
            msg.operation = CommandMessage.LOGIN_OPERATION;
            msg.body = credentials;
         }
         else
         {
            msg.operation = CommandMessage.CLIENT_PING_OPERATION;
         }
         msg.headers[CommandMessage.MESSAGING_VERSION] = messagingVersion;
         if(ServerConfig.needsConfig(this))
         {
            msg.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
         }
         setFlexClientIdOnMessage(msg);
         var urlRequest:URLRequest = createURLRequest(msg);
         _connectLoader = new ChannelRequestLoader();
         _connectLoader.setErrorCallbacks(pingErrorHandler);
         _connectLoader.completeCallback = pingCompleteHandler;
         _connectLoader.load(urlRequest);
      }
      
      override protected function internalDisconnect(rejected:Boolean = false) : void
      {
         var msg:CommandMessage = null;
         if(!rejected && !shouldBeConnected)
         {
            msg = new CommandMessage();
            msg.operation = CommandMessage.DISCONNECT_OPERATION;
            internalSend(new MessageResponder(null,msg,null));
         }
         setConnected(false);
         super.internalDisconnect(rejected);
         disconnectSuccess(rejected);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get appendToURL() : String
      {
         return _appendToURL;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set appendToURL(value:String) : void
      {
         if(Boolean(value) && Boolean(endpoint))
         {
            _appendToURL = value;
         }
      }
      
      public function set pollingEnabled(value:Boolean) : void
      {
         internalPollingEnabled = value;
      }
      
      public function get pollingEnabled() : Boolean
      {
         return internalPollingEnabled;
      }
      
      private function pingCompleteHandler(event:Event) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         var packet:AMFXResult = decodePacket(event);
         processHeaders(packet);
         var msg:AsyncMessage = packet.result as AsyncMessage;
         if(msg != null && msg is ErrorMessage && ErrorMessage(msg).faultCode == "Client.Authentication")
         {
            internalPingComplete(msg);
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Authentication.Error","warn");
            faultEvent.rootCause = ErrorMessage(msg);
            dispatchEvent(faultEvent);
         }
         else
         {
            internalPingComplete(msg);
         }
      }
   }
}

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.channels.HTTPChannel;
import mx.messaging.channels.amfx.AMFXDecoder;
import mx.messaging.channels.amfx.AMFXResult;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.HTTPRequestMessage;
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.utils.ObjectUtil;

[ResourceBundle("messaging")]
class HTTPWrapperResponder
{
   
   private var _wrappedResponder:MessageResponder;
   
   private var resourceManager:IResourceManager = ResourceManager.getInstance();
   
   public function HTTPWrapperResponder(wrappedResponder:MessageResponder)
   {
      super();
      _wrappedResponder = wrappedResponder;
   }
   
   public function completeHandler(event:Event) : void
   {
      var raw:String = String(URLLoader(event.target).data);
      var xmlData:XML = new XML(raw);
      var _decoder:AMFXDecoder = new AMFXDecoder();
      var packet:AMFXResult = _decoder.decode(xmlData);
      if(packet.result is ErrorMessage)
      {
         _wrappedResponder.status(ErrorMessage(packet.result));
      }
      else if(packet.result is AsyncMessage)
      {
         _wrappedResponder.result(AsyncMessage(packet.result));
      }
   }
   
   public function errorHandler(event:Event) : void
   {
      var msg:ErrorMessage = new ErrorMessage();
      msg.correlationId = _wrappedResponder.message.messageId;
      msg.faultCode = "Server.Error.Request";
      msg.faultString = resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(_wrappedResponder.message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(_wrappedResponder.message).url;
      }
      msg.faultDetail = resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      _wrappedResponder.status(msg);
   }
}

[ResourceBundle("messaging")]
class HTTPMessageResponder extends MessageResponder
{
   
   public var urlLoader:ChannelRequestLoader;
   
   private var decoder:AMFXDecoder;
   
   private var resourceManager:IResourceManager = ResourceManager.getInstance();
   
   public function HTTPMessageResponder(agent:MessageAgent, msg:IMessage, channel:HTTPChannel)
   {
      super(agent,msg,channel);
      decoder = new AMFXDecoder();
      urlLoader = new ChannelRequestLoader();
   }
   
   override protected function requestTimedOut() : void
   {
      urlLoader.close();
      status(null);
      var ack:AcknowledgeMessage = new AcknowledgeMessage();
      ack.correlationId = message.messageId;
      ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(ack,message);
      agent.fault(createRequestTimeoutErrorMessage(),message);
   }
   
   public function ioErrorHandler(event:Event) : void
   {
      status(null);
      var ack:AcknowledgeMessage = new AcknowledgeMessage();
      ack.correlationId = message.messageId;
      ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(ack,message);
      var msg:ErrorMessage = new ErrorMessage();
      msg.correlationId = message.messageId;
      msg.faultCode = "Server.Error.Request";
      msg.faultString = resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(message).url;
      }
      msg.faultDetail = resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      (channel as HTTPChannel).connectionError(msg);
      agent.fault(msg,message);
   }
   
   public function errorHandler(event:Event) : void
   {
      status(null);
      var ack:AcknowledgeMessage = new AcknowledgeMessage();
      ack.correlationId = message.messageId;
      ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(ack,message);
      var msg:ErrorMessage = new ErrorMessage();
      msg.correlationId = message.messageId;
      msg.faultCode = "Server.Error.Request";
      msg.faultString = resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(message).url;
      }
      msg.faultDetail = resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      agent.fault(msg,message);
   }
   
   override protected function resultHandler(response:IMessage) : void
   {
      var errorMsg:ErrorMessage = null;
      if(response is AsyncMessage)
      {
         if(response is ErrorMessage)
         {
            agent.fault(ErrorMessage(response),message);
         }
         else if(AsyncMessage(response).correlationId == message.messageId)
         {
            agent.acknowledge(AcknowledgeMessage(response),message);
         }
         else
         {
            errorMsg = new ErrorMessage();
            errorMsg.faultCode = "Server.Acknowledge.Failed";
            errorMsg.faultString = resourceManager.getString("messaging","ackFailed");
            errorMsg.faultDetail = resourceManager.getString("messaging","ackFailed.details",[message.messageId,AsyncMessage(response).correlationId]);
            agent.fault(errorMsg,message);
         }
      }
      else if(response != null)
      {
         errorMsg = new ErrorMessage();
         errorMsg.faultCode = "Server.Acknowledge.Failed";
         errorMsg.faultString = resourceManager.getString("messaging","noAckMessage");
         errorMsg.faultDetail = resourceManager.getString("messaging","noAckMessage.details",[ObjectUtil.toString(response)]);
         agent.fault(errorMsg,message);
      }
   }
   
   final public function completeHandler(event:Event) : void
   {
      result(null);
      var raw:String = String(URLLoader(event.target).data);
      var xmlData:XML = new XML(raw);
      var packet:AMFXResult = decoder.decode(xmlData);
      if(packet.result is IMessage)
      {
         resultHandler(IMessage(packet.result));
      }
   }
   
   public function securityErrorHandler(event:Event) : void
   {
      status(null);
      var ack:AcknowledgeMessage = new AcknowledgeMessage();
      ack.correlationId = message.messageId;
      ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(ack,message);
      var msg:ErrorMessage = new ErrorMessage();
      msg.correlationId = message.messageId;
      msg.faultCode = "Channel.Security.Error";
      msg.faultString = resourceManager.getString("messaging","securityError");
      msg.faultDetail = resourceManager.getString("messaging","securityError.details",[message.destination]);
      msg.rootCause = event;
      agent.fault(msg,message);
   }
}

class ChannelRequestLoader
{
   
   private var _urlLoader:URLLoader;
   
   public var requestProcessedCallback:Function;
   
   public var ioErrorCallback:Function;
   
   public var securityErrorCallback:Function;
   
   public var errorCallback:Function;
   
   public var completeCallback:Function;
   
   public function ChannelRequestLoader()
   {
      super();
      _urlLoader = new URLLoader();
      _urlLoader.addEventListener(ErrorEvent.ERROR,errorHandler);
      _urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
      _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      _urlLoader.addEventListener(Event.COMPLETE,completeHandler);
   }
   
   private function completeHandler(event:Event) : void
   {
      callRequestProcessedCallback(event);
      callEventCallback(completeCallback,event);
   }
   
   private function callRequestProcessedCallback(event:Event) : void
   {
      if(requestProcessedCallback != null)
      {
         requestProcessedCallback(this,event);
      }
   }
   
   private function errorHandler(event:Event) : void
   {
      callRequestProcessedCallback(event);
      callEventCallback(requestProcessedCallback,event);
   }
   
   public function setErrorCallbacks(callback:Function) : void
   {
      errorCallback = callback;
      ioErrorCallback = callback;
      securityErrorCallback = callback;
   }
   
   private function callEventCallback(callback:Function, event:Event) : void
   {
      if(callback != null)
      {
         callback(event);
      }
   }
   
   private function securityErrorHandler(event:Event) : void
   {
      callRequestProcessedCallback(event);
      callEventCallback(securityErrorCallback,event);
   }
   
   public function load(request:URLRequest) : void
   {
      _urlLoader.load(request);
   }
   
   private function ioErrorHandler(event:Event) : void
   {
      callRequestProcessedCallback(event);
      callEventCallback(ioErrorCallback,event);
   }
   
   public function close() : void
   {
      _urlLoader.removeEventListener(ErrorEvent.ERROR,errorHandler);
      _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
      _urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      _urlLoader.removeEventListener(Event.COMPLETE,completeHandler);
      _urlLoader.close();
   }
}
