package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftServiceResponseTypes;
   
   public class ServiceUnavailableAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      public function ServiceUnavailableAction(param1:IEndOfGameGiftModel)
      {
         this._model = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._model.setEOGGServiceError(EndOfGameGiftServiceResponseTypes.SERVICE_UNAVAILABLE_ERROR_ID,EndOfGameGiftServiceResponseTypes.SERVICE_UNAVAILABLE_ERROR_MESSAGE);
         complete();
      }
   }
}

