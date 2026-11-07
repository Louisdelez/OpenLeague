package
{
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.RankedTeamsProvider;
   import com.riotgames.platform.gameclient.module.rt.controller.RTModuleStartupCommand;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import mx.modules.ModuleBase;
   
   public class ClientModuleRT extends ModuleBase implements IProviderModule
   {
      
      private var rtProvider:RankedTeamsProvider;
      
      public function ClientModuleRT()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         if(RTFacade.instance.rtProvider == null)
         {
            this.rtProvider = new RankedTeamsProvider();
            this.rtProvider.initialize(this.onRankedTeamsProviderInitialized);
         }
      }
      
      private function onRankedTeamsProviderInitialized() : void
      {
         RTFacade.instance.registerCommand(RTNotificationConstants.RT_MODULE_STARTUP,RTModuleStartupCommand);
         RTFacade.instance.sendNotification(RTNotificationConstants.RT_MODULE_STARTUP);
      }
   }
}

