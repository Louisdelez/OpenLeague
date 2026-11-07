package com.riotgames.pvpnet.itembrowser.sets.service
{
   import com.riotgames.platform.common.services.IRemoteExceptionFactory;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.utils.Dictionary;
   
   public class ItemSetsService implements IItemSetsService, IBaseLcdsService
   {
      
      public function ItemSetsService(param1:IBaseLcdsService)
      {
         super();
      }
      
      public function saveItemSets(param1:String, param2:Function) : void
      {
      }
      
      public function setRemoteExceptionFactory(param1:IRemoteExceptionFactory) : void
      {
      }
      
      public function invokeServiceWithoutSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void
      {
      }
      
      public function invokeServiceWithSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void
      {
      }
      
      public function getAllMyItemSets(param1:Function) : void
      {
      }
      
      public function getAllItemSetsForPlayer(param1:Number, param2:Function) : void
      {
      }
   }
}

