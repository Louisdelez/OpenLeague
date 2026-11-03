package com.riotgames.pvpnet.runes
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.MainScreenProviderProxy;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.runes.views.RunesRootView;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleRunes extends Sprite implements IProviderModule, IRunesProvider
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _runesRootView:RunesRootView;
      
      public function ClientModuleRunes()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.publishProvider(IRunesProvider,this);
         MainScreenProviderProxy.instance.registerMainScreenFactory(param1.getExtraDataValue("mainScreen"),this.getRunesScreen);
      }
      
      public function getRunesScreen(param1:IContext) : IMainScreen
      {
         if(this._runesRootView == null)
         {
            this._runesRootView = new RunesRootView(param1,this._moduleInfo);
         }
         return this._runesRootView;
      }
      
      public function show(param1:Number, param2:DisplayAdapter) : void
      {
         var _loc3_:RunesRootView = this.getRunesScreen(null) as RunesRootView;
         if(param1 != 0)
         {
            _loc3_.setAccountId(param1);
         }
         _loc3_.show();
         param2.addChild(_loc3_);
      }
      
      public function hide() : void
      {
         if(this._runesRootView != null)
         {
            this._runesRootView.hide();
         }
      }
   }
}

