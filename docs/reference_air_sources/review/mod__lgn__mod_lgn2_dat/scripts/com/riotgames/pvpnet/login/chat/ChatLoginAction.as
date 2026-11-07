package com.riotgames.pvpnet.login.chat
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.xmpp.logging.XMPPSessionLogger;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   
   public class ChatLoginAction extends BasicAction
   {
      
      private var _chatController:ChatController;
      
      private var username:String;
      
      private var password:String;
      
      public function ChatLoginAction()
      {
         super(true);
         this.initializeChatController();
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Session = Session.instance;
         var _loc2_:ClientConfig = ClientConfig.instance;
         if(Boolean(_loc2_.START_CHAT_PROP) && _loc1_.summoner != null && _loc1_.summoner.sumId > 0 && !this._chatController.loggedIn)
         {
            this._chatController.login(_loc1_.accountSummary.username,_loc1_.getChatPassword(),_loc1_.accountSummary.summonerName,_loc1_.summoner.profileIconId,false);
         }
         complete();
      }
      
      public function initializeChatController() : void
      {
         this._chatController = new ChatController();
         var _loc1_:PrivacyListController = new PrivacyListController();
         var _loc2_:PresenceController = new PresenceController();
         var _loc3_:XMPPSessionLogger = new XMPPSessionLogger();
         this._chatController.privacyListController = _loc1_;
         this._chatController.presenceController = _loc2_;
         this._chatController.xmppSessionLogger = _loc3_;
         _loc2_.chatController = this._chatController;
         _loc1_.chatController = this._chatController;
         ProviderLookup.publishProvider(IChatProvider,this._chatController);
      }
   }
}

