package com.riotgames.pvpnet.endofgamegiftwindow.actions.model
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.dto.SendGiftRequestDTO;
   
   public class UnlockGiftPayloadAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _onUnlockPayloadReady:Function;
      
      public function UnlockGiftPayloadAction(param1:IEndOfGameGiftModel, param2:Function)
      {
         super(false);
         this._model = param1;
         this._onUnlockPayloadReady = param2;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:SendGiftRequestDTO = this._model.getUnlockGiftPayload();
         this._onUnlockPayloadReady.call(this,_loc1_);
         complete();
      }
   }
}

