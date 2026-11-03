package com.riotgames.pvpnet.cap.observers.observable.group
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.BaseObservable;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class MinPremadeSizeFulfilledObserver extends BaseObservable implements IObservable
   {
      
      private var _model:CapModel;
      
      public function MinPremadeSizeFulfilledObserver(param1:CapModel)
      {
         this._model = param1;
         super();
      }
      
      override public function removeSignals() : void
      {
         var _loc1_:CapPlayerSelection = null;
         this._model.minPremadeSizeChanged.remove(refresh);
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            _loc1_.isInvitedPlayerChanged.remove(refresh);
         }
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return CapModelUtil.hasMinPremadeSize(this._model);
      }
      
      override public function setupSignals() : void
      {
         var _loc1_:CapPlayerSelection = null;
         this._model.minPremadeSizeChanged.add(refresh);
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            _loc1_.isInvitedPlayerChanged.add(refresh);
         }
      }
   }
}

