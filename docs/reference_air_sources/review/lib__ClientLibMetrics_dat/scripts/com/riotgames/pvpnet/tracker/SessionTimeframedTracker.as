package com.riotgames.pvpnet.tracker
{
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.tracker.model.RiotDradisRecord;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   
   public class SessionTimeframedTracker extends Tracker
   {
      
      private static var instances:Array = [];
      
      private static var hasSent:Boolean = false;
      
      private static var hasStartedSent:Boolean = false;
      
      protected var _sessionMetrics:ISessionMetricsProvider;
      
      public var sendable:Boolean = true;
      
      public var trackingEnabled:Boolean = false;
      
      public var multiplySendProbability:Number = 1;
      
      public function SessionTimeframedTracker(param1:String, param2:Boolean = true)
      {
         super(param1);
         if(param2)
         {
            this.setup();
         }
         SessionTimeframedTracker.instances.push(this);
      }
      
      public function setup() : void
      {
         ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvider);
      }
      
      public function onSessionMetricsProvider(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
         this._sessionMetrics.getSessionCreatedSignal().add(this.sessionCreated);
         this._sessionMetrics.getSpecialSessionCreatedSignal().add(this.specialSessionCreatedSignal);
         this._sessionMetrics.getSessionForceClosedSignal().add(this.sessionForceClosedSignal);
         this._sessionMetrics.getAllSessionClosedSignal().add(this.staticAllSessionClosed);
      }
      
      public function sessionCreated() : void
      {
         start();
      }
      
      public function specialSessionCreatedSignal(param1:String) : void
      {
         this.sendable = false;
      }
      
      public function sessionForceClosedSignal(param1:String) : void
      {
         this.sendable = false;
         stop();
      }
      
      public function staticAllSessionClosed() : void
      {
         var _loc1_:SessionTimeframedTracker = null;
         var _loc2_:int = 0;
         if(!hasStartedSent)
         {
            hasStartedSent = true;
            if(!hasSent)
            {
               _loc2_ = 0;
               while(_loc2_ < SessionTimeframedTracker.instances.length)
               {
                  _loc1_ = SessionTimeframedTracker.instances[_loc2_] as SessionTimeframedTracker;
                  _loc1_.sessionClosed();
                  _loc2_++;
               }
               this.sendBatch();
            }
         }
      }
      
      public function sessionClosed() : void
      {
         stop();
         this.trackingEnabled = true;
      }
      
      public function postSendCleanup() : void
      {
         clearAllCounters();
         reset();
      }
      
      public function sendBatch() : ITracker
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:SessionTimeframedTracker = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:RiotDradisRecord = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(_canBeSent)
         {
            if(metricsProvider != null)
            {
               _loc1_ = [];
               _loc3_ = false;
               _loc5_ = 0;
               while(_loc5_ < SessionTimeframedTracker.instances.length)
               {
                  _loc4_ = SessionTimeframedTracker.instances[_loc5_] as SessionTimeframedTracker;
                  if(_loc4_.sendable)
                  {
                     _loc2_ = _loc4_.flattenToVars();
                     _loc6_ = false;
                     var _loc11_:int = 0;
                     var _loc12_:* = _loc2_;
                     for(_loc7_ in _loc12_)
                     {
                        _loc6_ = true;
                        _loc3_ = true;
                        _loc2_.tracker_version = TRACKER_VERSION_NUMBER;
                        _loc4_.postSendCleanup();
                     }
                     if(_loc6_)
                     {
                        _loc8_ = metricsProvider.prepareDradisRecord(_loc4_.getName(),_loc2_,_loc4_.multiplySendProbability);
                        _loc9_ = _loc8_.toJSONString();
                        _loc1_.push(_loc9_);
                     }
                  }
                  _loc5_++;
               }
               if(_loc3_)
               {
                  _loc10_ = "[" + _loc1_.join(",") + "]";
                  metricsProvider.submitJSON(_loc10_);
                  hasBeenSent = true;
                  _sent.dispatch(this,toString());
               }
            }
         }
         return this;
      }
   }
}

