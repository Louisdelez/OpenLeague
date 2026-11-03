package com.riotgames.pvpnet.itembrowser.sets.dao
{
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   
   internal class ItemSetCache
   {
      
      public var itemSets:Vector.<ItemSet>;
      
      public var timeStamp:int = 0;
      
      public var summonerId:Number = 0;
      
      public var raw:String;
      
      public function ItemSetCache()
      {
         super();
      }
      
      public function getIsValid() : Boolean
      {
         return this.raw != null && this.raw.length > 0 && this.itemSets != null;
      }
   }
}

