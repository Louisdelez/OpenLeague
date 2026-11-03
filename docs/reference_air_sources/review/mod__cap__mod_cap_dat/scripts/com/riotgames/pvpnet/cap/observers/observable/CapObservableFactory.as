package com.riotgames.pvpnet.cap.observers.observable
{
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.group.CapPlayerPresenceObserver;
   import com.riotgames.pvpnet.cap.observers.observable.group.MinPremadeSizeFulfilledObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.InvitedPlayerFullySpeccedObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerAdvertisedRolePositionSpeccedObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerFullySpeccedObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerIsReadyObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerRolePositionSpeccedObserver;
   
   public class CapObservableFactory implements ICapObservableFactory
   {
      
      private var _model:CapModel;
      
      private var _actionFactory:ICapActionFactory;
      
      public function CapObservableFactory(param1:CapModel, param2:ICapActionFactory)
      {
         super();
         this._model = param1;
         this._actionFactory = param2;
      }
      
      public function createPlayerRolePositionSpeccedObserver(param1:CapPlayerSelection) : IObservable
      {
         return new PlayerRolePositionSpeccedObserver(param1);
      }
      
      public function createInvitedPlayerFullySpeccedObserver(param1:CapPlayerSelection) : IObservable
      {
         return new InvitedPlayerFullySpeccedObserver(param1);
      }
      
      public function createPlayerAdvertisedRolePositionSpeccedObserver(param1:CapPlayerSelection) : IObservable
      {
         return new PlayerAdvertisedRolePositionSpeccedObserver(param1);
      }
      
      public function createCapPlayerPresenceObserver() : IObservable
      {
         return new CapPlayerPresenceObserver(this._actionFactory,this._model);
      }
      
      public function createPlayerFullySpeccedObserver(param1:CapPlayerSelection) : IObservable
      {
         return new PlayerFullySpeccedObserver(param1);
      }
      
      public function createMinPremadeSizeFulfilledObserver() : IObservable
      {
         return new MinPremadeSizeFulfilledObserver(this._model);
      }
      
      public function createPlayerIsReadyObserver(param1:CapPlayerSelection) : IObservable
      {
         return new PlayerIsReadyObserver(param1);
      }
   }
}

