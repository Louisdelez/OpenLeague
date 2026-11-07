package com.riotgames.platform.gameclient.init
{
   import blix.action.IAction;
   import blix.action.NoopAction;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.gameclient.config.ProvidersLoader;
   import com.riotgames.platform.provider.ProviderLookupImpl;
   import com.riotgames.pvpnet.system.boot.ClientBootstrap;
   import com.riotgames.pvpnet.system.boot.actions.InitializeBroadcastMessagesAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeClientNotificationsAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeCursorManagerAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeGameConnectionAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeIMEAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeLoggingAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeMultiValuePropertiesAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializePlatformConfigAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeProviderLayerAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeRegionalConfigurations;
   import com.riotgames.pvpnet.system.boot.actions.InitializeResourceLoaderAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeServerStatusAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeServicesAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeSoundProviderAction;
   import com.riotgames.pvpnet.system.boot.actions.InitializeUserPreferencesAction;
   import com.riotgames.pvpnet.system.boot.actions.LoadFontsAction;
   import com.riotgames.pvpnet.system.boot.actions.ProcessCommandlineOverridesAction;
   import com.riotgames.pvpnet.system.boot.legacy.actions.LoadLegacyResourcesAction;
   import com.riotgames.pvpnet.system.boot.legacy.actions.LoadLegacyStyleAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.logging.LogTargetFactory;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import flash.display.LoaderInfo;
   import flash.filesystem.File;
   
   public class LolBootstrap extends ClientBootstrap
   {
      
      private var _chromeReadyAction:IAction = new NoopAction();
      
      public function LolBootstrap(param1:LoaderInfo, param2:Array = null)
      {
         super(param1,param2);
      }
      
      public function getChromeReadyAction() : IAction
      {
         return this._chromeReadyAction;
      }
      
      override protected function setupBootSequence() : void
      {
         _bootSequence.then(new InitializeLoggingAction(File.applicationDirectory.resolvePath("logs"),File.applicationStorageDirectory.resolvePath("logs"),new LogTargetFactory(),ClientConfig.instance.applicationBaseName));
         _bootSequence.then(new InitializeUserPreferencesAction(UserPreferencesManager.instance.getGlobalPrefsFile()));
         _bootSequence.and(createPopulateConfigAction());
         _bootSequence.then(new ProcessCommandlineOverridesAction(_invokeArguments,[ClientConfig.instance,RiotServiceConfig.instance]));
         _bootSequence.then(new InitializeProviderLayerAction(new ProviderLookupImpl(),new ProvidersLoader()));
         _bootSequence.then(new InitializeMultiValuePropertiesAction());
         _bootSequence.then(new InitializeResourceLoaderAction());
         _bootSequence.and(new InitializeRegionalConfigurations());
         _bootSequence.then(new LoadLegacyResourcesAction());
         _bootSequence.and(new InitializeLocalConnectionTool());
         _bootSequence.and(new InitializeTipsAction());
         _bootSequence.and(new InitializeCursorManagerAction());
         _bootSequence.then(this._chromeReadyAction);
         _bootSequence.then(new InitializePlatformConfigAction());
         _bootSequence.and(new LoadLegacyStyleAction());
         _bootSequence.and(new LoadFontsAction());
         _bootSequence.and(new InitializeSoundProviderAction(ClientConfig.instance));
         _bootSequence.and(new InitializeIMEAction());
         _bootSequence.then(new InitializeServicesAction());
         _bootSequence.then(new InitializeBroadcastMessagesAction());
         _bootSequence.and(new InitializeClientNotificationsAction());
         _bootSequence.and(new InitializeServerStatusAction());
         _bootSequence.and(new InitializeGameConnectionAction(new MaestroController()));
         _bootSequence.and(new InitializeANEAction());
      }
   }
}

