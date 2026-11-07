package com.riotgames.landing
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class LobbyLandingPageProxy extends ProviderProxyBase implements ILobbyLandingPage
   {
      
      private static var _instance:LobbyLandingPageProxy;
      
      public function LobbyLandingPageProxy()
      {
         super(ILobbyLandingPage);
      }
      
      public static function get instance() : LobbyLandingPageProxy
      {
         if(_instance == null)
         {
            _instance = new LobbyLandingPageProxy();
         }
         return _instance;
      }
      
      public function configureLandingPage(param1:Object) : void
      {
         _invoke("configureLandingPage",[param1]);
      }
      
      public function showLandingPage(param1:DisplayAdapter) : void
      {
         _invoke("showLandingPage",[param1]);
      }
      
      public function getReady() : ISignal
      {
         return _getSignal("getReady");
      }
      
      public function getJsonNavigate() : ISignal
      {
         return _getSignal("getJsonNavigate");
      }
      
      public function getSpectateFeaturedGame() : ISignal
      {
         return _getSignal("getSpectateFeaturedGame");
      }
   }
}

