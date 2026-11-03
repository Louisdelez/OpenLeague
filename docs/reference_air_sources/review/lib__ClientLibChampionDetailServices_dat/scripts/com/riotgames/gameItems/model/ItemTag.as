package com.riotgames.gameItems.model
{
   public class ItemTag
   {
      
      public var tag:String;
      
      public var aliases:Vector.<String> = new Vector.<String>();
      
      public function ItemTag(param1:String)
      {
         super();
         this.tag = param1;
      }
      
      public function addAlias(param1:String) : void
      {
         if(param1.length > 0)
         {
            this.aliases.push(param1);
         }
      }
      
      public function match(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(param1 == this.tag)
         {
            return true;
         }
         for each(_loc2_ in this.aliases)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
   }
}

