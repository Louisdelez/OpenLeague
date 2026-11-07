package com.riotgames.platform.gameclient.module.rt
{
   import org.puremvc.as3.multicore.interfaces.IFacade;
   import org.puremvc.as3.multicore.patterns.observer.Notifier;
   
   public class RTNotifier extends Notifier
   {
      
      public function RTNotifier()
      {
         super();
      }
      
      override protected function get facade() : IFacade
      {
         return RTFacade.instance;
      }
      
      override public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         RTFacade.instance.sendNotification(param1,param2,param3);
      }
   }
}

