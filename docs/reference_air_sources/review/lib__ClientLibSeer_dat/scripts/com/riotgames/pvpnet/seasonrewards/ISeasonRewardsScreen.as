package com.riotgames.pvpnet.seasonrewards
{
   import blix.signals.Signal;
   
   public interface ISeasonRewardsScreen
   {
      
      function get closeButtonSignal() : Signal;
      
      function processRewardsAndInitialize() : void;
   }
}

