package com.riotgames.pvpnet.itembrowser.sets.service
{
   public interface IItemSetsService
   {
      
      function saveItemSets(param1:String, param2:Function) : void;
      
      function getAllItemSetsForPlayer(param1:Number, param2:Function) : void;
      
      function getAllMyItemSets(param1:Function) : void;
   }
}

