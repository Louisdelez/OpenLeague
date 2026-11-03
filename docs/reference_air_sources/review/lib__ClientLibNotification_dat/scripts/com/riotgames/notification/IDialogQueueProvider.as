package com.riotgames.notification
{
   import blix.action.IAction;
   
   [GenerateProxy]
   public interface IDialogQueueProvider
   {
      
      function getAllDialogs() : Vector.<IAction>;
      
      function removeActiveDialogs() : void;
      
      function addDialog(param1:IAction) : void;
      
      function removeDialog(param1:IAction) : void;
      
      function getActiveDialogs() : Vector.<IAction>;
   }
}

