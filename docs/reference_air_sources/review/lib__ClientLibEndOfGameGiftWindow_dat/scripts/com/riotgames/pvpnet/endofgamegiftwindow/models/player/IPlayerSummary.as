package com.riotgames.pvpnet.endofgamegiftwindow.models.player
{
   public interface IPlayerSummary
   {
      
      function get summonerID() : Number;
      
      function get summonerName() : String;
      
      function get skinName() : String;
      
      function get isBuddy() : Boolean;
      
      function get playerLevel() : Number;
      
      function get gameID() : Number;
      
      function get queueType() : String;
   }
}

