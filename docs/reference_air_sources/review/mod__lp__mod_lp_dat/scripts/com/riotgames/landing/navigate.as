package com.riotgames.landing
{
   import blix.context.IContext;
   import com.riotgames.landing.analytics.trackEvent;
   import com.riotgames.util.logging.getLogger;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import mx.logging.ILogger;
   
   public function navigate(param1:IContext, param2:URLRequest) : void
   {
      var _loc5_:String = null;
      var _loc3_:ILandingPageContext = param1.getFirstContext(ILandingPageContext);
      if(_loc3_ == null)
      {
         throw new Error("Must be in an ILandingPageContext");
      }
      if(param2 == null)
      {
         return;
      }
      var _loc4_:ILogger = getLogger(param1);
      if(_loc4_ != null)
      {
         _loc4_.info("navigate: " + param2.url);
      }
      if(param2.url.substr(0,12).toLowerCase() == "airnavigate:")
      {
         _loc5_ = param2.url.substr(12);
         _loc3_.navigateViaJson(_loc5_);
      }
      else
      {
         trackEvent(param1,"Link External Click",param2.url);
         navigateToURL(param2);
      }
   }
}

