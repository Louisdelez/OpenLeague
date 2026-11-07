package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IReportingProvider extends IProvider
   {
      
      function setVar(param1:String) : void;
      
      function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : void;
      
      function trackPageview(param1:String = "") : void;
   }
}

