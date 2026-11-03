package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapRevealNextAvailableSlotAction extends BasicAction
   {
      
      private var _model:CapModel;
      
      public function CapRevealNextAvailableSlotAction(param1:CapModel)
      {
         super(false);
         this._model = param1;
      }
      
      private function clearPreviousAvailableSlot() : void
      {
         var _loc1_:CapPlayerSelection = null;
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            if(!_loc1_.isPopulated)
            {
               _loc1_.visible = false;
               _loc1_.currentState = CapPlayerSelection.INTRO_STATE;
            }
         }
      }
      
      private function revealAvailableSlot() : void
      {
         var _loc1_:Array = CapModelUtil.getUnpopulatedPlayerSelections(this._model);
         var _loc2_:CapPlayerSelection = _loc1_[0];
         if(_loc2_ != null)
         {
            _loc2_.visible = true;
            if(CapModelUtil.hasMinPremadeSize(this._model))
            {
               this._model.invitePanelVisible = true;
               _loc2_.currentState = CapPlayerSelection.FIND_PLAYERS_STATE;
            }
            else
            {
               _loc2_.currentState = CapPlayerSelection.INTRO_STATE;
            }
         }
         this._model.activeCaptainSelectionPanel = _loc2_;
         CapModelUtil.refreshCollection(this._model);
      }
      
      private function setInvitePanelVisibility() : void
      {
         trace(CapModelUtil.hasMinPremadeSize(this._model));
      }
      
      override protected function doInvocation() : void
      {
         this.clearPreviousAvailableSlot();
         this.revealAvailableSlot();
         this.setInvitePanelVisibility();
         complete();
      }
   }
}

