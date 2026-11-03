package com.riotgames.pvpnet.system.alerter
{
   public class AlertWaitAction extends AlertAction
   {
      
      public var showDelay:int = -1;
      
      public var showNegativeDelay:int = 15000;
      
      public function AlertWaitAction(param1:String, param2:String)
      {
         super(param1,param2);
         showAffirmative = false;
         showNegative = false;
      }
   }
}

