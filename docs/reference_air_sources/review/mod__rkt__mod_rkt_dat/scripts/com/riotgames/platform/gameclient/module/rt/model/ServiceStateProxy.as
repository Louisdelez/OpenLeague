package com.riotgames.platform.gameclient.module.rt.model
{
   import com.riotgames.platform.common.event.ServerWaitEvent;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.events.PropertyChangeEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class ServiceStateProxy extends Proxy implements IEventDispatcher
   {
      
      public static const NAME:String = "ServiceStateProxy";
      
      private static const MAX_BUSY_TIME:Number = 10;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _callCount:int = 0;
      
      private var _isBusy:Boolean = false;
      
      private var failSafeTimer:Timer = null;
      
      public function ServiceStateProxy(param1:String = "ServiceStateProxy", param2:Object = null)
      {
         super(param1,param2);
      }
      
      private static function get shellDispatcher() : ShellDispatcher
      {
         return RTFacade.instance.rtProvider.shellDispatcher;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      [Bindable(event="propertyChange")]
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this.isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
         }
      }
      
      private function onFailSafeTimerComplete(param1:TimerEvent) : void
      {
         this.callCount = 0;
      }
      
      private function get callCount() : int
      {
         return this._callCount;
      }
      
      public function onServiceCall() : void
      {
         ++this.callCount;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function set _1180619197isBusy(param1:Boolean) : void
      {
         if(param1 == this._isBusy)
         {
            return;
         }
         this._isBusy = param1;
         if(this.failSafeTimer != null)
         {
            this.failSafeTimer.stop();
            this.failSafeTimer = null;
         }
         if(this.isBusy == true)
         {
            this.failSafeTimer = new Timer(1000 * MAX_BUSY_TIME,1);
            this.failSafeTimer.addEventListener(TimerEvent.TIMER,this.onFailSafeTimerComplete);
         }
         shellDispatcher.dispatchEvent(new ServerWaitEvent(this.isBusy ? ServerWaitEvent.SHOW : ServerWaitEvent.HIDE));
      }
      
      private function set callCount(param1:int) : void
      {
         this._callCount = param1;
         if(this.callCount < 0)
         {
            this.callCount = 0;
         }
         this.isBusy = this.callCount > 0;
      }
      
      public function onServiceCallComplete() : void
      {
         --this.callCount;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

