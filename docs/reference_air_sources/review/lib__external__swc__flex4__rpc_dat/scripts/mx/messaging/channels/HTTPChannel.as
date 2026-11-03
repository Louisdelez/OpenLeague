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
      
      private var _connectLoader:ChannelRequestLoader;
      
      private var _encoder:AMFXEncoder;
      
      private var _pendingRequest:ChannelRequestLoader = null;
      
      private var _messageQueue:Array;
      
      public function HTTPChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
         this._encoder = new AMFXEncoder();
         this._appendToURL = "";
         this._messageQueue = [];
      }
      
      public function get polling() : Boolean
      {
         return pollOutstanding;
      }
      
      public function get piggybackingEnabled() : Boolean
      {
         return internalPiggybackingEnabled;
      }
      
      public function set piggybackingEnabled(value:Boolean) : void
      {
         internalPiggybackingEnabled = value;
      }
      
      public function get pollingEnabled() : Boolean
      {
         return internalPollingEnabled;
      }
      
      public function set pollingEnabled(value:Boolean) : void
      {
         internalPollingEnabled = value;
      }
      
      public function get pollingInterval() : Number
      {
         return internalPollingInterval;
      }
      
      public function set pollingInterval(value:Number) : void
      {
         internalPollingInterval = value;
      }
      
      override public function get protocol() : String
      {
         return "http";
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get appendToURL() : String
      {
         return this._appendToURL;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set appendToURL(value:String) : void
      {
         if(Boolean(value) && Boolean(endpoint))
         {
            this._appendToURL = value;
         }
      }
      
      override public function applySettings(settings:XML) : void
      {
         super.applySettings(settings);
         applyPollingSettings(settings);
      }
      
      override protected function connectTimeoutHandler(event:TimerEvent) : void
      {
         this._connectLoader.close();
         super.connectTimeoutHandler(event);
      }
      
      override protected function getDefaultMessageResponder(agent:MessageAgent, msg:IMessage) : MessageResponder
      {
         return new HTTPMessageResponder(agent,msg,this);
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
         if(ServerConfig.needsConfig(this))
         {
            msg.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
         }
         setFlexClientIdOnMessage(msg);
         var urlRequest:URLRequest = this.createURLRequest(msg);
         this._connectLoader = new ChannelRequestLoader();
         this._connectLoader.setErrorCallbacks(this.pingErrorHandler);
         this._connectLoader.completeCallback = this.pingCompleteHandler;
         this._connectLoader.load(urlRequest);
      }
      
      override protected function internalDisconnect(rejected:Boolean = false) : void
      {
         var msg:CommandMessage = null;
         if(!rejected && !shouldBeConnected)
         {
            msg = new CommandMessage();
            msg.operation = CommandMessage.DISCONNECT_OPERATION;
            this.internalSend(new MessageResponder(null,msg,null));
         }
         setConnected(false);
         super.internalDisconnect(rejected);
         disconnectSuccess(rejected);
      }
      
      override protected function internalSend(msgResp:MessageResponder) : void
      {
         var urlLoader:ChannelRequestLoader = null;
         var urlRequest:URLRequest = null;
         var mpii:MessagePerformanceInfo = null;
         var httpMsgResp:HTTPMessageResponder = null;
         var responderWrapper:HTTPWrapperResponder = null;
         if(this._pendingRequest != null)
         {
            this._messageQueue.push(msgResp);
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
               urlRequest = this.createURLRequest(msgResp.message);
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
               urlLoader.requestProcessedCallback = this.requestProcessedHandler;
               if(!(msgResp.message is CommandMessage && CommandMessage(msgResp.message).operation == CommandMessage.POLL_OPERATION))
               {
                  this._pendingRequest = urlLoader;
               }
               urlLoader.load(urlRequest);
            }
            catch(e:MessageSerializationError)
            {
               msgResp.agent.fault(e.fault,msgResp.message);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function connectionError(msg:ErrorMessage) : void
      {
         var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","error",msg.faultDetail + " url: \'" + endpoint + (this._appendToURL != null ? this._appendToURL : "") + "\'");
         faultEvent.rootCause = msg;
         connectFailed(faultEvent);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createURLRequest(message:IMessage) : URLRequest
      {
         var result:URLRequest = new URLRequest();
         if(Boolean(this._appendToURL))
         {
            result.url = endpoint + this._appendToURL;
         }
         else
         {
            result.url = endpoint;
         }
         if("idleTimeout" in result && requestTimeout > 0)
         {
            result["idleTimeout"] = requestTimeout * 1000;
         }
         this.monitorRpcMessage(message,result);
         result.contentType = HTTPRequestMessage.CONTENT_TYPE_XML;
         var packet:XML = this._encoder.encode(message,null);
         result.data = packet.toString();
         result.method = "POST";
         return result;
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
      
      private function AppendToGatewayUrl(value:String) : void
      {
         if(value != null)
         {
            this.appendToURL = value;
         }
      }
      
      private function decodePacket(event:Event) : AMFXResult
      {
         var raw:String = String(URLLoader(event.target).data);
         var xmlData:XML = new XML(raw);
         var _decoder:AMFXDecoder = new AMFXDecoder();
         return _decoder.decode(xmlData);
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
                     this.AppendToGatewayUrl(String(header.content));
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function pingCompleteHandler(event:Event) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         var packet:AMFXResult = this.decodePacket(event);
         this.processHeaders(packet);
         var msg:AsyncMessage = packet.result as AsyncMessage;
         if(msg != null && msg is ErrorMessage && ErrorMessage(msg).faultCode == "Client.Authentication")
         {
            this.internalPingComplete(msg);
            faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Authentication.Error","warn");
            faultEvent.rootCause = ErrorMessage(msg);
            dispatchEvent(faultEvent);
         }
         else
         {
            this.internalPingComplete(msg);
         }
      }
      
      private function pingErrorHandler(event:Event) : void
      {
         _log.debug("\'{0}\' fault handler called. {1}",id,event.toString());
         var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Ping.Failed","error"," url: \'" + endpoint + (this._appendToURL == null ? "" : this._appendToURL + "\'") + "\'");
         faultEvent.rootCause = event;
         connectFailed(faultEvent);
      }
      
      private function requestProcessedHandler(loader:ChannelRequestLoader, event:Event) : void
      {
         if(this._pendingRequest == loader)
         {
            this._pendingRequest = null;
         }
         while(this._messageQueue.length > 0 && this._pendingRequest == null)
         {
            this.internalSend(MessageResponder(this._messageQueue.shift()));
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
      this._wrappedResponder = wrappedResponder;
   }
   
   public function completeHandler(event:Event) : void
   {
      var raw:String = String(URLLoader(event.target).data);
      var xmlData:XML = new XML(raw);
      var _decoder:AMFXDecoder = new AMFXDecoder();
      var packet:AMFXResult = _decoder.decode(xmlData);
      if(packet.result is ErrorMessage)
      {
         this._wrappedResponder.status(ErrorMessage(packet.result));
      }
      else if(packet.result is AsyncMessage)
      {
         this._wrappedResponder.result(AsyncMessage(packet.result));
      }
   }
   
   public function errorHandler(event:Event) : void
   {
      var msg:ErrorMessage = new ErrorMessage();
      msg.correlationId = this._wrappedResponder.message.messageId;
      msg.faultCode = "Server.Error.Request";
      msg.faultString = this.resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(this._wrappedResponder.message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(this._wrappedResponder.message).url;
      }
      msg.faultDetail = this.resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      this._wrappedResponder.status(msg);
   }
}

[ResourceBundle("messaging")]
class HTTPMessageResponder extends MessageResponder
{
   
   private var decoder:AMFXDecoder;
   
   private var resourceManager:IResourceManager = ResourceManager.getInstance();
   
   public var urlLoader:ChannelRequestLoader;
   
   public function HTTPMessageResponder(agent:MessageAgent, msg:IMessage, channel:HTTPChannel)
   {
      super(agent,msg,channel);
      this.decoder = new AMFXDecoder();
      this.urlLoader = new ChannelRequestLoader();
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
            errorMsg.faultString = this.resourceManager.getString("messaging","ackFailed");
            errorMsg.faultDetail = this.resourceManager.getString("messaging","ackFailed.details",[message.messageId,AsyncMessage(response).correlationId]);
            agent.fault(errorMsg,message);
         }
      }
      else if(response != null)
      {
         errorMsg = new ErrorMessage();
         errorMsg.faultCode = "Server.Acknowledge.Failed";
         errorMsg.faultString = this.resourceManager.getString("messaging","noAckMessage");
         errorMsg.faultDetail = this.resourceManager.getString("messaging","noAckMessage.details",[ObjectUtil.toString(response)]);
         agent.fault(errorMsg,message);
      }
   }
   
   override protected function requestTimedOut() : void
   {
      this.urlLoader.close();
      status(null);
      var ack:AcknowledgeMessage = new AcknowledgeMessage();
      ack.correlationId = message.messageId;
      ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(ack,message);
      agent.fault(createRequestTimeoutErrorMessage(),message);
   }
   
   final public function completeHandler(event:Event) : void
   {
      result(null);
      var raw:String = String(URLLoader(event.target).data);
      var xmlData:XML = new XML(raw);
      var packet:AMFXResult = this.decoder.decode(xmlData);
      if(packet.result is IMessage)
      {
         this.resultHandler(IMessage(packet.result));
      }
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
      msg.faultString = this.resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(message).url;
      }
      msg.faultDetail = this.resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      agent.fault(msg,message);
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
      msg.faultString = this.resourceManager.getString("messaging","httpRequestError");
      var details:String = event.toString();
      if(message is HTTPRequestMessage)
      {
         details += ". URL: ";
         details += HTTPRequestMessage(message).url;
      }
      msg.faultDetail = this.resourceManager.getString("messaging","httpRequestError.details",[details]);
      msg.rootCause = event;
      (channel as HTTPChannel).connectionError(msg);
      agent.fault(msg,message);
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
      msg.faultString = this.resourceManager.getString("messaging","securityError");
      msg.faultDetail = this.resourceManager.getString("messaging","securityError.details",[message.destination]);
      msg.rootCause = event;
      agent.fault(msg,message);
   }
}

class ChannelRequestLoader
{
   
   private var _urlLoader:URLLoader;
   
   public var errorCallback:Function;
   
   public var ioErrorCallback:Function;
   
   public var securityErrorCallback:Function;
   
   public var completeCallback:Function;
   
   public var requestProcessedCallback:Function;
   
   public function ChannelRequestLoader()
   {
      super();
      this._urlLoader = new URLLoader();
      this._urlLoader.addEventListener(ErrorEvent.ERROR,this.errorHandler);
      this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      this._urlLoader.addEventListener(Event.COMPLETE,this.completeHandler);
   }
   
   public function load(request:URLRequest) : void
   {
      this._urlLoader.load(request);
   }
   
   public function close() : void
   {
      this._urlLoader.removeEventListener(ErrorEvent.ERROR,this.errorHandler);
      this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      this._urlLoader.removeEventListener(Event.COMPLETE,this.completeHandler);
      this._urlLoader.close();
   }
   
   public function setErrorCallbacks(callback:Function) : void
   {
      this.errorCallback = callback;
      this.ioErrorCallback = callback;
      this.securityErrorCallback = callback;
   }
   
   private function callRequestProcessedCallback(event:Event) : void
   {
      if(this.requestProcessedCallback != null)
      {
         this.requestProcessedCallback(this,event);
      }
   }
   
   private function callEventCallback(callback:Function, event:Event) : void
   {
      if(callback != null)
      {
         callback(event);
      }
   }
   
   private function errorHandler(event:Event) : void
   {
      this.callRequestProcessedCallback(event);
      this.callEventCallback(this.requestProcessedCallback,event);
   }
   
   private function ioErrorHandler(event:Event) : void
   {
      this.callRequestProcessedCallback(event);
      this.callEventCallback(this.ioErrorCallback,event);
   }
   
   private function securityErrorHandler(event:Event) : void
   {
      this.callRequestProcessedCallback(event);
      this.callEventCallback(this.securityErrorCallback,event);
   }
   
   private function completeHandler(event:Event) : void
   {
      this.callRequestProcessedCallback(event);
      this.callEventCallback(this.completeCallback,event);
   }
}
