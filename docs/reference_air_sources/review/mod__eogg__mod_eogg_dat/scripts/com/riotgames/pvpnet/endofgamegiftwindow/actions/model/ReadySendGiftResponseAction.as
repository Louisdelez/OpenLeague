package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   
   public class ReadySendGiftResponseAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _onGiftSentSuccess:Function;
      
      private var _onGiftSendError:Function;
      
      public function ReadySendGiftResponseAction(param1:IEndOfGameGiftModel, param2:Function, param3:Function)
      {
         super(false);
         this._model = param1;
         this._onGiftSentSuccess = param2;
         this._onGiftSendError = param3;
      }
      
      override protected function doInvocation() : void
      {
         this._model.getGiftSentSuccess().addOnce(this._onGiftSentSuccess);
         this._model.getServiceErrorReceived().addOnce(this._onGiftSendError);
         complete();
      }
   }
}

