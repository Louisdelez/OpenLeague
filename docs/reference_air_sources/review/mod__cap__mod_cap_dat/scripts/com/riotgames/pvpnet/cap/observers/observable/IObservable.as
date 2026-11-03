package com.riotgames.pvpnet.cap.observers.observable
{
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   
   public interface IObservable extends IObserver
   {
      
      function get isOccurring() : Boolean;
      
      function get occurred() : ISignal;
   }
}

