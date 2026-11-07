package com.riotgames.store.model
{
   public class PurchaseItemParams
   {
      
      public var currencyType:String = "ip";
      
      public var catalog:Catalog;
      
      public var duration:Number = 0;
      
      public var durationType:String = "PURCHASED";
      
      public var quantity:uint = 1;
      
      public function PurchaseItemParams()
      {
         super();
      }
   }
}

