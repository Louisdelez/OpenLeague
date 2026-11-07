package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class RevertGiftSelectionAction extends BasicAction
   {
      
      private var _model:IEndOfGameGiftModel;
      
      private var _view:IEndOfGameGiftViewMediator;
      
      public function RevertGiftSelectionAction(param1:IEndOfGameGiftModel, param2:IEndOfGameGiftViewMediator)
      {
         super(false);
         this._model = param1;
         this._view = param2;
      }
      
      override protected function doInvocation() : void
      {
         this._model.revertGiftSelected();
         this._view.setMainViewData(this._model.getGiftWindowTitleString(),this._model.getNextButtonLabel(),this._model.getBackButtonLabel());
         this._view.showRevertGiftSelection();
         complete();
      }
   }
}

