package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import com.riotgames.notification.IDialogQueueProvider;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   
   public class BaseGameInviteAcceptAction extends BasicAction
   {
      
      private var _dialogQueueProvider:IDialogQueueProvider;
      
      private var _masterGameController:MasterGameController;
      
      private var _applicationController:IAppController;
      
      private var _lobbyController:ILobbyViewController;
      
      private var _isCapGame:Boolean = false;
      
      public function BaseGameInviteAcceptAction(param1:IAppController, param2:MasterGameController, param3:ILobbyViewController, param4:IDialogQueueProvider, param5:Boolean)
      {
         super(false);
         this._masterGameController = param2;
         this._applicationController = param1;
         this._lobbyController = param3;
         this._dialogQueueProvider = param4;
         this._isCapGame = param5;
      }
      
      protected function doGroupGameFlow() : void
      {
         this._masterGameController.isSolo = false;
         this._masterGameController.currentState = GameViewState.CAP_STATE;
      }
      
      override protected function doInvocation() : void
      {
         this._dialogQueueProvider.removeActiveDialogs();
         this._applicationController.home();
         if(this._isCapGame)
         {
            this.doGroupGameFlow();
         }
         else if(!this._masterGameController.rejoiningQueue)
         {
            this._lobbyController.requestLobbyState(LobbyViewState.CREATE_ARRANGED_TEAM_STATE);
            this.doGameFlow();
            this._masterGameController.currentState = GameViewState.JOIN_QUEUE;
         }
         complete();
      }
      
      protected function doGameFlow() : void
      {
      }
      
      protected function getMasterGameController() : MasterGameController
      {
         return this._masterGameController;
      }
   }
}

