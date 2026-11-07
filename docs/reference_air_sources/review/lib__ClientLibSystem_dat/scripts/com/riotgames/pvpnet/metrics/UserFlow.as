package com.riotgames.pvpnet.metrics
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.MetricsProxy;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.logging.getLogger;
   import flash.utils.getTimer;
   import mx.logging.ILogger;
   
   public class UserFlow
   {
      
      private static var _instance:UserFlow;
      
      private static const USER_FLOW_NS:String = "user_flow";
      
      private static const USER_FLOW_SEND_PROBABILITY:String = "send_probability";
      
      private static const USER_FLOW_MAX:String = "max_to_track";
      
      private static const USER_FLOW_COOLDOWN_MS:String = "cooldown_ms";
      
      private static const USER_FLOW_COOLDOWN_MAX:String = "cooldown_max";
      
      private static const USER_FLOW_TABLE:String = "front_end_user_flow_tracking";
      
      public static const INPUT:String = "input";
      
      public static const EVENT:String = "event";
      
      private var logger:ILogger = getLogger(this);
      
      private var _probabilityConfiguration:ConfigurationModel;
      
      private var _maxToTrackConfiguration:ConfigurationModel;
      
      private var _cooldownMsConfiguration:ConfigurationModel;
      
      private var _cooldownMaxConfiguration:ConfigurationModel;
      
      private var currentProbability:Number = -1;
      
      private var isEnabled:Boolean = false;
      
      private var maxToTrack:int;
      
      private var eventNumber:int = 0;
      
      private var lastEventTime:int = -1;
      
      private var cooldownEvents:int = 0;
      
      public function UserFlow()
      {
         super();
         this._probabilityConfiguration = DynamicClientConfigManager.getConfiguration(USER_FLOW_NS,USER_FLOW_SEND_PROBABILITY,ClientConfig.instance.userFlowTrackingProbability);
         this._maxToTrackConfiguration = DynamicClientConfigManager.getConfiguration(USER_FLOW_NS,USER_FLOW_MAX,ClientConfig.instance.userFlowMaxEvents);
         this._cooldownMsConfiguration = DynamicClientConfigManager.getConfiguration(USER_FLOW_NS,USER_FLOW_COOLDOWN_MS,ClientConfig.instance.userFlowCooldownMs);
         this._cooldownMaxConfiguration = DynamicClientConfigManager.getConfiguration(USER_FLOW_NS,USER_FLOW_COOLDOWN_MAX,ClientConfig.instance.userFlowCooldownMaxEvents);
      }
      
      public static function track(param1:String, param2:String, param3:Object = null, param4:String = "event") : void
      {
         instance.track(param1,param2,param3,param4);
      }
      
      private static function get instance() : UserFlow
      {
         if(!_instance)
         {
            _instance = new UserFlow();
         }
         return _instance;
      }
      
      private function willTrack() : Boolean
      {
         if(this.currentProbability != this._probabilityConfiguration.getNumber())
         {
            this.currentProbability = this._probabilityConfiguration.getNumber();
            this.isEnabled = Math.random() < this.currentProbability;
            if(this.isEnabled)
            {
               this.logger.info("User Flow Tracking is enabled.");
            }
         }
         var _loc1_:Boolean = this.eventNumber >= this._maxToTrackConfiguration.getInt();
         var _loc2_:Boolean = this.isInCooldownInterval && this.cooldownEvents >= this._cooldownMaxConfiguration.getInt();
         return this.isEnabled && !_loc1_ && !_loc2_ && Boolean(MetricsProxy.instance.willTrack());
      }
      
      private function track(param1:String, param2:String, param3:Object, param4:String) : void
      {
         var allData:Object = null;
         var propName:String = null;
         var eventSuperType:String = param1;
         var event:String = param2;
         var data:Object = param3;
         var source:String = param4;
         if(this.willTrack())
         {
            allData = {};
            try
            {
               if(data != null)
               {
                  for(propName in data)
                  {
                     allData[propName] = data[propName];
                  }
               }
            }
            catch(e:Error)
            {
               logger.info("Error serializing data for dradis in UserFlow");
            }
            this.addUserFlowData(allData,eventSuperType,event,source);
            MetricsProxy.instance.track(USER_FLOW_TABLE,allData,this.currentProbability);
            if(this.isInCooldownInterval)
            {
               ++this.cooldownEvents;
            }
            else
            {
               this.cooldownEvents = 0;
            }
            ++this.eventNumber;
         }
      }
      
      private function get isInCooldownInterval() : Boolean
      {
         var _loc1_:int = getTimer();
         return _loc1_ - this.lastEventTime < this._cooldownMsConfiguration.getInt();
      }
      
      private function addUserFlowData(param1:Object, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:int = getTimer();
         if(this.lastEventTime < 0)
         {
            this.lastEventTime = AppConfig.instance.sessionStartTime;
         }
         param1.event_supertype = param2;
         param1.event = param3;
         param1.session_event_number = this.eventNumber;
         param1.time_ms_since_session_start = _loc5_ - AppConfig.instance.sessionStartTime;
         param1.time_ms_since_previous_event = _loc5_ - this.lastEventTime;
         param1.event_source = param4;
         this.lastEventTime = _loc5_;
      }
   }
}

