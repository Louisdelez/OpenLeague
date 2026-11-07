package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   
   public class ResetSessionDataAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      public function ResetSessionDataAction(param1:IEndOfGameGiftModel)
      {
         this._model = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._model.resetGiftingSessionData();
         complete();
      }
   }
}

