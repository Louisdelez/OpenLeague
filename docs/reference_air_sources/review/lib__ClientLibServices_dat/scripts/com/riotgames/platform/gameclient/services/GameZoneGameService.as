package com.riotgames.platform.gameclient.services
{
   public interface GameZoneGameService
   {
      
      function clearGameZoneConnection() : void;
      
      function quitGzGame(param1:Function, param2:Function, param3:Function) : void;
      
      function setGameServiceZone(param1:String, param2:int, param3:int) : void;
      
      function isGameZoneMatch(param1:String, param2:int, param3:int) : Boolean;
   }
}

