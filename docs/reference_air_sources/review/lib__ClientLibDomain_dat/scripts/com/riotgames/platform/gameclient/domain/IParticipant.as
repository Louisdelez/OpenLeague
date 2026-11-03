package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.game.IParticipant")]
   [Bindable]
   public interface IParticipant
   {
      
      function getPickTurn() : int;
      
      function getBadges() : int;
      
      function getPickMode() : int;
      
      function getSummonerInternalName() : String;
      
      function getSummonerName() : String;
   }
}

