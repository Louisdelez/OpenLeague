package com.riotgames.platform.gameclient.controllers.game.controllers.reconnect
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.NotificationsProviderProxy;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.controllers.game.controllers.ChampionSelectionControllerNew;
   import com.riotgames.platform.gameclient.controllers.game.controllers.GameUpdateController;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class ChampionSelectionReconnector
   {
      
      private static const CHAMP_SELECT_NAMESPACE:String = "ChampionSelect";
      
      private static const RECONNECTOR_ENABLED_KEY:String = "AutoReconnectEnabled";
      
      private static const RECONNECTOR_ENABLED_DEFAULT:Boolean = false;
      
      private var _championSelectionController:ChampionSelectionControllerNew;
      
      private var _disconnectDetectedPrompt:DockedPrompt;
      
      private var _networkDetector:NetworkReconnectDetector;
      
      private var _gameUpdateController:GameUpdateController;
      
      private var _championSelectionViewModel:ChampionSelectionModel;
      
      public function ChampionSelectionReconnector(param1:ChampionSelectionControllerNew, param2:GameUpdateController)
      {
         super();
         this._championSelectionController = param1;
         this._gameUpdateController = param2;
         this._networkDetector = new NetworkReconnectDetector();
         this._networkDetector.disconnectedFromNetwork.add(this.onDisconnectedFromNetwork);
         this._networkDetector.reconnectedToNetwork.add(this.onReconnectedToNetwork);
      }
      
      private function get reconnectDetectionEnabledConfiguration() : ConfigurationModel
      {
         return DynamicClientConfigManager.getConfiguration(CHAMP_SELECT_NAMESPACE,RECONNECTOR_ENABLED_KEY,RECONNECTOR_ENABLED_DEFAULT);
      }
      
      private function updateAutoReconnect() : void
      {
         var _loc1_:Boolean = Boolean(this.reconnectDetectionEnabledConfiguration.getBoolean());
         var _loc2_:Boolean = this._championSelectionViewModel != null && this._championSelectionViewModel.currentGame != null;
         this.reset();
         if(_loc1_ && _loc2_)
         {
            this.reconnectDetectionEnabledConfiguration.getChangedSignal().add(this.updateAutoReconnect);
            this._networkDetector.startDisconnectDetection();
         }
      }
      
      public function set championSelectionViewModel(param1:ChampionSelectionModel) : void
      {
         this._championSelectionViewModel = param1;
         this.updateAutoReconnect();
      }
      
      private function hideAutoReconnectView() : void
      {
         if(this._disconnectDetectedPrompt != null)
         {
            NotificationsProviderProxy.instance.removeNotification(this._disconnectDetectedPrompt,this._disconnectDetectedPrompt.type);
         }
      }
      
      private function addChatMessage(param1:String) : void
      {
         var _loc2_:ChatMessageVO = new ChatMessageVO();
         _loc2_.type = ChatMessageType.USER_ALERT;
         _loc2_.rosterItem = null;
         _loc2_.timeStamp = new Date();
         _loc2_.body = param1;
         this._championSelectionViewModel.chatRoom.addMessageToBuffer(_loc2_);
      }
      
      private function showAutoReconnectView() : void
      {
         this.hideAutoReconnectView();
         var _loc1_:String = RiotResourceLoader.getString("game_disconnect_docked_prompt_message");
         this.addChatMessage(_loc1_);
         var _loc2_:String = RiotResourceLoader.getString("game_disconnect_docked_prompt_title");
         var _loc3_:String = RiotResourceLoader.getString("game_disconnect_docked_prompt_from");
         var _loc4_:String = RiotResourceLoader.getString("common_button_close");
         this._disconnectDetectedPrompt = DockedPrompt.create(_loc1_,_loc2_,_loc3_,_loc4_,null,DockedPrompt.TYPE_ALARM);
         NotificationsProviderProxy.instance.showDockedPrompt(this._disconnectDetectedPrompt);
      }
      
      private function onDisconnectedFromNetwork() : void
      {
         if(this._championSelectionViewModel != null && this._championSelectionViewModel.currentGame != null && Boolean(GameState.isInChampionSelectionState(this._championSelectionViewModel.currentGame.gameStateString)))
         {
            this.showAutoReconnectView();
         }
      }
      
      private function onReconnectedToNetwork() : void
      {
         this.hideAutoReconnectView();
         var _loc1_:String = RiotResourceLoader.getString("game_reconnected_docked_prompt_message");
         this.addChatMessage(_loc1_);
         if(this._championSelectionViewModel != null && this._championSelectionViewModel.currentGame != null && Boolean(GameState.isInChampionSelectionState(this._championSelectionViewModel.currentGame.gameStateString)))
         {
            new ReenterGameCommand(this,this._championSelectionController,this._gameUpdateController,this._championSelectionViewModel).execute();
         }
      }
      
      private function reset() : void
      {
         this.reconnectDetectionEnabledConfiguration.getChangedSignal().remove(this.updateAutoReconnect);
         this.hideAutoReconnectView();
         this._networkDetector.stopDisconnectDetection();
      }
      
      public function abortAutoReconnect() : void
      {
         this._championSelectionViewModel = null;
         this.updateAutoReconnect();
      }
   }
}

