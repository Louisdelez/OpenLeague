package com.riotgames.platform.gameclient.module.login.view
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.module.login.controller.AuthenticationFailureMessage;
   import flash.events.IEventDispatcher;
   
   public interface ILoginView
   {
      
      function displayAuthFailure(param1:AuthenticationFailureMessage) : void;
      
      function outroComplete() : ISignal;
      
      function retryWaitStart(param1:int) : void;
      
      function displayLoginStatusText(param1:String, param2:String) : void;
      
      function get dispatcher() : IEventDispatcher;
      
      function onLoginSuccess() : void;
      
      function displayAccountBanned(param1:String, param2:Date) : void;
      
      function displayPasswordResetAlert() : void;
      
      function set loginAllowed(param1:Boolean) : void;
      
      function getLoginStatusPane() : ILoginQueueView;
      
      function onLoginPostQueue() : void;
      
      function onLoginQueueEntered() : void;
      
      function retryWaitOver() : void;
      
      function displayLoginFailed(param1:String, param2:Array) : void;
      
      function displayBlockedFromPlatformAlert() : void;
      
      function set busyLoggingIn(param1:Boolean) : void;
      
      function onLoginPreQueue() : void;
      
      function onLoginQueueCancelled() : void;
      
      function retryWaitTick(param1:int) : void;
      
      function setInGame(param1:Boolean) : void;
      
      function displayServerBusy() : void;
   }
}

