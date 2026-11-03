package com.riotgames.platform.common.services.login.queue
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.LoginQueueEvent;
   import com.riotgames.platform.common.services.ILoginQueueMonitor;
   import com.riotgames.platform.common.services.PollingService;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   public class PollingLoginQueueMonitor implements ILoginQueueMonitor
   {
      
      private var disconnectCallback:Function;
      
      private var pollRetries:int = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var model:LoginQueueState;
      
      private var poller:PollingService;
      
      public var config:RiotServiceConfig;
      
      private var pollTimer:Timer;
      
      private var _queueId:String;
      
      private var listeners:Array = new Array();
      
      private var running:Boolean;
      
      private var lastUpdate:Number;
      
      public function PollingLoginQueueMonitor(param1:String)
      {
         super();
         this._queueId = param1;
      }
      
      public static function getPollIntervalForEstimatedSecondsLeft(param1:int) : int
      {
         if(param1 <= 15)
         {
            return Math.max(param1 * 1000,3000);
         }
         if(param1 <= 30)
         {
            return 15000;
         }
         if(param1 <= 60)
         {
            return 30000;
         }
         if(param1 <= 120)
         {
            return 45000;
         }
         return 90000;
      }
      
      private function updateQueuePosition(param1:QueuePosition) : void
      {
         var _loc2_:Number = this.model.queue.timestamp.getTime();
         var _loc3_:Number = param1.timestamp.getTime();
         var _loc4_:Number = _loc3_ - _loc2_;
         var _loc5_:int = this.model.backlog - param1.backlog;
         this.model.backlog = param1.backlog;
         var _loc6_:int = this.model.calculateDepth(param1);
         this.model.queueDepth = _loc6_;
         var _loc7_:int = this.model.getDepth() - _loc6_;
         _loc7_ += _loc5_;
         this.model.depthDelta = _loc7_;
         var _loc8_:int = _loc7_ * 1000 / _loc4_;
         if(_loc8_ == 0)
         {
            _loc8_ = this.model.loginsPerSecond;
         }
         this.model.loginsPerSecond = _loc8_;
         this.model.queue = param1;
         this.dispatchPositionChanged(this.model.createStatusEvent(_loc7_,this.getPollInterval()));
      }
      
      private function stopAndSignalBusy() : void
      {
         this.running = false;
         var _loc1_:Fault = new Fault("Status","BUSY",null);
         var _loc2_:FaultEvent = new FaultEvent("Status",false,false,_loc1_,null,null);
         this.disconnectCallback(_loc2_);
      }
      
      public function disconnect() : void
      {
         this.running = false;
         this.model = null;
         this.clearTimer();
      }
      
      private function get pollingServiceURL() : String
      {
         var _loc1_:String = this.config.lq_uri.value + "/login-queue/rest/queues/" + this._queueId + "/ticker";
         if(this.model.queueChampName != null)
         {
            _loc1_ += "/" + this.model.queueChampName;
         }
         return _loc1_;
      }
      
      private function logError(param1:String, param2:Error) : void
      {
         var _loc3_:String = param1 + " " + param2.name + " #" + param2.errorID + ": " + param2.message + "\n" + param2.getStackTrace();
         this.logger.error(_loc3_);
      }
      
      private function clearTimer() : void
      {
         if(Boolean(this.pollTimer))
         {
            this.pollTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.poll);
            this.pollTimer.stop();
            this.pollTimer = null;
         }
      }
      
      public function getPollInterval() : int
      {
         return getPollIntervalForEstimatedSecondsLeft(this.getEstimatedTimeLeft());
      }
      
      private function parseTicker(param1:String) : QueuePosition
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Object = jsonDecode(param1);
         if(_loc2_["status"] == "BUSY")
         {
            this.stopAndSignalBusy();
            return null;
         }
         var _loc3_:QueuePosition = new QueuePosition();
         for(_loc4_ in _loc2_)
         {
            if(_loc4_ == "backlog")
            {
               _loc3_.backlog = _loc2_["backlog"];
            }
            else
            {
               _loc5_ = "n-" + _loc4_;
               _loc3_.positions[_loc5_] = parseInt(_loc2_[_loc4_],16);
            }
         }
         return _loc3_;
      }
      
      private function getEstimatedTimeLeft() : int
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:Number = new Date().getTime();
         var _loc2_:int = this.model.getEstimatedSecondsLeft();
         if(this.model.depthDelta == 0 && !isNaN(this.lastUpdate))
         {
            _loc3_ = this.model.pollDelay;
            _loc4_ = _loc1_ - this.lastUpdate;
            _loc5_ = _loc3_ + _loc4_;
            this.model.pollDelay = _loc5_;
            _loc2_ += _loc5_ / 1000;
         }
         else
         {
            this.model.pollDelay = 0;
         }
         return _loc2_;
      }
      
      private function logFault(param1:String, param2:Event) : void
      {
         var _loc3_:FaultEvent = param2 as FaultEvent;
         var _loc4_:String = param1 + _loc3_.fault.faultString + ": " + _loc3_.fault.faultCode + ": " + _loc3_.fault.faultDetail;
         this.logger.error(_loc4_);
      }
      
      private function onPollReceived(param1:Event) : void
      {
         var result:String = null;
         var msg:String = null;
         var position:QueuePosition = null;
         var event:Event = param1;
         if(event is ResultEvent)
         {
            result = (event as ResultEvent).result as String;
            try
            {
               if(result == null)
               {
                  msg = "PollingLoginQueueMonitor.onPollReceived: Error: null result string";
                  this.logger.error(msg);
                  this.retryPolling(msg);
               }
               else
               {
                  position = this.parseTicker(result);
                  if(this.running)
                  {
                     this.updateQueuePosition(position);
                  }
                  if(this.running)
                  {
                     this.scheduleUpdate();
                  }
               }
            }
            catch(error:Error)
            {
               logError("PollingLoginQueueMonitor.onPollReceived: Error parsing result " + result,error);
               retryPolling(error);
            }
         }
         else if(event is FaultEvent)
         {
            this.logFault("PollingLoginQueueMonitor.onPollReceived: Error getting ticker status: ",event);
            this.retryPolling(event);
         }
      }
      
      private function scheduleUpdate() : Number
      {
         this.pollRetries = 0;
         var _loc1_:Number = this.getPollInterval();
         this.setPollTimeout(_loc1_);
         this.lastUpdate = new Date().getTime();
         return _loc1_;
      }
      
      public function removeQueueListener(param1:Function) : void
      {
         var _loc2_:int = this.listeners.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.listeners.splice(_loc2_,1);
         }
      }
      
      public function addQueueListener(param1:Function) : void
      {
         this.listeners[param1.length] = param1;
      }
      
      public function forcePoll() : void
      {
         this.poll();
      }
      
      private function poll(param1:TimerEvent = null) : void
      {
         this.clearTimer();
         if(this.running)
         {
            this.poller.pollingServiceURL = this.pollingServiceURL;
            this.poller.startPolling(this.onPollReceived,this.onPollReceived);
         }
      }
      
      private function setPollTimeout(param1:Number) : void
      {
         this.clearTimer();
         this.pollTimer = new Timer(param1,1);
         this.pollTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.poll);
         this.pollTimer.start();
      }
      
      public function set pollingService(param1:PollingService) : void
      {
         this.poller = param1;
      }
      
      public function connect(param1:LoginQueueState, param2:Function) : void
      {
         if(!this.running)
         {
            this.running = true;
            this.model = param1;
            this.disconnectCallback = param2;
            this.scheduleUpdate();
         }
      }
      
      public function clearListeners() : void
      {
         this.listeners.splice(0,this.listeners.length);
      }
      
      public function dispatchPositionChanged(param1:LoginQueueEvent) : void
      {
         var _loc2_:Function = null;
         if(this.running)
         {
            for each(_loc2_ in this.listeners)
            {
               _loc2_(param1);
            }
         }
      }
      
      private function retryPolling(param1:Object) : void
      {
         if(this.pollRetries < 5)
         {
            ++this.pollRetries;
            this.setPollTimeout(5000);
         }
         else
         {
            this.disconnectCallback(param1);
         }
      }
   }
}

