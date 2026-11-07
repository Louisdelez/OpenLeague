package com.riotgames.pvpnet.CLS.controllers
{
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   
   public interface ILeagueDecayMessageController
   {
      
      function processDecayMessages(param1:Vector.<LeagueItemDTO>, param2:Number = 0) : void;
      
      function getDecayTimeInHours(param1:Number) : Number;
      
      function getDecayTimeInDays(param1:Number) : Number;
      
      function shouldDisplayMessage(param1:LeagueItemDTO) : Boolean;
      
      function getProfileScreenDecayMessage(param1:String, param2:String = "") : Object;
      
      function processMiniSeriesEndedMessage(param1:Vector.<LeagueItemDTO>, param2:String, param3:String, param4:Number = 0) : void;
      
      function processDemotionMessage(param1:Vector.<LeagueItemDTO>, param2:String, param3:String, param4:Number = 0) : void;
   }
}

