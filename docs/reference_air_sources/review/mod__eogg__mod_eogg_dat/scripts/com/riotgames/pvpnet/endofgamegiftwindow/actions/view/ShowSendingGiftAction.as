package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowSendingGiftAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      public function ShowSendingGiftAction(param1:IEndOfGameGiftViewMediator)
      {
         super(false);
         this._view = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._view.showSendingGift();
         complete();
      }
   }
}

