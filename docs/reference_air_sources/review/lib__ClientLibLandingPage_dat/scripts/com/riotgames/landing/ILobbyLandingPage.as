package com.riotgames.landing
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILobbyLandingPage extends IProvider
   {
      
      function configureLandingPage(param1:Object) : void;
      
      function showLandingPage(param1:DisplayAdapter) : void;
      
      function getReady() : ISignal;
      
      function getJsonNavigate() : ISignal;
      
      function getSpectateFeaturedGame() : ISignal;
   }
}

