package com.riotgames.pvpnet.tracking.services
{
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.common.utils.IServiceLogger;
   import com.riotgames.platform.common.utils.ServiceInvocation;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class DradisServiceLoggerTarget implements IServiceLogger
   {
      
      private var config:ClientConfig;
      
      private var loggedRequests:Vector.<ServiceRequestLogItem> = new Vector.<ServiceRequestLogItem>();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var isEnabled:Boolean = false;
      
      private var _tracker:IMetricsProvider;
      
      private var currentProbability:Number = -1;
      
      public function DradisServiceLoggerTarget(param1:IMetricsProvider)
      {
         super();
         this._tracker = param1;
         this.config = ClientConfig.instance;
      }
      
      private function trackRequestResponseTiming(param1:String, param2:Object) : void
      {
         var _loc3_:ServiceRequestLogItem = null;
         var _loc4_:ServiceRequestLogItem = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:ServiceRequestLogItem = null;
         if(param1 == ServiceInvocation.LCDS_REQUEST || param1 == ServiceInvocation.REST_REQUEST)
         {
            _loc3_ = new ServiceRequestLogItem(param1,param2.service,param2.method,getTimer());
            for each(_loc4_ in this.loggedRequests)
            {
               if(_loc4_.equals(_loc3_))
               {
                  return;
               }
            }
            this.loggedRequests.push(_loc3_);
         }
         else if(param1 == ServiceInvocation.RESPONSE || param1 == ServiceInvocation.REST_RESPONSE || param1 == ServiceInvocation.FAULT || param1 == ServiceInvocation.REST_FAULT)
         {
            _loc5_ = NaN;
            _loc6_ = getTimer();
            for each(_loc7_ in this.loggedRequests)
            {
               if(_loc7_.method == param2.method && _loc7_.service == param2.service)
               {
                  _loc5_ = _loc6_ - _loc7_.requestTimestamp;
                  this.loggedRequests.splice(this.loggedRequests.indexOf(_loc7_),1);
                  break;
               }
            }
            if(!isNaN(_loc5_))
            {
               param2.responseTime = _loc5_;
            }
         }
      }
      
      public function addInvocation(param1:String, param2:String, param3:String, param4:Array = null) : void
      {
         var data:Object = null;
         var bytes:ByteArray = null;
         var type:String = param1;
         var service:String = param2;
         var method:String = param3;
         var args:Array = param4;
         if(!this.config)
         {
            return;
         }
         if(this.currentProbability != this.config.trackServiceTrafficProbability)
         {
            this.currentProbability = this.config.trackServiceTrafficProbability;
            this.isEnabled = Math.random() < this.currentProbability;
            if(this.isEnabled)
            {
               this.logger.info("Service logging is enabled.");
            }
         }
         if(this.isEnabled && Boolean(this._tracker.willTrack()))
         {
            data = {};
            data.service = service;
            data.method = method;
            this.trackRequestResponseTiming(type,data);
            bytes = new ByteArray();
            if(args)
            {
               try
               {
                  bytes.writeObject(args);
                  data.size = bytes.length;
               }
               catch(e:Error)
               {
                  data.size = -1;
               }
            }
            this._tracker.track("service." + type,data,false,this.currentProbability);
         }
      }
   }
}

class ServiceRequestLogItem
{
   
   public var method:String;
   
   public var service:String;
   
   public var requestTimestamp:int;
   
   public var type:String;
   
   public function ServiceRequestLogItem(param1:String, param2:String, param3:String, param4:int)
   {
      super();
      this.type = param1;
      this.service = param2;
      this.method = param3;
      this.requestTimestamp = param4;
   }
   
   public function equals(param1:ServiceRequestLogItem) : Boolean
   {
      return this.service == param1.service && this.method == param1.method;
   }
}
