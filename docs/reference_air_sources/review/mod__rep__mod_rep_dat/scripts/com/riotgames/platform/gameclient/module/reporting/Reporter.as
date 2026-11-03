package com.riotgames.platform.gameclient.module.reporting
{
   import com.google.analytics.GATracker;
   import com.riotgames.platform.common.provider.IReportingProvider;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import mx.core.Application;
   
   public class Reporter implements IReportingProvider
   {
      
      private var _sessionInSample:Boolean;
      
      private var _sampleRate:int;
      
      private var _tracker:GATracker;
      
      private var _isReady:Boolean;
      
      public function Reporter()
      {
         super();
         this.initializeReporter();
      }
      
      public function setVar(param1:String) : void
      {
         if(this._isReady && this._sessionInSample)
         {
            this._tracker.setVar(param1);
         }
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : void
      {
         if(this._isReady && this._sessionInSample && Boolean(this._tracker))
         {
            this._tracker.trackEvent(param1,param2,param3,param4);
         }
      }
      
      private function initializeReporter() : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc1_:String = ClientConfig.instance.regionTag;
         if(ClientConfig.instance.localePrefix == "ko")
         {
            _loc2_ = "UA-27602504-1";
         }
         else
         {
            switch(_loc1_)
            {
               case "na":
                  _loc2_ = "UA-27606903-1";
                  break;
               case "euw":
                  _loc2_ = "UA-27029421-1";
                  break;
               case "eune":
                  _loc2_ = "UA-27037215-1";
            }
         }
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            this._tracker = new GATracker(ApplicationUtil.application as Application,_loc2_);
            this._tracker.setDomainName("none");
            this._tracker.setDetectTitle(false);
            this._tracker.visualDebug = true;
            this._sampleRate = ClientConfig.instance.reportingSampleRate;
            _loc3_ = Math.random() * this._sampleRate;
            this._sessionInSample = _loc3_ <= 1;
            this._isReady = true;
         }
      }
      
      private function setDomainName(param1:String = "none") : void
      {
         if(this._tracker)
         {
            this._tracker.setDomainName(param1);
         }
      }
      
      public function trackPageview(param1:String = "") : void
      {
         if(this._isReady && this._sessionInSample && Boolean(this._tracker))
         {
            this._tracker.trackPageview(param1);
         }
      }
   }
}

