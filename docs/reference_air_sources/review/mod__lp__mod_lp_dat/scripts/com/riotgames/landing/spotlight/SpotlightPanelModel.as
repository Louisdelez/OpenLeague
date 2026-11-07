package com.riotgames.landing.spotlight
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class SpotlightPanelModel
   {
      
      public var videoSpotlightModels:Vector.<VideoSpotlightModel>;
      
      protected var _currentVideoIndexChanged:Signal = new Signal();
      
      protected var _currentVideoIndex:int;
      
      public function SpotlightPanelModel()
      {
         super();
      }
      
      public function getCurrentVideoIndexChanged() : ISignal
      {
         return this._currentVideoIndexChanged;
      }
      
      public function getCurrentVideoIndex() : int
      {
         return this._currentVideoIndex;
      }
      
      public function setCurrentVideoIndex(param1:int) : void
      {
         if(this._currentVideoIndex == param1)
         {
            return;
         }
         var _loc2_:int = this._currentVideoIndex;
         this._currentVideoIndex = param1;
         this._currentVideoIndexChanged.dispatch(this,_loc2_,this._currentVideoIndex);
      }
   }
}

