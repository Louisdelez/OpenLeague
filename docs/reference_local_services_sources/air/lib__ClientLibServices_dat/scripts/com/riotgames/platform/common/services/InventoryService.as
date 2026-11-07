package com.riotgames.platform.common.services
{
   import mx.collections.ArrayCollection;
   
   public interface InventoryService
   {
      
      function useRuneCombiner(param1:Number, param2:ArrayCollection, param3:Function, param4:Function, param5:Function) : void;
      
      function useGrabBag(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function getAvailableChampions(param1:Function, param2:Function) : void;
      
      function retrieveInventoryTypes(param1:Function, param2:Function) : void;
      
      function isStoreEnabled(param1:Function, param2:Function) : void;
      
      function getAllRuneCombiners(param1:Function, param2:Function, param3:Function) : void;
      
      function giftFacebookFan(param1:Function, param2:Function) : void;
      
      function getSumonerActiveBoosts(param1:Function, param2:Function) : void;
   }
}

