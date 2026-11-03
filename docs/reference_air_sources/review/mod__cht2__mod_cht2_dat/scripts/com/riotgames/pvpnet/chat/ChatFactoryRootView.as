package com.riotgames.pvpnet.chat
{
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.communities.ICommunitiesProvider;
   import com.riotgames.pvpnet.docked.model.DockedChatViewModel;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.tips.ITipsProvider;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.module.RiotModuleView;
   
   public class ChatFactoryRootView extends RiotModuleView
   {
      
      private var _model:DockedChatViewModel;
      
      public function ChatFactoryRootView(param1:IContext, param2:RiotModuleInfo, param3:IConfigurationRegistry, param4:NotificationsProvider, param5:IChatRosterProvider, param6:ITipsProvider, param7:ChatViewMediator, param8:ILegacyProfileNavigationProvider, param9:IChatStateProvider, param10:ICommunitiesProvider)
      {
         super(param1);
         var _loc11_:String = ClientConfig.instance.locale;
         if(_loc11_ == "zh_CN" || _loc11_ == "zh_MY" || _loc11_ == "zh_TW")
         {
            setLinkagePostfix("_chinese");
         }
         loadAssets(getThemeAssetUrl(param2.getPath(),"dockedChatAssets.swf"));
         loadAssets(getThemeAssetUrl(param2.getPath(),"buddyPanelAssets.swf"));
         var _loc12_:ToolTipConfig = new ToolTipConfig();
         _loc12_.showDelay = 0;
         var _loc13_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this,_loc12_);
         this._model = new DockedChatViewModel();
         registerDependency(DockedChatViewModel,this._model);
         registerDependency(IToolTipManager,_loc13_);
         registerDependency(ISoundProvider,SoundProviderProxy.instance);
         registerDependency(IConfigurationRegistry,param3);
         registerDependency(NotificationsProvider,param4);
         registerDependency(IChatRosterProvider,param5);
         registerDependency(ITipsProvider,param6);
         registerDependency(ChatViewMediator,param7);
         registerDependency(ILegacyProfileNavigationProvider,param8);
         registerDependency(IChatStateProvider,param9);
         registerDependency(ICommunitiesProvider,param10);
         this.getOptionalProviders();
      }
      
      private function getOptionalProviders() : void
      {
         ProviderLookup.getProvider(IChatProvider,this.onGotChatProvider);
      }
      
      private function onGotChatProvider(param1:IChatProvider) : void
      {
         registerDependency(IChatProvider,param1);
      }
   }
}

