package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class InitializeViewDataAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _view:IEndOfGameGiftViewMediator;
      
      public function InitializeViewDataAction(param1:IEndOfGameGiftModel, param2:IEndOfGameGiftViewMediator)
      {
         this._model = param1;
         this._view = param2;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._view.setMainViewData(this._model.getGiftWindowTitleString(),this._model.getNextButtonLabel(),this._model.getBackButtonLabel());
         complete();
      }
   }
}

