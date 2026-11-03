package com.riotgames.pvpnet.game.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class BanPlayerFromPracticeGameAction extends BasicAction
   {
      
      private var _player:PlayerParticipant;
      
      private var _gameId:Number;
      
      private var _gameService:GameService;
      
      private var _inviteController:IInviteController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function BanPlayerFromPracticeGameAction(param1:PlayerParticipant, param2:Number, param3:IInviteController, param4:GameService)
      {
         super(false);
         this._player = param1;
         this._gameId = param2;
         this._gameService = param4;
         this._inviteController = param3;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_title"),_loc1_.getString("resources","practiceGame_teamMemberRenderer_verifykickban_message",[this._player.summonerName]));
         _loc2_.showNegative = true;
         _loc2_.affirmativeDefault = false;
         _loc2_.setYesNoLabels();
         _loc2_.getCompleted().addOnce(this.handleKickBanPlayer);
         _loc2_.add();
      }
      
      protected function handleKickBanPlayer(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.banPlayerFromGame();
         }
         else
         {
            abort();
         }
      }
      
      public function banPlayerFromGame() : void
      {
         this._gameService.banUserFromGame(this._gameId,this._player.accountId,this.onBanPlayerFromGameSuccess,null,this.onServiceRequestError,this._player);
      }
      
      private function onBanPlayerFromGameSuccess(param1:ResultEvent) : void
      {
         var _loc2_:PlayerParticipant = null;
         if(param1 != null && param1.token != null && param1.token.asyncObject != null)
         {
            _loc2_ = param1.token.asyncObject as PlayerParticipant;
            this._inviteController.banUserFromPracticeGame(_loc2_.summonerName);
         }
         complete();
      }
      
      protected function onServiceRequestError(param1:ServerError = null) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         if(Boolean(param1))
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
            _loc3_.add();
            err(param1.faultEvent.fault);
         }
         else
         {
            err(new Error("Unable to ban"));
         }
      }
   }
}

