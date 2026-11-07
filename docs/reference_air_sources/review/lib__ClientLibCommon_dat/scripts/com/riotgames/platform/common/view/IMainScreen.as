package com.riotgames.platform.common.view
{
   import blix.signals.ISignal;
   
   public interface IMainScreen
   {
      
      function destroy() : void;
      
      function hide() : void;
      
      function getHideCompleted() : ISignal;
      
      function getHasNavigation() : Boolean;
      
      function getIsThinChrome() : Boolean;
      
      function show() : void;
   }
}

