package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   
   public class CapConfirmQuitAction extends BasicAction
   {
      
      private var _model:CapModel;
      
      private var _actionFactory:ICapActionFactory;
      
      private var _onComplete:Function;
      
      private var _isLoggingOut:Boolean;
      
      public function CapConfirmQuitAction(param1:CapModel, param2:ICapActionFactory, param3:Boolean = false)
      {
         this._model = param1;
         this._actionFactory = param2;
         this._isLoggingOut = param3;
         super(false);
      }
      
      private function notAssociatedWithAGroup() : Boolean
      {
         return !this._model.groupId && !this._model.inSoloQuery;
      }
      
      private function handleQuitAlertResponse(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.invokeQuitAction();
         }
         else
         {
            err(new Error("Cancelled"));
            destroy();
         }
      }
      
      private function shouldShowConfirmDialogue() : Boolean
      {
         if(this._model.hasLaunchedGame || this._model.inSoloQuery)
         {
            return false;
         }
         var _loc1_:Boolean = CapFlowUtil.isCaptain(this._model) && CapModelUtil.groupHasInvitedPlayer(this._model.playerSelections);
         var _loc2_:Boolean = CapFlowUtil.isInvitee(this._model) && this._model.searchingForSolos;
         return _loc1_ || _loc2_ || this._model.inMatchmakingQueue;
      }
      
      private function invokeConfirmAlertAction() : void
      {
         var _loc1_:AlertAction = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this._model.inMatchmakingQueue)
         {
            _loc2_ = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_matchmaking_group_title","Don\'t Quit Now!");
            _loc3_ = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_matchmaking_group_body","Quitting now will cause penalties...");
            _loc1_ = new AlertAction(_loc2_,_loc3_);
            _loc1_.affirmativeLabel = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_matchmaking_group_affirmative","Quit Anyway");
            _loc1_.negativeLabel = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_matchmaking_group_negative","Continue");
         }
         else
         {
            _loc2_ = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_group_title","Are you sure?");
            _loc3_ = CapLocaleUtil.getResourceString("gf_dialog_confirm_quit_disband_group_body","You are about to cancel the group. Would you like to continue?");
            _loc1_ = new AlertAction(_loc2_,_loc3_);
         }
         _loc1_.showNegative = true;
         _loc1_.getCompleted().add(this.handleQuitAlertResponse);
         _loc1_.add();
      }
      
      private function trackDemandBoardData() : void
      {
         var _loc1_:IAction = this._actionFactory.getTrackDemandBoardMetricsAction();
         _loc1_.invoke();
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         if(this._model)
         {
            if(this.notAssociatedWithAGroup())
            {
               if(CapFlowUtil.isSolo(this._model))
               {
                  this.trackDemandBoardData();
               }
               complete();
            }
            else if(this.shouldShowConfirmDialogue() && !this._isLoggingOut)
            {
               this.invokeConfirmAlertAction();
            }
            else
            {
               this.invokeQuitAction();
            }
         }
         else
         {
            complete();
         }
      }
      
      private function invokeQuitAction() : void
      {
         var _loc1_:IAction = this._actionFactory.getQuitAction();
         _loc1_.invoke();
         abort();
         destroy();
      }
   }
}

