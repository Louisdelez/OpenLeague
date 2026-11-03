package com.riotgames.pvpnet.itembrowser.sets.dao
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.service.IItemSetsService;
   import flash.utils.getTimer;
   
   public class LoadMyItemStatsAction extends BasicAction
   {
      
      private var _cacheTimeout:int;
      
      public var data:Vector.<ItemSet>;
      
      private var _service:IItemSetsService;
      
      private var _selfCache:ItemSetCache;
      
      private var _unmarshallFunction:Function;
      
      public function LoadMyItemStatsAction(param1:IItemSetsService, param2:ItemSetCache, param3:Function, param4:int = 30000)
      {
         super(false);
         this._service = param1;
         this._selfCache = param2;
         this._unmarshallFunction = param3;
         this._cacheTimeout = param4;
      }
      
      private function successCallback(param1:String) : void
      {
         this.data = this._unmarshallFunction(param1);
         complete();
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:int = getTimer();
         if(this._selfCache != null && this._selfCache.timeStamp - _loc1_ < this._cacheTimeout && this._selfCache.timeStamp > 0)
         {
            this.data = this._selfCache.itemSets;
            complete();
         }
         else
         {
            this._service.getAllMyItemSets(this.successCallback);
         }
      }
   }
}

