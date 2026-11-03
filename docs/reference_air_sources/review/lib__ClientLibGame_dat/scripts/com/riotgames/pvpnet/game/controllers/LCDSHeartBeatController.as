package com.riotgames.pvpnet.game.controllers
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class LCDSHeartBeatController
   {
      
      private static const MINIMUM_HEARTBEAT:int = 60000;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var session:Session = Session.instance;
      
      private var _heartBeatTimer:Timer;
      
      private var _heartbeatIntervalMilliseconds:int = 60000;
      
      private var _heartBeatCount:int = 0;
      
      private var _resetHeartBeat:Boolean = false;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function LCDSHeartBeatController()
      {
         super();
         AppConfig.instance.loggingOutChanged.add(this.onLoggingOut);
         PlatformConfigProviderProxy.instance.getPlatformConfig().clientHeartBeatRateSecondsChanged.add(this.onClientHeartBeatRateSecondsChanged);
         PlatformConfigProviderProxy.instance.getPlatformConfig().clientHeartBeatRateSecondsSet.addOnce(this.onClientHeartBeatRateSecondsChanged);
      }
      
      private function onLoggingOut() : void
      {
         if(AppConfig.instance.loggingOut)
         {
            this.stop();
         }
      }
      
      private function onClientHeartBeatRateSecondsChanged(param1:int) : void
      {
         this._heartbeatIntervalMilliseconds = param1 * 1000;
         this.start();
      }
      
      private function start() : void
      {
         if(!this.isRunning() && this._heartbeatIntervalMilliseconds > 0)
         {
            this._heartbeatIntervalMilliseconds = Math.max(this._heartbeatIntervalMilliseconds,MINIMUM_HEARTBEAT);
            this.makeHeartBeat();
            this.stop();
            this._heartBeatTimer = new Timer(this._heartbeatIntervalMilliseconds);
            this._heartBeatTimer.addEventListener(TimerEvent.TIMER,this.heartBeatTimerHandler);
            this._heartBeatTimer.start();
         }
         else if(this._heartbeatIntervalMilliseconds <= 0)
         {
            this.stop();
         }
         else
         {
            this._resetHeartBeat = true;
         }
      }
      
      private function stop() : void
      {
         if(Boolean(this._heartBeatTimer))
         {
            this._heartBeatTimer.removeEventListener(TimerEvent.TIMER,this.heartBeatTimerHandler);
            if(this._heartBeatTimer.running)
            {
               this._heartBeatTimer.stop();
            }
         }
         this._heartBeatTimer = null;
      }
      
      public function isRunning() : Boolean
      {
         if(Boolean(this._heartBeatTimer))
         {
            return this._heartBeatTimer.running;
         }
         return false;
      }
      
      public function validatePlatformConnection(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Date = new Date();
         var _loc5_:String = _loc4_.toDateString() + " " + _loc4_.toTimeString();
         this.serviceProxy.loginService.performLCDSHeartBeat(this.session.accountSummary.accountId,this.session.token,this._heartBeatCount,_loc5_,param1,param2,param3);
      }
      
      private function heartBeatTimerHandler(param1:TimerEvent) : void
      {
         if(this._resetHeartBeat)
         {
            this._resetHeartBeat = false;
            this.stop();
            this.start();
            return;
         }
         this.makeHeartBeat();
      }
      
      private function makeHeartBeat() : void
      {
         ++this._heartBeatCount;
         var _loc1_:Date = new Date();
         var _loc2_:String = _loc1_.toDateString() + " " + _loc1_.toTimeString();
         this.serviceProxy.loginService.performLCDSHeartBeat(this.session.accountSummary.accountId,this.session.token,this._heartBeatCount,_loc2_,this.handleHeartBeatSuccess,null,this.handleHeartBeatError);
      }
      
      private function handleHeartBeatSuccess(param1:ResultEvent) : void
      {
      }
      
      private function handleHeartBeatError(param1:ServerError) : void
      {
      }
   }
}

