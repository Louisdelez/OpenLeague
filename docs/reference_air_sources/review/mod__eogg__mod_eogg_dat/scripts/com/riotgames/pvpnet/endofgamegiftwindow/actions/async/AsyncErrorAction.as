package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftServiceResponseTypes;
   
   public class AsyncErrorAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      public function AsyncErrorAction(param1:IEndOfGameGiftModel)
      {
         this._model = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._model.setEOGGServiceError(EndOfGameGiftServiceResponseTypes.DEFAULT_ASYNC_TIMEOUT_ERROR_ID,EndOfGameGiftServiceResponseTypes.DEFAULT_ASYNC_TIMEOUT_ERROR_MESSAGE);
         complete();
      }
   }
}

