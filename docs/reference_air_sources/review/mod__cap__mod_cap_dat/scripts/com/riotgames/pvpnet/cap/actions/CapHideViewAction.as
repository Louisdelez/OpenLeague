package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   
   public class CapHideViewAction extends BasicAction
   {
      
      private var _lobbyController:ILobbyViewController;
      
      public function CapHideViewAction(param1:ILobbyViewController)
      {
         super(false);
         this._lobbyController = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._lobbyController.showLobbyLanding();
         complete();
      }
   }
}

