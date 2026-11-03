package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class EnableNavigationAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _onConfirmGift:Function;
      
      private var _onRevertGift:Function;
      
      private var _onMessageChange:Function;
      
      private var _onUnlockGift:Function;
      
      private var _onCloseWindow:Function;
      
      public function EnableNavigationAction(param1:IEndOfGameGiftViewMediator, param2:Function, param3:Function, param4:Function, param5:Function, param6:Function)
      {
         super(false);
         this._view = param1;
         this._onConfirmGift = param2;
         this._onRevertGift = param3;
         this._onMessageChange = param4;
         this._onUnlockGift = param5;
         this._onCloseWindow = param6;
      }
      
      override protected function doInvocation() : void
      {
         this._view.getConfirmSelection().add(this._onConfirmGift);
         this._view.getRevertSelection().add(this._onRevertGift);
         this._view.getMessageChange().add(this._onMessageChange);
         this._view.getUnlock().add(this._onUnlockGift);
         this._view.getHideCompleted().add(this._onCloseWindow);
         complete();
      }
   }
}

