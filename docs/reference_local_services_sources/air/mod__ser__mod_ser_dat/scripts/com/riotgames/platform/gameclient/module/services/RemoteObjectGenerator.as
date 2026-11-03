package com.riotgames.platform.gameclient.module.services
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.module.services.lcds.LcdsErrorHandler;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.RTMPChannel;
   import mx.messaging.channels.SecureRTMPChannel;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.events.MessageEvent;
   import mx.rpc.AsyncToken;
   import mx.rpc.IResponder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.InvokeEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.remoting.RemoteObject;
   import mx.utils.Base64Encoder;
   
   public class RemoteObjectGenerator implements IResponder
   {
      
      private static var LOG_IGNORE_FIELDS:Array = ["password","credentials","username","accountId","acctId","summonerId","summonerInternalName","summonerName"];
      
      private var _defaultChannelSet:ChannelSet;
      
      public var config:RiotServiceConfig;
      
      private var _sessionExpirationWarningTimer:Timer;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _callCount:Dictionary = new Dictionary();
      
      public var session:Session;
      
      private var _isExplicitDisconnect:Boolean;
      
      private var _channelSetListeners:Array = [];
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      public function RemoteObjectGenerator()
      {
         super();
      }
      
      public function get defaultChannelSet() : ChannelSet
      {
         if(this._defaultChannelSet == null)
         {
            this._defaultChannelSet = this.createChannelSet(this.config.host);
            this.registerChannelListeners(this._defaultChannelSet);
         }
         return this._defaultChannelSet;
      }
      
      private function onRemoteObjectInvoke(param1:InvokeEvent) : void
      {
         var _loc2_:RemoteObject = param1.target as RemoteObject;
         _loc2_.removeEventListener(InvokeEvent.INVOKE,this.onRemoteObjectInvoke);
         this.startSessionExpirationWarningTimerIfNecessary();
      }
      
      private function startSessionExpirationWarningTimerIfNecessary() : void
      {
         var _loc1_:Number = NaN;
         if(!this.defaultChannelSet.authenticated)
         {
            return;
         }
         if(this._sessionExpirationWarningTimer == null)
         {
            _loc1_ = this.config.sessionExpirationWarningMinutes * 60 * 1000;
            this._sessionExpirationWarningTimer = new Timer(_loc1_,1);
            this._sessionExpirationWarningTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSessionExpirationWarningTimerComplete);
         }
         if(this._sessionExpirationWarningTimer.running)
         {
            this._sessionExpirationWarningTimer.reset();
         }
         this._sessionExpirationWarningTimer.start();
      }
      
      public function createRemoteObject(param1:ChannelSet, param2:String, param3:Function, param4:Function, param5:Dictionary = null, param6:Boolean = true, param7:Boolean = true) : RemoteObject
      {
         var _loc8_:RemoteObject = new RemoteObject();
         _loc8_.makeObjectsBindable = true;
         _loc8_.requestTimeout = 60;
         _loc8_.destination = param2;
         _loc8_.addEventListener(InvokeEvent.INVOKE,this.onRemoteObjectInvoke);
         _loc8_.channelSet = param1;
         var _loc9_:LcdsErrorHandler = new LcdsErrorHandler(param6,param7);
         _loc9_.shellDispatcher = this.shellDispatcher;
         _loc9_.session = this.session;
         _loc8_.addEventListener(ResultEvent.RESULT,_loc9_.createOnSuccessHandlingProxy(param3,param4));
         _loc8_.addEventListener(FaultEvent.FAULT,_loc9_.createOnErrorHandlingProxy(param3,param5));
         return _loc8_;
      }
      
      public function expireAuthenticationChannel(param1:ChannelSet) : void
      {
         if(!this.config.useCache && param1 != null)
         {
            param1.removeEventListener(ChannelEvent.CONNECT,this.handleConnect);
            param1.removeEventListener(ChannelFaultEvent.FAULT,this.handleChannelFault);
            param1.removeEventListener(ChannelEvent.DISCONNECT,this.handleDisconnect);
            param1.logout();
            param1.disconnectAll();
            ServiceLogger.request("remoteObjectGenerator","expireAuthenticationChannel",[param1]);
         }
      }
      
      public function removeChannelSetListener(param1:String, param2:Function) : void
      {
         var _loc4_:int = 0;
         var _loc3_:ArrayCollection = this._channelSetListeners[param1] as ArrayCollection;
         if(_loc3_ != null)
         {
            _loc4_ = int(_loc3_.getItemIndex(param2));
            if(_loc4_ >= 0)
            {
               _loc3_.removeItemAt(_loc4_);
            }
         }
      }
      
      public function getCallCount(param1:String) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:* = this._callCount[param1];
         if(_loc2_ == null)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc3_ = _loc2_ as Number;
            _loc2_ = _loc3_ + 1;
         }
         this._callCount[param1] = _loc2_;
         return _loc2_;
      }
      
      public function result(param1:Object) : void
      {
         this.startSessionExpirationWarningTimerIfNecessary();
      }
      
      public function handleConnect(param1:ChannelEvent) : void
      {
         this.dispatchEventToListeners(param1);
         this.startSessionExpirationWarningTimerIfNecessary();
      }
      
      public function onAsynchronousMessageReceived(param1:MessageEvent) : void
      {
         this.startSessionExpirationWarningTimerIfNecessary();
      }
      
      public function handleChannelFault(param1:ChannelFaultEvent) : void
      {
         this.logger.error("0001 ChannelSet ChannelFaultEvent: {0}",param1.toString());
         this.dispatchEventToListeners(param1);
      }
      
      public function expireDefaultAuthenticationChannel() : void
      {
         this.expireAuthenticationChannel(this._defaultChannelSet);
         this._defaultChannelSet = null;
      }
      
      private function onSessionExpirationWarningTimerComplete(param1:TimerEvent) : void
      {
         var _loc2_:Event = new Event(RemoteServiceErrorEvent.SESSION_EXPIRATION_WARNING);
         this.shellDispatcher.dispatchEvent(_loc2_);
      }
      
      public function handleDisconnect(param1:ChannelEvent) : void
      {
         this.dispatchEventToListeners(param1);
         if(this._sessionExpirationWarningTimer != null)
         {
            this._sessionExpirationWarningTimer.reset();
            if(this._isExplicitDisconnect)
            {
               this._sessionExpirationWarningTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSessionExpirationWarningTimerComplete);
               this._sessionExpirationWarningTimer = null;
            }
         }
      }
      
      public function fault(param1:Object) : void
      {
      }
      
      public function addChannelSetListener(param1:String, param2:Function) : void
      {
         var _loc3_:ArrayCollection = this._channelSetListeners[param1] as ArrayCollection;
         if(_loc3_ != null)
         {
            _loc3_.addItem(param2);
         }
         else
         {
            _loc3_ = new ArrayCollection();
            _loc3_.addItem(param2);
            this._channelSetListeners[param1] = _loc3_;
         }
      }
      
      public function authenticateChannel(param1:ChannelSet, param2:String, param3:String) : void
      {
         var _loc4_:AsyncToken = null;
         if(!this.config.useCache)
         {
            _loc4_ = param1.login(param2,param3,Base64Encoder.CHARSET_UTF_8);
            _loc4_.addResponder(this);
            ServiceLogger.request("remoteObjectGenerator","authenticateChannel",[param1]);
         }
      }
      
      public function createChannelSet(param1:MultiValueProperty) : ChannelSet
      {
         var _loc3_:RTMPChannel = null;
         var _loc4_:SecureRTMPChannel = null;
         var _loc2_:ChannelSet = new ChannelSet();
         if(this.config.channel_protocol == "rtmp")
         {
            _loc3_ = new RTMPChannel(this.config.messaging_channel,param1.value);
            if(param1.hasMultipleValues())
            {
               _loc3_.failoverURIs = param1.alternateValues;
            }
            _loc2_.addChannel(_loc3_);
         }
         else
         {
            _loc4_ = new SecureRTMPChannel(this.config.messaging_channel,param1.value);
            if(param1.hasMultipleValues())
            {
               _loc3_.failoverURIs = param1.alternateValues;
            }
            _loc2_.addChannel(_loc4_);
         }
         ServiceLogger.request("remoteObjectGenerator","createChannelSet",[param1,_loc2_]);
         return _loc2_;
      }
      
      private function dispatchEventToListeners(param1:Event) : void
      {
         var _loc3_:Function = null;
         var _loc2_:ArrayCollection = this._channelSetListeners[param1.type] as ArrayCollection;
         if(_loc2_ != null)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.apply(null,[param1]);
            }
         }
      }
      
      public function registerChannelListeners(param1:ChannelSet) : void
      {
         param1.addEventListener(ChannelEvent.CONNECT,this.handleConnect);
         param1.addEventListener(ChannelFaultEvent.FAULT,this.handleChannelFault);
         param1.addEventListener(ChannelEvent.DISCONNECT,this.handleDisconnect);
      }
   }
}

