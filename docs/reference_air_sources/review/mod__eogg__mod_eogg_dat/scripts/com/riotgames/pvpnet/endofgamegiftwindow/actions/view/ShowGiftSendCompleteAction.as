package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowGiftSendCompleteAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _viewData:IGiftCompleteDetailData;
      
      public function ShowGiftSendCompleteAction(param1:IEndOfGameGiftViewMediator, param2:IGiftCompleteDetailData)
      {
         super(false);
         this._view = param1;
         this._viewData = param2;
      }
      
      override protected function doInvocation() : void
      {
         if(this._viewData.isErrorState)
         {
            this._view.showGiftServiceError(this._viewData);
         }
         else
         {
            this._view.showSentGiftConfirmation(this._viewData);
         }
         complete();
      }
   }
}

