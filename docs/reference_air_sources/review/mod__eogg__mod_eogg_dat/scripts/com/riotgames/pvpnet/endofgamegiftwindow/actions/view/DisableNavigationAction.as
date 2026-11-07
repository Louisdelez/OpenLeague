package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class DisableNavigationAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      public function DisableNavigationAction(param1:IEndOfGameGiftViewMediator)
      {
         super(false);
         this._view = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._view.getConfirmSelection().removeAll();
         this._view.getRevertSelection().removeAll();
         this._view.getMessageChange().removeAll();
         this._view.getUnlock().removeAll();
         this._view.getHideCompleted().removeAll();
         complete();
      }
   }
}

