package com.riotgames.platform.gameclient.utils
{
   import blix.action.BasicAction;
   import blix.signals.Signal;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class WaitForAction extends BasicAction
   {
      
      private var _finishSignal:Signal = new Signal();
      
      private var _failSignal:Signal = new Signal();
      
      private var _parameters:Array;
      
      private var _message:String;
      
      private var _timeoutId:uint;
      
      private var _intervalId:uint;
      
      private var _timeout:int;
      
      private var _condition:Function;
      
      private var _interval:int;
      
      private var _startSignal:Signal = new Signal();
      
      private var _id:String;
      
      public function WaitForAction(param1:String, param2:Function, param3:Array, param4:int = 5000, param5:int = 30)
      {
         super(false);
         this._id = param1;
         this._condition = param2;
         this._parameters = param3;
         this._timeout = param4;
         this._interval = param5;
      }
      
      private function dispatchFailSignal() : void
      {
         this._failSignal.dispatch(this);
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function getStartSignal() : Signal
      {
         return this._startSignal;
      }
      
      public function getFinishSignal() : Signal
      {
         return this._finishSignal;
      }
      
      private function timeoutExceeded() : void
      {
         clearInterval(this._intervalId);
         this._message = "TIMEOUT for async operation with id: " + this._id + " after " + this._timeout + "ms.";
         this.dispatchFailSignal();
      }
      
      public function getFailSignal() : Signal
      {
         return this._failSignal;
      }
      
      private function dispatchStartSignal() : void
      {
         this._startSignal.dispatch(this);
         this._intervalId = setInterval(this.testCondition,this._interval);
         this._timeoutId = setTimeout(this.timeoutExceeded,this._timeout);
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      private function testCondition() : void
      {
         var result:Boolean = false;
         try
         {
            result = Boolean(this._condition.apply(null,this._parameters));
            if(result)
            {
               clearInterval(this._intervalId);
               this.dispatchFinishSignal();
            }
         }
         catch(e:Error)
         {
            clearInterval(_intervalId);
            _message = e.message;
            dispatchFailSignal();
            err(e);
         }
      }
      
      private function dispatchFinishSignal() : void
      {
         this._finishSignal.dispatch(this);
         clearTimeout(this._timeoutId);
         super.complete();
      }
      
      override protected function doInvocation() : void
      {
         this.dispatchStartSignal();
      }
   }
}

