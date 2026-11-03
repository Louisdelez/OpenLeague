package com.riotgames.platform.gameclient.init
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.domain.GameVersionConfig;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LogoutConfirmer
   {
      
      private var applicationController:IAppController;
      
      private var masterGameController:MasterGameController;
      
      private var queueDodgeConfirmAlertAction:AlertAction;
      
      private var logoutConfirmAlertAction:AlertAction;
      
      public function LogoutConfirmer(param1:IAppController, param2:MasterGameController)
      {
         super();
         this.applicationController = param1;
         this.masterGameController = param2;
      }
      
      private function onCloseHandler(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.applicationController.logout(true);
         }
      }
      
      public function confirmClosing(param1:Session) : void
      {
         var _loc4_:IResourceManager = null;
         var _loc2_:String = "logout_confirm";
         var _loc3_:GameDTO = this.masterGameController.currentGame;
         if(Boolean(this.masterGameController.willBeLeaver()) && (_loc3_ == null || _loc3_.gameType != GameType.PRACTICE_GAME && _loc3_.gameType != GameType.TUTORIAL_GAME))
         {
            _loc2_ = "logout_confirm_leaver";
         }
         else if(GameVersionConfig.instance.isWorking)
         {
            _loc2_ = "logout_confirm_cancel_patch";
         }
         if(param1.isLoggedIn)
         {
            _loc4_ = ResourceManager.getInstance();
            if(this.queueDodgeConfirmAlertAction == null)
            {
               this.queueDodgeConfirmAlertAction = new AlertAction(_loc4_.getString("resources","championSelection_rankedheader_queueDodge"),_loc4_.getString("resources","championSelection_rankedtip_queueDodge"));
            }
            if(this.logoutConfirmAlertAction == null)
            {
               this.logoutConfirmAlertAction = new AlertAction(_loc4_.getString("resources","logout_confirm_title"),null);
               this.logoutConfirmAlertAction.showNegative = true;
               this.logoutConfirmAlertAction.setYesNoLabels();
               this.logoutConfirmAlertAction.getCompleted().add(this.onCloseHandler);
            }
            this.logoutConfirmAlertAction.body = _loc4_.getString("resources",_loc2_);
            if(Boolean(this.logoutConfirmAlertAction.getHasBeenInvoked()) && !this.logoutConfirmAlertAction.getIsFinished())
            {
               this.logoutConfirmAlertAction.affirmativeResponse = true;
               this.logoutConfirmAlertAction.complete();
            }
            else
            {
               if(Boolean(_loc3_) && this.shouldShowQueueDodgeWarning)
               {
                  this.queueDodgeConfirmAlertAction.add();
               }
               this.logoutConfirmAlertAction.add();
            }
         }
         else
         {
            this.applicationController.logout(true);
         }
      }
      
      private function get shouldShowQueueDodgeWarning() : Boolean
      {
         var _loc1_:GameDTO = this.masterGameController.currentGame;
         var _loc2_:Boolean = _loc1_.gameType == GameType.RANKED_GAME;
         var _loc3_:Boolean = _loc1_.gameStateString == GameState.TEAM_SELECTION;
         var _loc4_:Boolean = _loc1_.gameStateString != GameState.JOINING_CHAMP_SELECT && _loc1_.gameStateString != GameState.TERMINATED && _loc1_.gameStateString != GameState.IN_PROGRESS && _loc1_.gameStateString != GameState.START_REQUESTED;
         return _loc2_ && _loc4_ && !_loc3_;
      }
   }
}

