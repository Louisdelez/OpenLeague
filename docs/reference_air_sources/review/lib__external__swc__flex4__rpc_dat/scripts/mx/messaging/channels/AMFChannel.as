package mx.messaging.channels
{
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Responder;
   import mx.logging.Log;
   import mx.messaging.FlexClient;
   import mx.messaging.MessageResponder;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.config.ServerConfig;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   [ResourceBundle("messaging")]
   public class AMFChannel extends NetConnectionChannel
   {
      
      protected var _reconnectingWithSessionId:Boolean;
      
      private var _ignoreNetStatusEvents:Boolean;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function AMFChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
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
      
      public function get polling() : Boolean
      {
         return pollOutstanding;
      }
      
      override public function get protocol() : String
      {
         return "http";
      }
      
      override public function applySettings(settings:XML) : void
      {
         super.applySettings(settings);
         applyPollingSettings(settings);
      }
      
      override public function AppendToGatewayUrl(value:String) : void
      {
         if(value != null && value != "" && _appendToURL != value)
         {
            super.AppendToGatewayUrl(value);
            this._reconnectingWithSessionId = true;
         }
      }
      
      override protected function internalConnect() : void
      {
         super.internalConnect();
         this._ignoreNetStatusEvents = false;
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
         netConnection.call(null,new Responder(this.resultHandler,this.faultHandler),msg);
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' pinging endpoint.",id);
         }
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
      }
      
      override protected function internalSend(msgResp:MessageResponder) : void
      {
         this.handleReconnectWithSessionId();
         super.internalSend(msgResp);
      }
      
      override protected function shutdownNetConnection() : void
      {
         _nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         _nc.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         this._ignoreNetStatusEvents = true;
         _nc.close();
      }
      
      override protected function statusHandler(event:NetStatusEvent) : void
      {
         var channelFault:ChannelFaultEvent = null;
         var info:Object = null;
         var errorText:String = null;
         if(this._ignoreNetStatusEvents)
         {
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got status. {1}",id,ObjectUtil.toString(event.info));
         }
         var handled:Boolean = true;
         if(event.info != null)
         {
            info = event.info;
            if(info.level == "error")
            {
               if(info.code == "Client.Data.UnderFlow")
               {
                  if(Log.isDebug())
                  {
                     _log.debug("\'{0}\' channel received a \'Client.Data.Underflow\' status event.");
                  }
                  return;
               }
               if(connected)
               {
                  if(info.code.indexOf("Call.Failed") != -1)
                  {
                     channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Call.Failed",info.level,info.code + ": " + info.description);
                     channelFault.rootCause = info;
                     dispatchEvent(channelFault);
                  }
                  this.internalDisconnect();
               }
               else
               {
                  channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed",info.level,info.code + ": " + info.description + ": url: \'" + endpoint + "\'");
                  channelFault.rootCause = info;
                  connectFailed(channelFault);
               }
            }
            else if(!connected)
            {
               handled = info.level == "status" && info.code.indexOf("Connect.Closed") != -1;
            }
            else
            {
               handled = false;
            }
         }
         else
         {
            handled = false;
         }
         if(!handled)
         {
            errorText = this.resourceManager.getString("messaging","invalidURL");
            connectFailed(ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","error",errorText + " url: \'" + endpoint + "\'"));
         }
      }
      
      protected function handleReconnectWithSessionId() : void
      {
         if(this._reconnectingWithSessionId)
         {
            this._reconnectingWithSessionId = false;
            this.shutdownNetConnection();
            super.internalConnect();
            this._ignoreNetStatusEvents = false;
         }
      }
      
      protected function faultHandler(msg:ErrorMessage) : void
      {
         var faultEvent:ChannelFaultEvent = null;
         var serverVersion:Number = NaN;
         if(msg != null)
         {
            faultEvent = null;
            if(msg.faultCode == "Client.Authentication")
            {
               this.resultHandler(msg);
               faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Authentication.Error","warn",msg.faultString);
               faultEvent.rootCause = msg;
               dispatchEvent(faultEvent);
            }
            else
            {
               _log.debug("\'{0}\' fault handler called. {1}",id,msg.toString());
               if(FlexClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
               {
                  FlexClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
               }
               if(msg.headers[CommandMessage.MESSAGING_VERSION] != null)
               {
                  serverVersion = msg.headers[CommandMessage.MESSAGING_VERSION] as Number;
                  handleServerMessagingVersion(serverVersion);
               }
               faultEvent = ChannelFaultEvent.createEvent(this,false,"Channel.Ping.Failed","error",msg.faultString + " url: \'" + endpoint + (_appendToURL == null ? "" : _appendToURL + "\'") + "\'");
               faultEvent.rootCause = msg;
               connectFailed(faultEvent);
            }
         }
         this.handleReconnectWithSessionId();
      }
      
      protected function resultHandler(msg:IMessage) : void
      {
         var serverVersion:Number = NaN;
         if(msg != null)
         {
            ServerConfig.updateServerConfigData(msg.body as ConfigMap,endpoint);
            if(FlexClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
            {
               FlexClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];
            }
            if(msg.headers[CommandMessage.MESSAGING_VERSION] != null)
            {
               serverVersion = msg.headers[CommandMessage.MESSAGING_VERSION] as Number;
               handleServerMessagingVersion(serverVersion);
            }
         }
         this.handleReconnectWithSessionId();
         connectSuccess();
         if(credentials != null && !(msg is ErrorMessage))
         {
            setAuthenticated(true);
         }
      }
   }
}

