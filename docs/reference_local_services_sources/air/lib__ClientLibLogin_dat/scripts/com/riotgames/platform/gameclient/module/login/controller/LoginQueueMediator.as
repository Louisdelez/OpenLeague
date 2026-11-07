package com.riotgames.platform.gameclient.module.login.controller
{
   import com.riotgames.platform.common.event.LoginQueueEvent;
   import com.riotgames.platform.gameclient.module.login.view.ILoginQueueView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LoginQueueMediator extends EventDispatcher
   {
      
      public static const EVENT_QUEUE_CANCEL:String = "LoginQueueMediator_Cancel";
      
      public static const EVENT_QUEUE_SHOW_COUNTDOWN:String = "LoginQueueMediator_ShowCountdown";
      
      public static const EVENT_QUEUE_REQUEST_POLL:String = "LoginQueueMediator_RequestPoll";
      
      private static const HIDDEN_QUEUE_MILLIS_END:int = 10000;
      
      private static const HIDDEN_QUEUE_POP_TIME:int = 3000;
      
      private static const CONSERVATIVE_TIME_ESTIMATE_FACTOR:Number = 0.9;
      
      private static const CONSERVATIVE_POSITION_ESTIMATE_FACTOR:Number = 0.7;
      
      private static const HOUR:int = 3600;
      
      private static const MINUTE:int = 60;
      
      private static const INITIAL_POSITION:int = 1000000;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var messageKey:String;
      
      private var nextUpdate:Number;
      
      private var lastEstimate:Number;
      
      private var hiddenQueueDisabled:Boolean = false;
      
      private var lastOfficialPosition:int;
      
      private var gracePeriodTimer:Timer;
      
      private var loginQueueView:ILoginQueueView;
      
      private var lastDisplayedPosition:int;
      
      private var lastUpdate:Number;
      
      public function LoginQueueMediator(param1:ILoginQueueView)
      {
         super();
         this.loginQueueView = param1;
         this.lastOfficialPosition = this.lastDisplayedPosition = INITIAL_POSITION;
         this.lastEstimate = 0;
         this.lastUpdate = new Date().time;
      }
      
      private function handleQuitQueue() : void
      {
         this.hide();
      }
      
      public function hide() : void
      {
         if(this.loginQueueView.showingLoginQueueView)
         {
            this.loginQueueView.hideLoginQueueView();
            dispatchEvent(new Event(EVENT_QUEUE_CANCEL));
         }
         this.lastDisplayedPosition = INITIAL_POSITION;
         this.lastEstimate = 0;
         this.lastUpdate = new Date().time;
         if(this.gracePeriodTimer != null && this.gracePeriodTimer.running)
         {
            this.gracePeriodTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handleGracePeriodComplete);
            this.gracePeriodTimer.stop();
            this.gracePeriodTimer = null;
         }
      }
      
      public function showAuthSuccess() : void
      {
         this.loginQueueView.showAuthSuccess();
      }
      
      private function getDepth(param1:LoginQueueEvent) : int
      {
         var _loc2_:int = int(param1.depth);
         if(_loc2_ == 0)
         {
            return 0;
         }
         return _loc2_;
      }
      
      private function updateLoginQueueView(param1:Number, param2:int, param3:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = param3 / 1000;
         if(_loc4_ < 60)
         {
            this.loginQueueView.updateLoginQueueViewForSeconds(param1,param2,_loc4_);
         }
         else
         {
            _loc5_ = _loc4_ / HOUR;
            _loc4_ -= _loc5_ * HOUR;
            _loc6_ = _loc4_ / MINUTE;
            _loc4_ -= _loc6_ * MINUTE;
            if(_loc5_ > 3)
            {
               this.loginQueueView.updateLoginQueueViewForIndefinite(param1,param2);
            }
            else if(_loc5_ > 0)
            {
               this.loginQueueView.updateLoginQueueViewForHours(param1,param2,_loc5_,_loc6_);
            }
            else
            {
               this.loginQueueView.updateLoginQueueViewForMinutes(param1,param2,_loc6_,_loc4_);
            }
         }
      }
      
      public function updateStatus(param1:LoginQueueEvent) : void
      {
         if(this.hiddenQueueDisabled || this.loginQueueView.showingLoginQueueView || param1.millisLeft > HIDDEN_QUEUE_MILLIS_END)
         {
            this.updateCountdownStatus(param1);
         }
         else if(this.gracePeriodTimer == null)
         {
            this.gracePeriodTimer = new Timer(HIDDEN_QUEUE_MILLIS_END + HIDDEN_QUEUE_POP_TIME,1);
            this.gracePeriodTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleGracePeriodComplete,false,0,true);
            this.gracePeriodTimer.start();
         }
         else if(this.gracePeriodTimer != null && !this.gracePeriodTimer.running)
         {
            this.updateCountdownStatus(param1);
         }
      }
      
      private function updateTimeRemaining() : void
      {
         var _loc1_:Number = new Date().time;
         var _loc2_:Number = _loc1_ - this.lastUpdate;
         var _loc3_:Number = _loc2_ / (this.nextUpdate - this.lastUpdate);
         var _loc4_:Number = Math.min(Math.max(_loc3_,0),1);
         var _loc5_:Number = this.lastEstimate;
         if(_loc2_ > 0)
         {
            _loc5_ -= CONSERVATIVE_TIME_ESTIMATE_FACTOR * _loc2_;
         }
         _loc5_ = Math.max(_loc5_,1000);
         var _loc6_:Number = CONSERVATIVE_POSITION_ESTIMATE_FACTOR * (this.lastOfficialPosition / this.lastEstimate);
         var _loc7_:int = Math.ceil(this.lastOfficialPosition - _loc6_ * _loc2_);
         _loc7_ = Math.max(_loc7_,1);
         _loc7_ = Math.min(_loc7_,this.lastDisplayedPosition);
         this.lastDisplayedPosition = _loc7_;
         this.updateLoginQueueView(_loc4_,_loc7_,_loc5_);
      }
      
      private function handleGracePeriodComplete(param1:TimerEvent) : void
      {
         this.gracePeriodTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handleGracePeriodComplete);
         dispatchEvent(new Event(EVENT_QUEUE_REQUEST_POLL));
      }
      
      private function updateCountdownStatus(param1:LoginQueueEvent) : void
      {
         var _loc3_:Number = NaN;
         if(this.gracePeriodTimer != null && this.gracePeriodTimer.running)
         {
            this.gracePeriodTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handleGracePeriodComplete);
            this.gracePeriodTimer.stop();
         }
         if(!this.loginQueueView.showingLoginQueueView)
         {
            this.loginQueueView.showLoginQueueView(param1.isCapped,this.updateTimeRemaining,this.handleQuitQueue);
            dispatchEvent(new Event(EVENT_QUEUE_SHOW_COUNTDOWN));
         }
         this.lastOfficialPosition = this.getDepth(param1);
         var _loc2_:Number = Number(param1.millisLeft);
         if(param1.delta == 0)
         {
            _loc3_ = Math.max(0,param1.timestamp.getTime() - this.lastUpdate);
            _loc2_ = this.lastEstimate + _loc3_;
         }
         this.lastUpdate = new Date().time;
         this.lastEstimate = _loc2_;
         if(param1.nextUpdate > 0)
         {
            this.nextUpdate = this.lastUpdate + param1.nextUpdate;
         }
         this.updateTimeRemaining();
      }
   }
}

