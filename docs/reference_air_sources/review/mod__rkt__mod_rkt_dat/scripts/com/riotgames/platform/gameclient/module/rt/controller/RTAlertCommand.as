package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTAlertCommand extends RTSimpleCommand
   {
      
      public static const ALERT:String = "ALERT";
      
      public function RTAlertCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AlertAction = new AlertAction(RTResource.getString("manageHeader"),String(param1.getBody()));
         _loc2_.add();
      }
   }
}

