package com.riotgames.platform.gameclient.init
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.shell.platformshutdown.PlatformShutdownDisplay;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import flash.desktop.NativeApplication;
   
   public class PlatformShutdownHandler
   {
      
      public function PlatformShutdownHandler(param1:IServerStatusProvider)
      {
         super();
         var _loc2_:PlatformShutdownDisplay = new PlatformShutdownDisplay(param1);
         _loc2_.getForcedShutdown().add(this.forceExitWithoutLogout);
         _loc2_.init();
      }
      
      private function forceExitWithoutLogout() : void
      {
         if(Session.instance.summoner == null)
         {
            UserPreferencesManager.instance.saveGlobalPreferences();
         }
         else
         {
            UserPreferencesManager.instance.saveUserPreferences(Session.instance.summoner.name);
         }
         NativeApplication.nativeApplication.exit();
      }
   }
}

