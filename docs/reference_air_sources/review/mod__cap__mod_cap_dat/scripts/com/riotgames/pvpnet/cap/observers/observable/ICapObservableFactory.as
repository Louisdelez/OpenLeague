package com.riotgames.pvpnet.cap.observers.observable
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public interface ICapObservableFactory
   {
      
      function createPlayerFullySpeccedObserver(param1:CapPlayerSelection) : IObservable;
      
      function createPlayerRolePositionSpeccedObserver(param1:CapPlayerSelection) : IObservable;
      
      function createMinPremadeSizeFulfilledObserver() : IObservable;
      
      function createInvitedPlayerFullySpeccedObserver(param1:CapPlayerSelection) : IObservable;
      
      function createPlayerAdvertisedRolePositionSpeccedObserver(param1:CapPlayerSelection) : IObservable;
      
      function createCapPlayerPresenceObserver() : IObservable;
      
      function createPlayerIsReadyObserver(param1:CapPlayerSelection) : IObservable;
   }
}

