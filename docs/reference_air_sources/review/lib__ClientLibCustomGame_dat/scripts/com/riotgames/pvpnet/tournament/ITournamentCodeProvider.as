package com.riotgames.pvpnet.tournament
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface ITournamentCodeProvider extends IProvider
   {
      
      function initialize(param1:Array, param2:Array) : void;
      
      function showTournamentCodePanel(param1:DisplayObjectContainer) : void;
   }
}

