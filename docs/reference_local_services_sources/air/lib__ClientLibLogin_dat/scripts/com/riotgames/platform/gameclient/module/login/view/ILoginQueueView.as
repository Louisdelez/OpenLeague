package com.riotgames.platform.gameclient.module.login.view
{
   import blix.signals.ISignal;
   
   public interface ILoginQueueView
   {
      
      function getDismissButtonClicked() : ISignal;
      
      function get showingLoginQueueView() : Boolean;
      
      function updateLoginQueueViewForSeconds(param1:Number, param2:int, param3:int) : void;
      
      function updateLoginStatusText(param1:String, param2:String) : void;
      
      function updateLoginQueueViewForIndefinite(param1:Number, param2:int) : void;
      
      function showLoginQueueView(param1:Boolean, param2:Function, param3:Function) : void;
      
      function updateLoginQueueViewForHours(param1:Number, param2:int, param3:int, param4:int) : void;
      
      function updateLoginQueueViewForMinutes(param1:Number, param2:int, param3:int, param4:int) : void;
      
      function showAuthSuccess() : void;
      
      function hideLoginQueueView() : void;
   }
}

