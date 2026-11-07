package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   
   public class UpdateGiftMessageAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _selectedMessage:Object;
      
      private var _onSelectedMessageUpdated:Function;
      
      public function UpdateGiftMessageAction(param1:IEndOfGameGiftModel, param2:Object, param3:Function)
      {
         super(false);
         this._model = param1;
         this._selectedMessage = param2;
         this._onSelectedMessageUpdated = param3;
      }
      
      override protected function doInvocation() : void
      {
         this._model.getSelectedMessageUpdate().addOnce(this._onSelectedMessageUpdated);
         this._model.changeMessageSelection(this._selectedMessage);
         complete();
      }
   }
}

