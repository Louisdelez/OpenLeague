package com.riotgames.platform.gameclient.shutdown
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChineseAntiIndulgenceLaw
   {
      
      private var antiIndulgenceTimer:Timer;
      
      public function ChineseAntiIndulgenceLaw()
      {
         super();
      }
      
      private function updateAntiIndulgenceMessage(param1:AntiIndulgenceMessage, param2:AntiIndulgenceMessage) : void
      {
         var _loc3_:Boolean = param1 != null && param2 != null;
         if(_loc3_ && !param2.isRegistrationMessage)
         {
            if(this.antiIndulgenceTimer != null)
            {
               this.antiIndulgenceTimer.stop();
               this.antiIndulgenceTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onAntiIndulgenceTimerComplete);
               this.antiIndulgenceTimer = null;
            }
         }
         if(param2 != null)
         {
            this.addToTicker(param2);
            this.antiIndulgenceTimer = new Timer(60000,1);
            this.antiIndulgenceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAntiIndulgenceTimerComplete);
            this.antiIndulgenceTimer.start();
         }
      }
      
      private function onAntiIndulgenceTimerComplete(param1:TimerEvent) : void
      {
         AppConfig.instance.antiIndulgenceMessage = null;
      }
      
      private function addToTicker(param1:AntiIndulgenceMessage) : void
      {
         var _loc2_:BroadcastMessage = new BroadcastMessage();
         _loc2_.severity = AppConfig.instance.legacyPopupSupport ? "WARN" : "ERROR";
         _loc2_.messageKey = param1.messageKey;
         _loc2_.expiryTime = 60000;
         _loc2_.content = RiotResourceLoader.getString(_loc2_.messageKey,null,[param1.messageArgument]);
         ServerStatusProviderProxy.instance.addLocalMessage(_loc2_);
      }
      
      public function apply() : void
      {
         AppConfig.instance.antiIndulgenceMessageChanged.add(this.updateAntiIndulgenceMessage);
         this.updateAntiIndulgenceMessage(null,AppConfig.instance.antiIndulgenceMessage);
      }
   }
}

