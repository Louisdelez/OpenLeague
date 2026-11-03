package com.riotgames.platform.common.services.login.queue
{
   import com.riotgames.platform.common.event.LoginQueueEvent;
   
   public class LoginQueueState
   {
      
      public var backlog:int = 0;
      
      public var isCapped:Boolean;
      
      public var user:String;
      
      public var queue:QueuePosition = new QueuePosition();
      
      public var client:QueuePosition = new QueuePosition();
      
      public var pollDelay:Number = 0;
      
      public var queueChampName:String;
      
      public var loginsPerSecond:int;
      
      public var queueDepth:int = -1;
      
      public var publishDelay:Number;
      
      public var depthDelta:int;
      
      public function LoginQueueState()
      {
         super();
      }
      
      public function getEstimatedSecondsLeft() : Number
      {
         return this.getEstimatedMillisLeft() / 1000;
      }
      
      public function getDepth() : int
      {
         if(this.queueDepth == -1)
         {
            this.queueDepth = this.calculateDepth(this.queue);
         }
         return this.queueDepth;
      }
      
      public function getEstimatedMillisLeft() : Number
      {
         var _loc1_:int = this.getDepth() + this.queue.backlog;
         var _loc2_:Number = 1000 * _loc1_ / this.loginsPerSecond;
         var _loc3_:Number = new Date().getTime() - this.queue.timestamp.getTime();
         var _loc4_:Number = _loc2_ - _loc3_;
         return Math.max(_loc4_,0);
      }
      
      private function getQueueNodes(param1:QueuePosition) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Object = {};
         this.collectKeys(_loc2_,_loc3_,this.client.positions);
         this.collectKeys(_loc2_,_loc3_,param1.positions);
         return _loc2_;
      }
      
      public function createStatusEvent(param1:int, param2:int) : LoginQueueEvent
      {
         return new LoginQueueEvent(this.getDepth(),this.queue.timestamp,this.loginsPerSecond,this.getEstimatedMillisLeft(),param1,this.isCapped,param2);
      }
      
      public function calculateDepth(param1:QueuePosition) : int
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         if(this.client != null && param1 != null)
         {
            _loc3_ = this.getQueueNodes(param1);
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = param1.positions[_loc4_] == null ? 0 : int(param1.positions[_loc4_]);
               _loc6_ = this.client.positions[_loc4_] == null ? _loc5_ : int(this.client.positions[_loc4_]);
               _loc2_ += Math.max(0,_loc6_ - _loc5_);
            }
         }
         return _loc2_;
      }
      
      private function collectKeys(param1:Array, param2:Object, param3:Object) : void
      {
         var _loc4_:String = null;
         for(_loc4_ in param3)
         {
            if(param2[_loc4_] == undefined)
            {
               param1[param1.length] = _loc4_;
               param2[_loc4_] = true;
            }
         }
      }
   }
}

