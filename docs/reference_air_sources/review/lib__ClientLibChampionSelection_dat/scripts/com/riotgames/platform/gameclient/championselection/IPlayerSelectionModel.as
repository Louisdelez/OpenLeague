package com.riotgames.platform.gameclient.championselection
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public interface IPlayerSelectionModel
   {
      
      function get champion() : Champion;
      
      function set champion(param1:Champion) : void;
      
      function get championChanged() : ISignal;
   }
}

