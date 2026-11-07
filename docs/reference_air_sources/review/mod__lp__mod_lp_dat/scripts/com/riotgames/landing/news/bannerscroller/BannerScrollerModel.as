package com.riotgames.landing.news.bannerscroller
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class BannerScrollerModel
   {
      
      public var bannerItemModels:Vector.<BannerItemModel>;
      
      protected var _currentBannerIndexChanged:Signal = new Signal();
      
      protected var _currentBannerIndex:int = 0;
      
      public function BannerScrollerModel()
      {
         super();
      }
      
      public function getCurrentBannerIndexChanged() : ISignal
      {
         return this._currentBannerIndexChanged;
      }
      
      public function getCurrentBannerIndex() : int
      {
         return this._currentBannerIndex;
      }
      
      public function setCurrentBannerIndex(param1:int) : void
      {
         if(this._currentBannerIndex == param1)
         {
            return;
         }
         var _loc2_:int = this._currentBannerIndex;
         this._currentBannerIndex = param1;
         this._currentBannerIndexChanged.dispatch(this,_loc2_,this._currentBannerIndex);
      }
   }
}

