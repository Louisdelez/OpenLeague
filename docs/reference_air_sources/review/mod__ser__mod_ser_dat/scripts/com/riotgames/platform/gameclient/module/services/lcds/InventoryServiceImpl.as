package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.UnexpectedServiceException;
   import com.riotgames.platform.common.exception.ValidationException;
   import com.riotgames.platform.common.services.InventoryService;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class InventoryServiceImpl extends BaseLcdsService implements InventoryService
   {
      
      public function InventoryServiceImpl()
      {
         super();
      }
      
      public function getAllRuneCombiners(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","getAllRuneCombiners",[],param1,param2);
      }
      
      public function getAvailableChampions(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","getAvailableChampions",[],param1,param2);
      }
      
      public function isStoreEnabled(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","isStoreEnabled",[],param1,param2);
      }
      
      public function useRuneCombiner(param1:Number, param2:ArrayCollection, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[UnexpectedServiceException] = param5;
         }
         invokeServiceWithoutSession("inventoryService","useRuneCombiner",[param1,param2],param4,param3,_loc6_);
      }
      
      public function useGrabBag(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[ValidationException] = param4;
         }
         invokeServiceWithoutSession("inventoryService","useGrabBag",[param1],param2,param3,_loc5_);
      }
      
      public function retrieveInventoryTypes(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","retrieveInventoryTypes",[],param1,param2);
      }
      
      public function giftFacebookFan(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","giftFacebookFan",[],param1,param2);
      }
      
      public function getSumonerActiveBoosts(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("inventoryService","getSumonerActiveBoosts",[],param1,param2);
      }
   }
}

