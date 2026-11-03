package com.riotgames.rust.components.sidebar
{
   import blix.signals.ISignal;
   
   public interface INestedScreen
   {
      
      function show() : void;
      
      function getHideCompleted() : ISignal;
      
      function hide() : void;
      
      function destroy() : void;
   }
}

