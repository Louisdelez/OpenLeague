package com.riotgames.pvpnet.cap.observers.observable.composite.captain
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.observers.observable.composite.BaseCompositeObservable;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import mx.collections.ArrayCollection;
   
   public class CaptainAbleToSpecCandidatesObserver extends BaseCompositeObservable
   {
      
      private var _model:CapModel;
      
      public function CaptainAbleToSpecCandidatesObserver(param1:CapModel, param2:ICapObservableFactory)
      {
         this._model = param1;
         super(param1.playerSelections,param2);
      }
      
      override protected function createObservers(param1:ArrayCollection, param2:ArrayCollection) : void
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc4_:IObservable = null;
         for each(_loc3_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            _loc4_ = _loc3_.isLocalPlayer ? observableFactory.createPlayerFullySpeccedObserver(_loc3_) : observableFactory.createInvitedPlayerFullySpeccedObserver(_loc3_);
            param1.addItem(_loc4_);
         }
         param1.addItem(observableFactory.createMinPremadeSizeFulfilledObserver());
      }
   }
}

