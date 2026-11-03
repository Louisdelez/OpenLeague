package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   
   public class UpdateGiftSelectionAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _newGiftSelection:IEndOfGameGift;
      
      private var _onSelectedGiftUpdated:Function;
      
      public function UpdateGiftSelectionAction(param1:IEndOfGameGiftModel, param2:IEndOfGameGift, param3:Function)
      {
         super(false);
         this._model = param1;
         this._newGiftSelection = param2;
         this._onSelectedGiftUpdated = param3;
      }
      
      override protected function doInvocation() : void
      {
         this._model.getSelectedGiftUpdated().addOnce(this._onSelectedGiftUpdated);
         this._model.changeGiftSelection(this._newGiftSelection);
         complete();
      }
   }
}

