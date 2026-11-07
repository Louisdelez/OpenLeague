package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import blix.context.IContext;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.EndOfGameGiftWindowView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowEndOfGameGiftViewAction extends BasicAction
   {
      
      private var _viewMediator:IEndOfGameGiftViewMediator;
      
      private var _blixContext:IContext;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _onHideComplete:Function;
      
      private var _onGiftSent:Function;
      
      public function ShowEndOfGameGiftViewAction(param1:IEndOfGameGiftViewMediator, param2:IContext, param3:ProviderModuleInfo, param4:Function, param5:Function)
      {
         super(false);
         this._viewMediator = param1;
         this._blixContext = param2;
         this._moduleInfo = param3;
         this._onHideComplete = param4;
         this._onGiftSent = param5;
      }
      
      override protected function doInvocation() : void
      {
         this._viewMediator.addMainView(new EndOfGameGiftWindowView(this._blixContext,this._moduleInfo,this._viewMediator.initialize));
         this._viewMediator.getHideCompleted().addOnce(this._onHideComplete);
         this._viewMediator.getGiftSent().addOnce(this._onGiftSent);
         this._viewMediator.showMainView();
         complete();
      }
   }
}

