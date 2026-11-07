package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class HideEndOfGameGiftViewAction extends BasicAction
   {
      
      private var _viewMediator:IEndOfGameGiftViewMediator;
      
      public function HideEndOfGameGiftViewAction(param1:IEndOfGameGiftViewMediator)
      {
         super(false);
         this._viewMediator = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._viewMediator.removeMainView();
         complete();
      }
   }
}

