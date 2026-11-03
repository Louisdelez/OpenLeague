package com.riotgames.pvpnet.tracking.errors
{
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.logging.UncaughtErrorDto;
   import com.riotgames.util.logging.UncaughtErrorRelay;
   import flash.events.ErrorEvent;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class DradisUncaughtErrorTracker
   {
      
      private static const UNCAUGHT_ERROR_CONFIG_NS:String = "uncaught_errors";
      
      private static const UNCAUGHT_ERROR_SEND_PROBABILITY:String = "send_probability";
      
      private static const UNCAUGHT_ERROR_MAX:String = "max_to_track";
      
      private static const ENTRY_POINT_FILTER:Array = ["com.riotgames","blix"];
      
      private var _maxErrorsConfiguration:ConfigurationModel;
      
      private var _probabilityConfiguration:ConfigurationModel;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var isEnabled:Boolean = false;
      
      private var _tracker:IMetricsProvider;
      
      private var currentProbability:Number = -1;
      
      public function DradisUncaughtErrorTracker(param1:IMetricsProvider)
      {
         super();
         this._tracker = param1;
         this._probabilityConfiguration = DynamicClientConfigManager.getConfiguration(UNCAUGHT_ERROR_CONFIG_NS,UNCAUGHT_ERROR_SEND_PROBABILITY,ClientConfig.instance.trackUncaughtErrorsProbability);
         this._maxErrorsConfiguration = DynamicClientConfigManager.getConfiguration(UNCAUGHT_ERROR_CONFIG_NS,UNCAUGHT_ERROR_MAX,ClientConfig.instance.maxUncaughtErrorsPerSession);
         this._maxErrorsConfiguration.getChangedSignal().add(this.onMaxErrorsChanged);
         this.onMaxErrorsChanged();
         UncaughtErrorRelay.getUncaughtErrorReported().add(this.onUncaughtError);
         this.checkErrors();
      }
      
      private function trackAllErrors() : void
      {
         var _loc2_:UncaughtErrorDto = null;
         var _loc1_:Vector.<UncaughtErrorDto> = UncaughtErrorRelay.consumeErrors();
         for each(_loc2_ in _loc1_)
         {
            this.trackError(_loc2_);
         }
      }
      
      private function trimStackTraceLine(param1:String) : String
      {
         if(param1.indexOf("\tat ") == 0)
         {
            return param1.substr(4);
         }
         return param1;
      }
      
      private function onMaxErrorsChanged() : void
      {
         UncaughtErrorRelay.maxLifetimeErrors = this._maxErrorsConfiguration.getNumber();
      }
      
      private function extractStackTraceClass(param1:String) : String
      {
         var _loc2_:String = this.trimStackTraceLine(param1);
         var _loc3_:Array = _loc2_.split("/");
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            return _loc3_[0];
         }
         return _loc2_;
      }
      
      private function onUncaughtError() : void
      {
         this.checkErrors();
      }
      
      private function checkErrors() : void
      {
         if(this.currentProbability != this._probabilityConfiguration.getNumber())
         {
            this.currentProbability = this._probabilityConfiguration.getNumber();
            this.isEnabled = Math.random() < this.currentProbability;
            if(this.isEnabled)
            {
               this.logger.info("Uncaught Error logging is enabled.");
            }
         }
         if(this.isEnabled && Boolean(this._tracker.willTrack()))
         {
            this.trackAllErrors();
         }
      }
      
      private function trackError(param1:UncaughtErrorDto) : void
      {
         var _loc4_:Error = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:* = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:ErrorEvent = null;
         var _loc2_:Object = {};
         _loc2_.caught_by = param1.caughtBy;
         _loc2_.session_error_number = param1.sessionErrorNumber;
         var _loc3_:* = param1.errorObject;
         if(_loc3_ is Error)
         {
            _loc4_ = _loc3_ as Error;
            _loc2_.message = _loc4_.message;
            _loc5_ = _loc4_.getStackTrace();
            _loc2_.full_trace = _loc5_;
            _loc6_ = _loc5_.split("\n");
            if(_loc6_.length > 1)
            {
               _loc2_.error_location = this.trimStackTraceLine(_loc6_[1]);
               _loc2_.error_location_class = this.extractStackTraceClass(_loc6_[1]);
            }
            _loc7_ = false;
            _loc8_ = int(_loc6_.length - 1);
            while(_loc8_ >= 1)
            {
               _loc9_ = _loc6_[_loc8_];
               for each(_loc10_ in ENTRY_POINT_FILTER)
               {
                  if(_loc9_.indexOf(_loc10_) != -1)
                  {
                     _loc2_.entry_point = this.trimStackTraceLine(_loc9_);
                     _loc2_.entry_point_class = this.extractStackTraceClass(_loc6_[1]);
                     _loc7_ = true;
                     break;
                  }
               }
               if(_loc7_)
               {
                  break;
               }
               _loc8_--;
            }
         }
         else if(_loc3_ is ErrorEvent)
         {
            _loc11_ = _loc3_ as ErrorEvent;
            _loc2_.event_text = _loc11_.text;
         }
         else
         {
            _loc2_.to_string = _loc3_.toString();
         }
         this._tracker.track("front_end_iron_uncaught_error",_loc2_,false,this.currentProbability);
      }
   }
}

