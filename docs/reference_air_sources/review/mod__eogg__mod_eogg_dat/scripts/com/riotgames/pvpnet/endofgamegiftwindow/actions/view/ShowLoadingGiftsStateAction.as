package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowLoadingGiftsStateAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      public function ShowLoadingGiftsStateAction(param1:IEndOfGameGiftViewMediator)
      {
         this._view = param1;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._view.showLoadingGifts();
         complete();
      }
   }
}

