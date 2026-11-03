package com.riotgames.store.model
{
   public class ItemRental
   {
      
      public function ItemRental()
      {
         super();
      }
      
      public static function unmarshall(param1:Object) : ItemRental
      {
         return new ItemRental();
      }
   }
}

