package com.riotgames.pvpnet.docked.chat.view
{
   import blix.signals.ISignal;
   import flash.utils.getTimer;
   
   public class PulseAnimator
   {
      
      private var _lastFrame:uint;
      
      private var _counter:uint;
      
      private var _enterFrame:ISignal;
      
      private var _pulseUpDuration:int;
      
      private var _pulseDownDuration:int;
      
      private var _render:Function;
      
      public function PulseAnimator(param1:ISignal, param2:int, param3:int, param4:Function)
      {
         super();
         this._enterFrame = param1;
         this._pulseUpDuration = param2;
         this._pulseDownDuration = param3;
         this._render = param4;
      }
      
      public function start() : void
      {
         this._counter = 0;
         this._lastFrame = getTimer();
         this._enterFrame.add(this.update);
      }
      
      public function stop() : void
      {
         this._enterFrame.remove(this.update);
      }
      
      private function update() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:uint = uint(getTimer());
         var _loc2_:int = _loc1_ - this._lastFrame;
         this._lastFrame = _loc1_;
         this._counter += _loc2_;
         this._counter %= this._pulseUpDuration + this._pulseDownDuration;
         if(this._counter < this._pulseUpDuration)
         {
            _loc3_ = this._counter / this._pulseUpDuration;
         }
         else
         {
            _loc3_ = 1 - (this._counter - this._pulseUpDuration) / this._pulseDownDuration;
         }
         this._render(_loc3_);
      }
   }
}

