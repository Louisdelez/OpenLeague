package com.riotgames.pvpnet.chrome.metrics
{
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class TickerUsageTracker extends SessionTimeframedTracker
   {
      
      internal static const MESSAGE_CLICK_COUNT:String = "message_click.count";
      
      internal static const CLOSE_CLICK_COUNT:String = "close_click.count";
      
      internal static const SHOW_CLICK_COUNT:String = "show_click.count";
      
      internal static const HIDE_CLICK_COUNT:String = "hide_click.count";
      
      internal static const STATUS_REFRESH_COUNT:String = "status_refresh.count";
      
      public function TickerUsageTracker()
      {
         super("ticker_usage");
         setCounterValue(MESSAGE_CLICK_COUNT);
         setCounterValue(CLOSE_CLICK_COUNT);
         setCounterValue(SHOW_CLICK_COUNT);
         setCounterValue(HIDE_CLICK_COUNT);
         setCounterValue(STATUS_REFRESH_COUNT);
         ServerStatusProviderProxy.instance.getStatusRefreshed().add(this.statusRefreshed);
      }
      
      public function onMessageClick() : void
      {
         incrementCounter(MESSAGE_CLICK_COUNT);
      }
      
      public function onCloseClick() : void
      {
         incrementCounter(CLOSE_CLICK_COUNT);
      }
      
      public function onShowClick() : void
      {
         incrementCounter(SHOW_CLICK_COUNT);
      }
      
      public function onHideClick() : void
      {
         incrementCounter(HIDE_CLICK_COUNT);
      }
      
      private function statusRefreshed() : void
      {
         incrementCounter(STATUS_REFRESH_COUNT);
      }
   }
}

