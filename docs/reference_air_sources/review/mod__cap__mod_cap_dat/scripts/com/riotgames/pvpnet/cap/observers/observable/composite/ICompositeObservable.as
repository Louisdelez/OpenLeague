package com.riotgames.pvpnet.cap.observers.observable.composite
{
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   
   public interface ICompositeObservable extends IObservable
   {
      
      function rebuild() : void;
   }
}

