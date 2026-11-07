package com.riotgames.store.model
{
   public class Catalog
   {
      
      public var itemFeaturedSchedule:Vector.<ItemFeatureSchedule>;
      
      public var itemRentals:Vector.<ItemRental>;
      
      public var itemPricingSchedule:Vector.<ItemPricingSchedule>;
      
      public var item:CatalogItem;
      
      public var bundleItems:Vector.<BundleItem>;
      
      public function Catalog()
      {
         super();
      }
      
      public static function unmarshall(param1:Object) : Catalog
      {
         var _loc3_:Object = null;
         var _loc2_:Catalog = new Catalog();
         _loc2_.bundleItems = new Vector.<BundleItem>();
         for each(_loc3_ in param1.BundleItems)
         {
            _loc2_.bundleItems[_loc2_.bundleItems.length] = BundleItem.unmarshall(_loc3_);
         }
         _loc2_.item = CatalogItem.unmarshall(param1.Item);
         _loc2_.itemRentals = new Vector.<ItemRental>();
         for each(_loc3_ in param1.ItemRentals)
         {
            _loc2_.itemRentals[_loc2_.itemRentals.length] = ItemRental.unmarshall(_loc3_);
         }
         _loc2_.itemPricingSchedule = new Vector.<ItemPricingSchedule>();
         for each(_loc3_ in param1.ItemPricingSchedule)
         {
            _loc2_.itemPricingSchedule[_loc2_.itemPricingSchedule.length] = ItemPricingSchedule.unmarshall(_loc3_);
         }
         _loc2_.itemFeaturedSchedule = new Vector.<ItemFeatureSchedule>();
         for each(_loc3_ in param1.ItemFeaturedSchedule)
         {
            _loc2_.itemFeaturedSchedule[_loc2_.itemFeaturedSchedule.length] = ItemFeatureSchedule.unmarshall(_loc3_);
         }
         return _loc2_;
      }
   }
}

