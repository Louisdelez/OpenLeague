package com.riotgames.gameItems.model
{
   public class ItemCategory
   {
      
      public var id:int;
      
      public var name:String;
      
      public var tags:Vector.<ItemTag> = new Vector.<ItemTag>();
      
      public function ItemCategory()
      {
         super();
      }
   }
}

