package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import blix.action.WaitAction;
   
   public class AsyncTimeoutAction extends WaitAction
   {
      
      public static const DEFAULT_TIMEOUT_DURATION:Number = 30000;
      
      private var _onSuspendTimeout:Function;
      
      private var _onTimeoutReached:Function;
      
      public function AsyncTimeoutAction(param1:Function, param2:Function)
      {
         this._onSuspendTimeout = param1;
         this._onTimeoutReached = param2;
         super(DEFAULT_TIMEOUT_DURATION,false,false);
      }
      
      override public function complete() : void
      {
         this._onTimeoutReached.call(this);
         super.complete();
      }
      
      override public function abort() : void
      {
         this._onSuspendTimeout.call(this);
         super.abort();
      }
   }
}

