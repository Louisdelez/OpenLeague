package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowGiftListAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _giftList:Vector.<AvailableGiftCategory>;
      
      private var _onGiftSelectionChange:Function;
      
      public function ShowGiftListAction(param1:IEndOfGameGiftViewMediator, param2:Vector.<AvailableGiftCategory>, param3:Function)
      {
         super(false);
         this._view = param1;
         this._giftList = param2;
         this._onGiftSelectionChange = param3;
      }
      
      override protected function doInvocation() : void
      {
         this._view.getSelectionChanged().add(this._onGiftSelectionChange);
         this._view.showNewGiftList(this._giftList);
         complete();
      }
   }
}

