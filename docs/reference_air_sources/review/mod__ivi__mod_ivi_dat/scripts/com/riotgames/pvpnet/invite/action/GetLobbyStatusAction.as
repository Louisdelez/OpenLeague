package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import mx.rpc.events.ResultEvent;
   
   public class GetLobbyStatusAction extends BasicAction implements ILobbyStatusAction
   {
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _gameInviteService:GameInviteService;
      
      public function GetLobbyStatusAction(param1:GameInviteService)
      {
         super(false);
         this._gameInviteService = param1;
      }
      
      public function getLobbyStatus() : LobbyStatus
      {
         return this._lobbyStatus;
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         this._lobbyStatus = param1.result as LobbyStatus;
         complete();
      }
      
      private function displayError(param1:ServerError) : void
      {
         err(new Error("**Unable to retrieve invite lists\nReceived Error of type: " + param1.exception.toString()));
      }
      
      override protected function doInvocation() : void
      {
         this._gameInviteService.checkLobbyStatus(this.onServiceSuccess,null,this.onServiceError);
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         this.displayError(param1);
      }
   }
}

