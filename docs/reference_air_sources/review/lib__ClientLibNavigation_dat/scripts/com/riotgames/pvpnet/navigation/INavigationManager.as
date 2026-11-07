package com.riotgames.pvpnet.navigation
{
   import blix.signals.ISignal;
   
   public interface INavigationManager
   {
      
      function getModalDialogPathChanged() : ISignal;
      
      function navigate(param1:String) : void;
      
      function navigateToLast() : void;
      
      function modalDialog(param1:String) : void;
      
      function getPathChanged() : ISignal;
      
      function getPath() : String;
      
      [ArrayElementType("String")]
      function getPathSplit() : Array;
   }
}

