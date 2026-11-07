package com.riotgames.pvpnet.tracking.trackers.client
{
   import com.riotgames.pvpnet.tracker.Tracker;
   
   public class ClientBehaviorTracker extends Tracker implements IClientBehaviorTracker
   {
      
      public static const LANDING_PAGE__URL_USED:String = "landing_page__url_used";
      
      public static const LANDING_PAGE__URL_USED_STATUS:String = "landing_page__url_used_status";
      
      public function ClientBehaviorTracker(param1:Boolean = true)
      {
         super("client_behavior",param1);
         isTimer = false;
         forceSend = true;
      }
      
      public function recordLandingPageURL(param1:String, param2:String) : void
      {
         var _loc3_:Object = getProperty(LANDING_PAGE__URL_USED);
         if(_loc3_ != param1)
         {
            setProperty(LANDING_PAGE__URL_USED,param1);
            setProperty(LANDING_PAGE__URL_USED_STATUS,param2);
            send();
         }
      }
   }
}

