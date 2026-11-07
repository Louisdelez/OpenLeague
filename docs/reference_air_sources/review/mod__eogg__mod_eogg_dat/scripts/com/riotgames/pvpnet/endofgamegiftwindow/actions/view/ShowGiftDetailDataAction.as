package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowGiftDetailDataAction extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _detailData:IEndOfGameGiftDetailData;
      
      public function ShowGiftDetailDataAction(param1:IEndOfGameGiftViewMediator, param2:IEndOfGameGiftDetailData)
      {
         super(false);
         this._view = param1;
         this._detailData = param2;
      }
      
      override protected function doInvocation() : void
      {
         this._view.showGiftSelectionChange(this._detailData);
      }
   }
}

