package com.riotgames.pvpnet.tournament
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObjectContainer;
   
   public class TournamentCodeProviderProxy extends ProviderProxyBase implements ITournamentCodeProvider
   {
      
      private static var _instance:TournamentCodeProviderProxy;
      
      public function TournamentCodeProviderProxy()
      {
         super(ITournamentCodeProvider);
      }
      
      public static function get instance() : TournamentCodeProviderProxy
      {
         if(_instance == null)
         {
            _instance = new TournamentCodeProviderProxy();
         }
         return _instance;
      }
      
      public function initialize(param1:Array, param2:Array) : void
      {
         _invoke("initialize",[param1,param2]);
      }
      
      public function showTournamentCodePanel(param1:DisplayObjectContainer) : void
      {
         _invoke("showTournamentCodePanel",[param1]);
      }
   }
}

