package com.riotgames.pvpnet.tracking.logs
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.util.logging.UncaughtErrorRelay;
   import mx.logging.AbstractTarget;
   import mx.logging.ILogger;
   import mx.logging.LogEvent;
   
   public class DradisLogTarget extends AbstractTarget
   {
      
      private static const LOG_ERROR_CONFIG_NS:String = "log_activity";
      
      private static const LOG_ERROR_SEND_PROBABILITY:String = "send_probability";
      
      private static const LOG_ERROR_MAX:String = "max_to_track";
      
      private static const FILTER_ON_LOGOUT:Array = ["ChannelSet.AuthenticationAgent"];
      
      private var _probabilityConfiguration:ConfigurationModel;
      
      private var _maxErrorsConfiguration:ConfigurationModel;
      
      private var _trackedErrors:uint = 0;
      
      private var isEnabled:Boolean = false;
      
      private var _tracker:IMetricsProvider;
      
      private var currentProbability:Number = -1;
      
      public function DradisLogTarget(param1:IMetricsProvider)
      {
         super();
         this._tracker = param1;
         this._probabilityConfiguration = DynamicClientConfigManager.getConfiguration(LOG_ERROR_CONFIG_NS,LOG_ERROR_SEND_PROBABILITY,ClientConfig.instance.trackLoggedErrorsProbability);
         this._maxErrorsConfiguration = DynamicClientConfigManager.getConfiguration(LOG_ERROR_CONFIG_NS,LOG_ERROR_MAX,ClientConfig.instance.maxErrorsToTrack);
      }
      
      private function shouldLog(param1:LogEvent) : Boolean
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:ILogger = param1.target as ILogger;
         if(_loc3_)
         {
            _loc2_ = _loc3_.category;
         }
         if(!LogManager.checkFilters(_loc2_,filters))
         {
            return false;
         }
         if(AppConfig.instance.loggingOut)
         {
            for each(_loc4_ in FILTER_ON_LOGOUT)
            {
               if(_loc2_.indexOf(_loc4_) != -1)
               {
                  return false;
               }
            }
         }
         return this._trackedErrors < this._maxErrorsConfiguration.getNumber();
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         var _loc2_:Object = null;
         if(this.currentProbability != this._probabilityConfiguration.getNumber())
         {
            this.currentProbability = this._probabilityConfiguration.getNumber();
            this.isEnabled = Math.random() < this.currentProbability;
         }
         if(this.isEnabled && !UncaughtErrorRelay.isLogging)
         {
            if(this.shouldLog(param1))
            {
               ++this._trackedErrors;
               _loc2_ = this.buildData(param1);
               if(_loc2_)
               {
                  this._tracker.track("log_activity",_loc2_,false,this.currentProbability);
               }
               else
               {
                  this._tracker.track("failed_to_build_logging_data",param1.message,false,this.currentProbability);
               }
            }
         }
      }
      
      private function buildData(param1:LogEvent) : Object
      {
         var data:Object = null;
         var target:ILogger = null;
         var event:LogEvent = param1;
         try
         {
            data = {};
            data.level = event.level;
            target = event.target as ILogger;
            data.category = target.category;
            data.message = event.message;
            if(event.message.search(/[0-9][0-9][0-9][0-9]/) == 0)
            {
               data.code = event.message.substr(0,4);
            }
            else
            {
               data.code = "9999";
            }
            return data;
         }
         catch(e:Error)
         {
            trace("Unable to serialize a log event for Dradis!");
         }
         return null;
      }
   }
}

