package com.riotgames.pvpnet.cap.views
{
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class CapModuleView extends RiotModuleView implements IMainScreen
   {
      
      private static const ASSETS_URL:String = "assets/capAssets.swf";
      
      private var _capView:CapView;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _model:CapModel;
      
      public function CapModuleView(param1:IContext, param2:RiotModuleInfo)
      {
         this._moduleInfo = param2;
         super(param1);
         setLinkage("GroupFinderView");
      }
      
      public function hide() : void
      {
         if(this._assetsUrlRequest)
         {
            unloadAssets(this._assetsUrlRequest);
         }
         this._hideCompleted.dispatch();
      }
      
      public function getHasNavigation() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         this._capView = new CapView(this,null);
      }
      
      override public function destroy() : void
      {
         getAssetChanged().removeAll();
         this._hideCompleted.removeAll();
         this._capView.destroy();
         super.destroy();
      }
      
      public function get capView() : CapView
      {
         return this._capView;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._model = getDependency(CapModel);
      }
      
      private function onAssetsLoaded() : void
      {
         this._capView.setAsset(getAsset() as MovieClip);
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function show() : void
      {
         getAssetChanged().addOnce(this.onAssetsLoaded);
         if(!this._assetsUrlRequest)
         {
            this._assetsUrlRequest = new URLRequest(this._moduleInfo.getPath() + ASSETS_URL);
         }
         loadAssets(this._assetsUrlRequest);
      }
   }
}

