package com.riotgames.landing.analytics
{
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IReportingProvider;
   import com.riotgames.platform.common.provider.ReportingProviderProxy;
   
   public function trackEvent(param1:IContext, param2:String, param3:String = "", param4:Number = NaN) : Boolean
   {
      var _loc5_:IReportingProvider = ReportingProviderProxy.instance;
      _loc5_.trackEvent("Landing Page",param2,param3,param4);
      return true;
   }
}

