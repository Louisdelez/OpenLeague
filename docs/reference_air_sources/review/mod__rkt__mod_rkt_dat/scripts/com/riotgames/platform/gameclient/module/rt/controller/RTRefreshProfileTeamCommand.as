package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTRefreshProfileTeamCommand extends RTSimpleCommand
   {
      
      public static const REFRESH:String = "REFRESH";
      
      public function RTRefreshProfileTeamCommand()
      {
         super();
      }
      
      public function get profileTeamProxy() : ProfileTeamProxy
      {
         return facade.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         this.profileTeamProxy.refresh();
      }
   }
}

