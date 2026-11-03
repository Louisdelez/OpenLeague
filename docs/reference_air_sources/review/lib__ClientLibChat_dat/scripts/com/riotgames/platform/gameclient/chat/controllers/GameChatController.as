package com.riotgames.platform.gameclient.chat.controllers
{
   import com.riotgames.platform.common.event.GameChatEvent;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.gamechat.GameChatXML;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.XMLStanza;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class GameChatController implements IViewController
   {
      
      private var privacyListController:PrivacyListController;
      
      private var chatController:ChatController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var maestroController:IMaestroProvider;
      
      private var clientConfig:ClientConfig;
      
      private var shellDispatcher:ShellDispatcher;
      
      public function GameChatController(param1:ClientConfig, param2:ShellDispatcher, param3:IMaestroProvider, param4:ChatController, param5:PrivacyListController)
      {
         super();
         if(param1 == null || param2 == null || param3 == null || param4 == null || param5 == null)
         {
            throw new Error("GameChatController not initialized correctly!");
         }
         this.clientConfig = param1;
         this.shellDispatcher = param2;
         this.maestroController = param3;
         this.chatController = param4;
         this.privacyListController = param5;
      }
      
      private function handleToggleIgnore(param1:GameChatXML) : void
      {
      }
      
      private function shouldSendGameChatMessages() : Boolean
      {
         return this.chatController.gameProvider.currentState == GameViewState.PLAYING_GAME;
      }
      
      private function handleUpdateRequested(param1:GameChatXML) : void
      {
         var _loc2_:GameChatXML = null;
         var _loc3_:RosterGroup = null;
         var _loc4_:RosterItemVO = null;
         var _loc5_:GameChatXML = null;
         var _loc6_:PrivacyListItem = null;
         if(Boolean(this.chatController.roster))
         {
            _loc2_ = new GameChatXML();
            _loc2_.setStringValue(GameChatXML.ENTRY_NODE_TYPE,GameChatXML.CHAT_TYPE_BUDDY_LIST_UPDATE);
            for each(_loc3_ in this.chatController.roster.groups)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc2_.addBuddy(_loc4_.displayName,"");
               }
            }
            this.sendChatMessage(_loc2_);
         }
         if(Boolean(this.privacyListController.activePrivacyList) && Boolean(this.privacyListController.activePrivacyList.items))
         {
            _loc5_ = new GameChatXML();
            _loc5_.setStringValue(GameChatXML.ENTRY_NODE_TYPE,GameChatXML.CHAT_TYPE_IGNORE_LIST_UPDATE);
            for each(_loc6_ in this.privacyListController.activePrivacyList.items)
            {
               _loc5_.addBuddy(_loc6_.displayName,"");
            }
            this.sendChatMessage(_loc5_);
         }
      }
      
      private function handleSendMessage(param1:GameChatXML) : void
      {
         var _loc2_:String = param1.getStringValue(GameChatXML.ENTRY_NODE_SUMMONER_NAME);
         var _loc3_:String = param1.getStringValue(GameChatXML.ENTRY_NODE_SUMMONER_MESSAGE);
         this.chatController.sendSummonerNameMessage(_loc2_,_loc3_);
         this.chatController.chatTracker.incrementInGameChatSent_InASession();
      }
      
      private function onGameMessageRecieved(param1:GameChatEvent) : void
      {
         var _loc2_:GameChatXML = new GameChatXML();
         _loc2_.parseXML(param1.chatMessage);
         switch(_loc2_.getStringValue(GameChatXML.ENTRY_NODE_TYPE))
         {
            case GameChatXML.CHAT_TYPE_TOGGLE_IGNORE:
               this.handleToggleIgnore(_loc2_);
               break;
            case GameChatXML.CHAT_TYPE_MESSAGE_SEND:
               this.handleSendMessage(_loc2_);
               break;
            case GameChatXML.CHAT_TYPE_REQUEST_UPDATE:
               this.handleUpdateRequested(_loc2_);
               break;
            default:
               this.logger.error("GameChatController: onGameMessageRecieved -- unable to parse chat message from game client: " + param1.chatMessage);
         }
      }
      
      private function sendChatMessage(param1:XMLStanza) : void
      {
         var _loc2_:String = null;
         if(this.clientConfig.platform_to_game_chat)
         {
            _loc2_ = param1.getNode().toString();
            this.maestroController.sendChatMessage(_loc2_);
         }
      }
      
      public function initialize() : void
      {
      }
      
      public function deactivate() : void
      {
         this.shellDispatcher.removeEventListener(GameChatEvent.CHAT_EVENT_FROM_GAME,this.onGameMessageRecieved);
      }
      
      public function activate() : void
      {
         this.shellDispatcher.addEventListener(GameChatEvent.CHAT_EVENT_FROM_GAME,this.onGameMessageRecieved);
      }
      
      public function cleanup() : void
      {
      }
      
      public function chatMessageReceived(param1:RosterItemVO, param2:Message) : void
      {
         if(!this.shouldSendGameChatMessages())
         {
            return;
         }
         param2.body = WordFilter.instance.maskOffensiveWords(param2.body);
         var _loc3_:GameChatXML = new GameChatXML();
         _loc3_.setStringValue(GameChatXML.ENTRY_NODE_TYPE,GameChatXML.CHAT_TYPE_MESSAGE_RECIEVED);
         _loc3_.setStringValue(GameChatXML.ENTRY_NODE_SUMMONER_NAME,param1.displayName);
         _loc3_.setStringValue(GameChatXML.ENTRY_NODE_SUMMONER_MESSAGE,param2.body);
         this.sendChatMessage(_loc3_);
         this.chatController.chatTracker.incrementInGameChatReceived_InASession();
      }
      
      public function AASNotificationReceived(param1:AntiIndulgenceMessage) : void
      {
         if(!this.shouldSendGameChatMessages())
         {
            return;
         }
         var _loc2_:String = RiotResourceLoader.getString(param1.messageKey,null,[param1.messageArgument]);
         var _loc3_:GameChatXML = new GameChatXML();
         _loc3_.setStringValue(GameChatXML.ENTRY_NODE_TYPE,GameChatXML.CHAT_TYPE_AAS_NOTIFICATION);
         _loc3_.setStringValue(GameChatXML.ENTRY_NODE_AAS_MESSAGE,_loc2_);
         this.sendChatMessage(_loc3_);
      }
   }
}

