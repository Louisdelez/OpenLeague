package mx.messaging.channels
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.logging.Log;
   import mx.messaging.Channel;
   import mx.messaging.ChannelSet;
   import mx.messaging.Consumer;
   import mx.messaging.ConsumerMessageDispatcher;
   import mx.messaging.MessageAgent;
   import mx.messaging.MessageResponder;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("messaging")]
   public class PollingChannel extends Channel
   {
      
      private static const DEFAULT_POLLING_INTERVAL:int = 3000;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _timer:Timer;
      
      private var _pollingEnabled:Boolean;
      
      private var _piggybackingEnabled:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _pollingInterval:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pollOutstanding:Boolean;
      
      private var _pollingRef:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _shouldPoll:Boolean;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function PollingChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
         _pollingEnabled = true;
         _shouldPoll = false;
         if(timerRequired())
         {
            _pollingInterval = DEFAULT_POLLING_INTERVAL;
            _timer = new Timer(_pollingInterval,1);
            _timer.addEventListener(TimerEvent.TIMER,internalPoll);
         }
      }
      
      public function enablePolling() : void
      {
         ++_pollingRef;
         if(_pollingRef == 0)
         {
            startPolling();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get timerRunning() : Boolean
      {
         return _timer != null && _timer.running;
      }
      
      protected function timerRequired() : Boolean
      {
         return true;
      }
      
      override protected function setConnected(value:Boolean) : void
      {
         var channelSet:ChannelSet = null;
         var agent:MessageAgent = null;
         if(connected != value)
         {
            if(value)
            {
               for each(channelSet in channelSets)
               {
                  for each(agent in channelSet.messageAgents)
                  {
                     if(agent is Consumer && (agent as Consumer).subscribed)
                     {
                        enablePolling();
                     }
                  }
               }
            }
            super.setConnected(value);
         }
      }
      
      override public function send(agent:MessageAgent, message:IMessage) : void
      {
         var consumerDispatcher:ConsumerMessageDispatcher = null;
         var msg:CommandMessage = null;
         var piggyback:Boolean = false;
         if(!pollOutstanding && _piggybackingEnabled && !(message is CommandMessage))
         {
            if(_shouldPoll)
            {
               piggyback = true;
            }
            else
            {
               consumerDispatcher = ConsumerMessageDispatcher.getInstance();
               if(consumerDispatcher.isChannelUsedForSubscriptions(this))
               {
                  piggyback = true;
               }
            }
         }
         if(piggyback)
         {
            internalPoll();
         }
         super.send(agent,message);
         if(piggyback)
         {
            msg = new CommandMessage();
            msg.operation = CommandMessage.POLL_OPERATION;
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' channel sending poll message\n{1}\n",id,msg.toString());
            }
            try
            {
               internalSend(new PollCommandMessageResponder(null,msg,this,_log));
            }
            catch(e:Error)
            {
               stopPolling();
               throw e;
            }
         }
      }
      
      protected function applyPollingSettings(settings:XML) : void
      {
         var props:XML = null;
         if(Boolean(settings.properties.length()))
         {
            props = settings.properties[0];
            if(Boolean(props["polling-enabled"].length()))
            {
               internalPollingEnabled = props["polling-enabled"].toString() == "true";
            }
            if(Boolean(props["polling-interval-millis"].length()))
            {
               internalPollingInterval = parseInt(props["polling-interval-millis"].toString());
            }
            else if(Boolean(props["polling-interval-seconds"].length()))
            {
               internalPollingInterval = parseInt(props["polling-interval-seconds"].toString()) * 1000;
            }
            if(Boolean(props["piggybacking-enabled"].length()))
            {
               internalPiggybackingEnabled = props["piggybacking-enabled"].toString() == "true";
            }
            if(Boolean(props["login-after-disconnect"].length()))
            {
               _loginAfterDisconnect = props["login-after-disconnect"].toString() == "true";
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set internalPollingInterval(value:Number) : void
      {
         var message:String = null;
         if(value == 0)
         {
            _pollingInterval = value;
            if(_timer != null)
            {
               _timer.stop();
            }
            if(_shouldPoll)
            {
               startPolling();
            }
         }
         else
         {
            if(value <= 0)
            {
               message = resourceManager.getString("messaging","pollingIntervalNonPositive");
               throw new ArgumentError(message);
            }
            if(_timer != null)
            {
               _timer.delay = _pollingInterval = value;
               if(!timerRunning && _shouldPoll)
               {
                  startPolling();
               }
            }
         }
      }
      
      public function poll() : void
      {
         internalPoll();
      }
      
      protected function set internalPiggybackingEnabled(value:Boolean) : void
      {
         _piggybackingEnabled = value;
      }
      
      protected function get internalPollingEnabled() : Boolean
      {
         return _pollingEnabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function pollFailed(rejected:Boolean = false) : void
      {
         internalDisconnect(rejected);
      }
      
      override protected function connectFailed(event:ChannelFaultEvent) : void
      {
         stopPolling();
         super.connectFailed(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stopPolling() : void
      {
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel polling stopped.",id);
         }
         if(_timer != null)
         {
            _timer.stop();
         }
         _pollingRef = -1;
         _shouldPoll = false;
         pollOutstanding = false;
      }
      
      protected function internalPoll(event:Event = null) : void
      {
         var poll:CommandMessage = null;
         if(!pollOutstanding)
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel requesting queued messages.",id);
            }
            if(timerRunning)
            {
               _timer.stop();
            }
            poll = new CommandMessage();
            poll.operation = CommandMessage.POLL_OPERATION;
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' channel sending poll message\n{1}\n",id,poll.toString());
            }
            try
            {
               internalSend(new PollCommandMessageResponder(null,poll,this,_log));
               pollOutstanding = true;
            }
            catch(e:Error)
            {
               stopPolling();
               throw e;
            }
         }
         else if(Log.isInfo())
         {
            _log.info("\'{0}\' channel waiting for poll response.",id);
         }
      }
      
      protected function getDefaultMessageResponder(agent:MessageAgent, msg:IMessage) : MessageResponder
      {
         return super.getMessageResponder(agent,msg);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get internalPollingInterval() : Number
      {
         return _timer == null ? 0 : _pollingInterval;
      }
      
      protected function startPolling() : void
      {
         if(_pollingEnabled)
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel polling started.",id);
            }
            _shouldPoll = true;
            poll();
         }
      }
      
      protected function get internalPiggybackingEnabled() : Boolean
      {
         return _piggybackingEnabled;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get realtime() : Boolean
      {
         return _pollingEnabled;
      }
      
      final override protected function getMessageResponder(agent:MessageAgent, msg:IMessage) : MessageResponder
      {
         if(msg is CommandMessage && (msg as CommandMessage).operation == CommandMessage.POLL_OPERATION)
         {
            return new PollCommandMessageResponder(agent,msg,this,_log);
         }
         return getDefaultMessageResponder(agent,msg);
      }
      
      override protected function internalDisconnect(rejected:Boolean = false) : void
      {
         stopPolling();
         super.internalDisconnect(rejected);
      }
      
      public function disablePolling() : void
      {
         --_pollingRef;
         if(_pollingRef < 0)
         {
            stopPolling();
         }
      }
      
      protected function set internalPollingEnabled(value:Boolean) : void
      {
         _pollingEnabled = value;
         if(!value && (timerRunning || !timerRunning && _pollingInterval == 0))
         {
            stopPolling();
         }
         else if(value && _shouldPoll && !timerRunning)
         {
            startPolling();
         }
      }
   }
}

import mx.events.PropertyChangeEvent;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.channels.PollingChannel;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.events.MessageEvent;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.messaging.messages.MessagePerformanceUtils;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

[ResourceBundle("messaging")]
class PollCommandMessageResponder extends MessageResponder
{
   
   private var _log:ILogger;
   
   private var suppressHandlers:Boolean;
   
   private var resourceManager:IResourceManager = ResourceManager.getInstance();
   
   public function PollCommandMessageResponder(agent:MessageAgent, msg:IMessage, channel:PollingChannel, log:ILogger)
   {
      super(agent,msg,channel);
      _log = log;
      channel.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,channelPropertyChangeHandler);
   }
   
   private function doPoll(adaptivePollWait:int = 0) : void
   {
      var pollingChannel:PollingChannel = PollingChannel(channel);
      if(pollingChannel.connected && pollingChannel._shouldPoll)
      {
         if(adaptivePollWait == 0)
         {
            if(pollingChannel.internalPollingInterval == 0)
            {
               pollingChannel.poll();
            }
            else if(!pollingChannel.timerRunning)
            {
               pollingChannel._timer.delay = pollingChannel._pollingInterval;
               pollingChannel._timer.start();
            }
         }
         else
         {
            pollingChannel._timer.delay = adaptivePollWait;
            pollingChannel._timer.start();
         }
      }
   }
   
   private function channelPropertyChangeHandler(event:PropertyChangeEvent) : void
   {
      if(event.property == "connected" && !event.newValue)
      {
         suppressHandlers = true;
      }
   }
   
   override protected function resultHandler(msg:IMessage) : void
   {
      var messageList:Array = null;
      var message:IMessage = null;
      var mpiutil:MessagePerformanceUtils = null;
      var errMsg:ErrorMessage = null;
      var pollingChannel:PollingChannel = channel as PollingChannel;
      if(suppressHandlers)
      {
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel ignoring response for poll request preceeding most recent disconnect.\n",channel.id);
         }
         doPoll();
         return;
      }
      if(msg is CommandMessage)
      {
         pollingChannel.pollOutstanding = false;
         if(msg.headers[CommandMessage.NO_OP_POLL_HEADER] == true)
         {
            return;
         }
         if(msg.body != null)
         {
            messageList = msg.body as Array;
            var _loc3_:int = 0;
            for(var _loc4_:* = messageList; §§hasnext(_loc4_,_loc3_); channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,message)))
            {
               message = §§nextvalue(_loc3_,_loc4_);
               if(Log.isDebug())
               {
                  _log.debug("\'{0}\' channel got message\n{1}\n",channel.id,message.toString());
                  if(channel.mpiEnabled)
                  {
                     try
                     {
                        mpiutil = new MessagePerformanceUtils(message);
                        _log.debug(mpiutil.prettyPrint());
                     }
                     catch(e:Error)
                     {
                        _log.debug("Could not get message performance information for: " + msg.toString());
                     }
                     continue;
                  }
               }
            }
         }
      }
      else
      {
         if(!(msg is AcknowledgeMessage))
         {
            errMsg = new ErrorMessage();
            errMsg.faultDetail = resourceManager.getString("messaging","receivedNull");
            status(errMsg);
            return;
         }
         pollingChannel.pollOutstanding = false;
      }
      if(msg.headers[CommandMessage.POLL_WAIT_HEADER] != null)
      {
         doPoll(msg.headers[CommandMessage.POLL_WAIT_HEADER]);
      }
      else
      {
         doPoll();
      }
   }
   
   override protected function statusHandler(msg:IMessage) : void
   {
      if(suppressHandlers)
      {
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel ignoring response for poll request preceeding most recent disconnect.\n",channel.id);
         }
         return;
      }
      var pollingChannel:PollingChannel = PollingChannel(channel);
      pollingChannel.stopPolling();
      var errMsg:ErrorMessage = msg as ErrorMessage;
      var details:String = errMsg != null ? errMsg.faultDetail : "";
      var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(pollingChannel,false,"Channel.Polling.Error","error",details);
      faultEvent.rootCause = msg;
      pollingChannel.dispatchEvent(faultEvent);
      if(errMsg != null && errMsg.faultCode == "Server.PollNotSupported")
      {
         pollingChannel.pollFailed(true);
      }
      else
      {
         pollingChannel.pollFailed(false);
      }
   }
}
