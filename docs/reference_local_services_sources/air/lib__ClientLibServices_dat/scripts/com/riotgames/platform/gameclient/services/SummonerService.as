package com.riotgames.platform.gameclient.services
{
   public interface SummonerService
   {
      
      function saveSocialNetworkFriendList(param1:Array, param2:Array, param3:String, param4:Function, param5:Function, param6:Function) : void;
      
      function checkSummonerName(param1:String, param2:Function, param3:Function) : void;
      
      function saveSeenTutorialFlag(param1:Function, param2:Function) : void;
      
      function getSummonerNames(param1:Array, param2:Function, param3:Function) : void;
      
      function saveSeenHelpFlag(param1:Function, param2:Function) : void;
      
      function getSummonerByName(param1:String, param2:Function, param3:Function) : void;
      
      function playerChangeSummonerName(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void;
      
      function getSocialNetworkFriends(param1:Function, param2:Function, param3:Function) : void;
      
      function getSummonerInternalNameByName(param1:String, param2:Function, param3:Function, param4:Function, param5:Object) : void;
      
      function getAllPublicSummonerDataByAccount(param1:Number, param2:Function, param3:Function) : void;
      
      function getAllSummonerDataByAccount(param1:Number, param2:Function, param3:Function) : void;
      
      function updateProfileIconId(param1:int, param2:Function, param3:Function) : void;
      
      function getSummonerCatalog(param1:Function, param2:Function) : void;
      
      function getSummonerIcons(param1:Array, param2:Function, param3:Function) : void;
      
      function resetTalents(param1:Number, param2:Function, param3:Function) : void;
      
      function changeTalentRankings(param1:Number, param2:Object, param3:Function, param4:Function) : void;
      
      function createDefaultSummoner(param1:String, param2:Function, param3:Function, param4:Function) : void;
      
      function updateSummonerSocialNetworkUser(param1:String, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : void;
      
      function getSocialNetworkUsers(param1:Array, param2:String, param3:Function, param4:Function, param5:Function) : void;
   }
}

