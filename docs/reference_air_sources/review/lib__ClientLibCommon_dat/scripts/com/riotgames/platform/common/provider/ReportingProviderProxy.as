package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class ReportingProviderProxy extends ProviderProxyBase implements IReportingProvider
   {
      
      private static var _instance:ReportingProviderProxy;
      
      public function ReportingProviderProxy()
      {
         super(ReportingProviderProxy);
      }
      
      public static function get instance() : ReportingProviderProxy
      {
         if(_instance == null)
         {
            _instance = new ReportingProviderProxy();
         }
         return _instance;
      }
      
      public function setVar(param1:String) : void
      {
         _invoke("setVar",[param1]);
      }
      
      public function trackPageview(param1:String = "") : void
      {
         _invoke("trackPageview",[param1]);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : void
      {
         _invoke("trackEvent",[param1,param2,param3,param4]);
      }
   }
}

