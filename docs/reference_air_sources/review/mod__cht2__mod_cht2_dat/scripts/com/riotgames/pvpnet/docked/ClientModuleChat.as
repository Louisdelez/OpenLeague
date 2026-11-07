package com.riotgames.pvpnet.docked
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.chat.IChatRoomView;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.platform.gameclient.chat.IChatViewProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.chat.BuddyPanelProvider;
   import com.riotgames.pvpnet.chat.ChatFactoryRootView;
   import com.riotgames.pvpnet.chat.DockedChatViewProvider;
   import com.riotgames.pvpnet.chat.FriendListProvider;
   import com.riotgames.pvpnet.chat.IChatWindowProvider;
   import com.riotgames.pvpnet.chat.IFriendListProvider;
   import com.riotgames.pvpnet.chat.MessageWindowFactory;
   import com.riotgames.pvpnet.communities.ICommunitiesProvider;
   import com.riotgames.pvpnet.docked.chat.view.groupchat.ChatRoomView;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationRegistry;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.pvpnet.tips.ITipsProvider;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleChat extends Sprite implements IProviderModule, IChatViewProvider
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _rootView:ChatFactoryRootView;
      
      private var _configurationRegistry:IConfigurationRegistry;
      
      private var _messageWindowFactory:MessageWindowFactory;
      
      private var _friendListProvider:FriendListProvider;
      
      private var _buddyPanelProvider:IBuddyPanelProvider;
      
      private var _dockedChatViewProvider:IDockedChatViewProvider;
      
      private var _notificationsProvider:NotificationsProvider;
      
      private var _providerDependencies:Dictionary;
      
      public function ClientModuleChat()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this._providerDependencies = new Dictionary();
         ProviderLookup.publishProvider(IChatViewProvider,this);
         this._notificationsProvider = new NotificationsProvider();
         ProviderLookup.publishProvider(INotificationsProvider,this._notificationsProvider);
         this.initializeConfigurationRegistry();
         this.addProviderDependency(IChatRosterProvider);
         this.addProviderDependency(ITipsProvider);
         this.addProviderDependency(ChatViewMediator);
         this.addProviderDependency(ILegacyProfileNavigationProvider);
         this.addProviderDependency(IChatStateProvider);
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.COMMUNITIES_ENABLED,false);
         if(_loc2_.getBoolean())
         {
            this.addProviderDependency(ICommunitiesProvider);
         }
         this.fulfillProviderDependencies();
      }
      
      public function getChatRoomView(param1:DisplayAdapter) : IChatRoomView
      {
         return new ChatRoomView(this._rootView);
      }
      
      private function initializeConfigurationRegistry() : void
      {
         var _loc1_:IConfigurationRegistry = new ConfigurationRegistry();
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED,false);
         _loc1_.registerConfigurationModel(_loc2_);
         this._configurationRegistry = _loc1_;
      }
      
      private function addProviderDependency(param1:Class) : void
      {
         this._providerDependencies[param1] = null;
      }
      
      private function fulfillProviderDependencies() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in this._providerDependencies)
         {
            ProviderLookup.getProvider(Class(_loc1_),this.onProviderSuccess,this.onProviderError);
         }
      }
      
      private function onProviderSuccess(param1:IProvider) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         for(_loc3_ in this._providerDependencies)
         {
            if(param1 is Class(_loc3_))
            {
               this._providerDependencies[_loc3_] = param1;
            }
            else if(this._providerDependencies[_loc3_] == null)
            {
               _loc2_++;
            }
         }
         if(_loc2_ == 0)
         {
            this.joinGotDependencies();
         }
      }
      
      private function onProviderError(param1:Error) : void
      {
      }
      
      private function joinGotDependencies() : void
      {
         this._rootView = new ChatFactoryRootView(null,this._moduleInfo,this._configurationRegistry,this._notificationsProvider,this._providerDependencies[IChatRosterProvider],this._providerDependencies[ITipsProvider],this._providerDependencies[ChatViewMediator],this._providerDependencies[ILegacyProfileNavigationProvider],this._providerDependencies[IChatStateProvider],this._providerDependencies[ICommunitiesProvider]);
         this._messageWindowFactory = new MessageWindowFactory(this._rootView);
         ProviderLookup.publishProvider(IChatWindowProvider,this._messageWindowFactory);
         this._friendListProvider = new FriendListProvider(this._rootView);
         ProviderLookup.publishProvider(IFriendListProvider,this._friendListProvider);
         this._buddyPanelProvider = new BuddyPanelProvider(this._rootView);
         ProviderLookup.publishProvider(IBuddyPanelProvider,this._buddyPanelProvider);
         this._dockedChatViewProvider = new DockedChatViewProvider(this._rootView);
         ProviderLookup.publishProvider(IDockedChatViewProvider,this._dockedChatViewProvider);
      }
   }
}

