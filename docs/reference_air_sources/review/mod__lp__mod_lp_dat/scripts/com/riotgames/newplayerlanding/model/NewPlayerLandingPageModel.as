package com.riotgames.newplayerlanding.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class NewPlayerLandingPageModel
   {
      
      private var _activeCarouselIndex:int = 0;
      
      private var _activeCarouselIndexChanged:Signal = new Signal();
      
      public function NewPlayerLandingPageModel()
      {
         super();
      }
      
      public function getActiveCarouselIndex() : int
      {
         return this._activeCarouselIndex;
      }
      
      public function setActiveCarouselIndex(param1:int) : void
      {
         var _loc2_:int = this._activeCarouselIndex;
         this._activeCarouselIndex = param1;
         this._activeCarouselIndexChanged.dispatch(_loc2_,this._activeCarouselIndex);
      }
      
      public function getActiveCarouselIndexChanged() : ISignal
      {
         return this._activeCarouselIndexChanged;
      }
   }
}

