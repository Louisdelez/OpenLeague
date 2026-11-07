package com.riotgames.gameItems.dao
{
   public interface IGameItemDao
   {
      
      function getAllGameItems(param1:Function, param2:Function) : void;
      
      function getAllGameItemsDictionary(param1:Function, param2:Function) : void;
      
      function getGameItemById(param1:int, param2:Function, param3:Function, ... rest) : void;
      
      function getGameItemsById(param1:Vector.<int>, param2:Function, param3:Function, ... rest) : void;
      
      function getGameItemCategories(param1:Function, param2:Function) : void;
   }
}

