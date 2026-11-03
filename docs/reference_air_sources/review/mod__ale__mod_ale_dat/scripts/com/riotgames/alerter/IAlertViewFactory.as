package com.riotgames.alerter
{
   import blix.action.IAction;
   
   public interface IAlertViewFactory
   {
      
      function showAlert(param1:IAction) : void;
      
      function hideAlert(param1:IAction) : void;
   }
}

