package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.CapProviderProxy;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import mx.rpc.events.ResultEvent;
   
   public class QuitGameAction extends BasicAction
   {
      
      private var _kicked:Boolean;
      
      private var _gameType:String;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _applicationController:IAppController;
      
      private var _masterGameController:MasterGameController;
      
      private var _gameInviteService:GameInviteService;
      
      public function QuitGameAction(param1:String, param2:Boolean, param3:MasterGameController, param4:IAppController, param5:GameInviteService, param6:PlatformInviteActionFactory)
      {
         super(false);
         this._gameType = param1;
         this._kicked = param2;
         this._masterGameController = param3;
         this._applicationController = param4;
         this._gameInviteService = param5;
         this._inviteActionFactory = param6;
      }
      
      private function onQuitError(param1:IAction) : void
      {
         err(param1.getError());
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:IAction = null;
         if(this._masterGameController.currentState == GameViewState.CAP_STATE)
         {
            CapProviderProxy.instance.quit(this.onQuitComplete,this.onQuitError);
            return;
         }
         if(!this._gameType || this._gameType == "")
         {
            this._masterGameController.inviteController.setPlayerQuittingGame(true);
            this._masterGameController.cleanupAfterGameCompleteOrAborted();
            this._masterGameController.inviteController.setPlayerQuittingGame(false);
            complete();
         }
         else if(this._gameType != GameType.CUSTOM_GAME && this._gameType != GameType.PRACTICE_GAME)
         {
            if(this._kicked)
            {
               this.onLeaveInviteSuccess(null);
            }
            else
            {
               this._gameInviteService.leave(this.onLeaveInviteSuccess,null,this.onLeaveInviteError);
            }
         }
         else
         {
            _loc1_ = this._inviteActionFactory.getQuitPracticeGameAction();
            _loc1_.getCompleted().add(this.onQuitComplete);
            _loc1_.getErred().add(this.onQuitError);
            _loc1_.invoke();
         }
      }
      
      private function onQuitComplete() : void
      {
         complete();
      }
      
      private function onLeaveInviteSuccess(param1:ResultEvent) : void
      {
         if(!this._masterGameController.isShuttingDown)
         {
            this._masterGameController.inviteController.setPlayerQuittingGame(true);
            this._masterGameController.cleanupAfterGameCompleteOrAborted();
            this._masterGameController.inviteController.setPlayerQuittingGame(false);
            this._applicationController.home();
         }
         complete();
      }
      
      private function onLeaveInviteError(param1:ServerError) : void
      {
         err(new Error("**Unable to leave current game. Cannot accept new invite"));
      }
   }
}

