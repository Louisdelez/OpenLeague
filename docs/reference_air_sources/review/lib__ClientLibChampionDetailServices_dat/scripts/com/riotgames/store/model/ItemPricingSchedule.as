package com.riotgames.store.model
{
   public class ItemPricingSchedule
   {
      
      public function ItemPricingSchedule()
      {
         super();
      }
      
      public static function unmarshall(param1:Object) : ItemPricingSchedule
      {
         return new ItemPricingSchedule();
      }
   }
}

