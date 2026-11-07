package com.riotgames.pvpnet.endofgamegiftwindow.models.player
{
   public interface ISessionPlayer
   {
      
      function get accountID() : Number;
      
      function get summonerID() : Number;
      
      function get summonerName() : String;
      
      function get playerLevel() : Number;
      
      function get localeString() : String;
      
      function get rp() : Number;
      
      function get giftsSentThisSession() : Number;
      
      function set giftsSentThisSession(param1:Number) : void;
   }
}

