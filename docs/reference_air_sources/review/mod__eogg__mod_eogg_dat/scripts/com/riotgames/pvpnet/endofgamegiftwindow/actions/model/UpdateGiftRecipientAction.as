package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   
   public class UpdateGiftRecipientAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _giftRecipient:IPlayerSummary;
      
      private var _onGiftRecipientUpdated:Function;
      
      private var _onGiftListUpdated:Function;
      
      private var _onGiftServiceError:Function;
      
      public function UpdateGiftRecipientAction(param1:IEndOfGameGiftModel, param2:IPlayerSummary, param3:Function, param4:Function, param5:Function)
      {
         super(false);
         this._model = param1;
         this._giftRecipient = param2;
         this._onGiftRecipientUpdated = param3;
         this._onGiftListUpdated = param4;
         this._onGiftServiceError = param5;
      }
      
      override protected function doInvocation() : void
      {
         this._model.getGiftRecipientUpdate().addOnce(this._onGiftRecipientUpdated);
         this._model.getGiftListUpdated().addOnce(this._onGiftListUpdated);
         this._model.getServiceErrorReceived().addOnce(this._onGiftServiceError);
         this._model.updateGiftRecipient(this._giftRecipient);
         complete();
      }
   }
}

