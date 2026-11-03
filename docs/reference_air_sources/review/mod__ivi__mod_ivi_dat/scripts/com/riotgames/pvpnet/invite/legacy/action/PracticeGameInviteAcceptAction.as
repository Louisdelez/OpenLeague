package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   
   public class PracticeGameInviteAcceptAction extends BasicAction
   {
      
      private var _gameService:GameService;
      
      private var _mapId:int;
      
      private var _applicationController:IAppController;
      
      private var _masterGameController:MasterGameController;
      
      public function PracticeGameInviteAcceptAction(param1:int, param2:IAppController, param3:MasterGameController)
      {
         super(false);
         this._mapId = param1;
         this._masterGameController = param3;
         this._applicationController = param2;
      }
      
      override protected function doInvocation() : void
      {
         if(this._masterGameController.currentGame == null)
         {
            this._applicationController.home();
            this._masterGameController.startPracticeGameFlowAtJoinGame();
            this._masterGameController.gameMap = this._applicationController.getGameMap(this._mapId);
         }
      }
   }
}

