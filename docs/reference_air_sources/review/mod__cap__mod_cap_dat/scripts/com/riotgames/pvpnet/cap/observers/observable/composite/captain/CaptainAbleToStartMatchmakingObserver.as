package com.riotgames.pvpnet.cap.observers.observable.composite.captain
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.composite.BaseCompositeObservable;
   import mx.collections.ArrayCollection;
   
   public class CaptainAbleToStartMatchmakingObserver extends BaseCompositeObservable
   {
      
      private var _isGroupOfOne:Boolean;
      
      public function CaptainAbleToStartMatchmakingObserver(param1:ArrayCollection, param2:ICapObservableFactory)
      {
         super(param1,param2);
      }
      
      override protected function createObservers(param1:ArrayCollection, param2:ArrayCollection) : void
      {
         var _loc4_:CapPlayerSelection = null;
         var _loc3_:Array = param2.source;
         for each(_loc4_ in _loc3_)
         {
            if(!_loc4_.isCaptain)
            {
               param1.addItem(observableFactory.createPlayerIsReadyObserver(_loc4_));
            }
         }
         this._isGroupOfOne = param1.length == 0;
      }
      
      override public function get isOccurring() : Boolean
      {
         return this._isGroupOfOne || super.isOccurring;
      }
   }
}

