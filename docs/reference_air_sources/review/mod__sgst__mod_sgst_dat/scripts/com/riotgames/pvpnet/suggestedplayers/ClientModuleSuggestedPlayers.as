package com.riotgames.pvpnet.suggestedplayers
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.common.utils.encode.JSONEncoder;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.suggestedplayers.controller.SuggestedPlayersController;
   import com.riotgames.pvpnet.suggestedplayers.factory.SuggestedPlayersServiceCallFactory;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayersModel;
   import com.riotgames.pvpnet.suggestedplayers.service.SuggestedPlayersService;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleSuggestedPlayers extends Sprite implements IProviderModule
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _controller:SuggestedPlayersController;
      
      private var _notificationProvider:IClientNotificationProvider;
      
      private var _inviteProvider:IInviteProvider;
      
      public function ClientModuleSuggestedPlayers()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         ProviderLookup.getProvider(IClientNotificationProvider,this.onNotificationProvider);
      }
      
      private function onNotificationProvider(param1:IClientNotificationProvider) : void
      {
         this._notificationProvider = param1;
         this.checkIfWeGotAllTheProviders();
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this._inviteProvider = param1;
         this.checkIfWeGotAllTheProviders();
      }
      
      private function checkIfWeGotAllTheProviders() : void
      {
         if(Boolean(this._notificationProvider) && Boolean(this._inviteProvider))
         {
            this.initEverything();
         }
      }
      
      private function initEverything() : void
      {
         var _loc1_:SuggestedPlayersModel = new SuggestedPlayersModel();
         var _loc2_:IEncode = new JSONEncoder();
         var _loc3_:IDecode = new JSONDecoder();
         var _loc4_:IBaseLcdsService = ServiceProxy.instance.lcdsService;
         var _loc5_:SuggestedPlayersService = new SuggestedPlayersService(_loc4_);
         this._notificationProvider.getLcdsProxyMessageRouter().setServiceCallListener(ClientNotificationProxyServiceName.SUGGESTED_PLAYERS,_loc5_);
         var _loc6_:SuggestedPlayersServiceCallFactory = new SuggestedPlayersServiceCallFactory(_loc5_,_loc2_,_loc3_);
         this._controller = new SuggestedPlayersController(Session.instance,_loc1_,this._inviteProvider.getInviteGroup(),_loc6_);
         ProviderLookup.getProvider(IChatRosterProvider,this.onChatRosterProvider);
         ProviderLookup.publishProvider(ISuggestedPlayersProvider,this._controller);
      }
      
      private function onChatRosterProvider(param1:IChatRosterProvider) : void
      {
         this._controller.setChatRosterProvider(param1);
      }
   }
}

