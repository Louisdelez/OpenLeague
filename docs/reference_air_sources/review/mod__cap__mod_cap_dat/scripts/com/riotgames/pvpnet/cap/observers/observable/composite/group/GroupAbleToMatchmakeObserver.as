package com.riotgames.pvpnet.cap.observers.observable.composite.group
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.composite.BaseCompositeObservable;
   import mx.collections.ArrayCollection;
   
   public class GroupAbleToMatchmakeObserver extends BaseCompositeObservable
   {
      
      public function GroupAbleToMatchmakeObserver(param1:ArrayCollection, param2:ICapObservableFactory)
      {
         super(param1,param2);
      }
      
      override protected function createObservers(param1:ArrayCollection, param2:ArrayCollection) : void
      {
         var _loc3_:CapPlayerSelection = null;
         for each(_loc3_ in param2.source)
         {
            param1.addItem(observableFactory.createPlayerFullySpeccedObserver(_loc3_));
         }
      }
   }
}

