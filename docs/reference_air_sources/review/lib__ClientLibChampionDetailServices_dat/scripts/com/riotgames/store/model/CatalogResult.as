package com.riotgames.store.model
{
   import blix.util.string.parseBool;
   
   public class CatalogResult
   {
      
      public var catalog:Vector.<Catalog>;
      
      public var lastModified:Date;
      
      public var error:Number;
      
      public var errorMessage:String;
      
      public var rentalStatus:Boolean;
      
      public function CatalogResult()
      {
         super();
      }
      
      public static function unmarshall(param1:Object) : CatalogResult
      {
         var _loc3_:Object = null;
         var _loc2_:CatalogResult = new CatalogResult();
         _loc2_.error = parseFloat(param1.error);
         _loc2_.catalog = new Vector.<Catalog>();
         for each(_loc3_ in param1.catalog)
         {
            _loc2_.catalog[_loc2_.catalog.length] = Catalog.unmarshall(_loc3_);
         }
         _loc2_.lastModified = new Date(parseFloat(param1.last_modified) * 1000);
         _loc2_.errorMessage = String(param1.error_message);
         if("rental_status" in param1)
         {
            _loc2_.rentalStatus = parseBool(param1.rental_status);
         }
         return _loc2_;
      }
      
      public function getCatalogByItemId(param1:String) : Catalog
      {
         var _loc2_:Catalog = null;
         for each(_loc2_ in this.catalog)
         {
            if(_loc2_.item.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getSkinsForChampion(param1:Catalog) : Vector.<Catalog>
      {
         var _loc4_:Catalog = null;
         var _loc2_:String = param1.item.id;
         var _loc3_:Vector.<Catalog> = new Vector.<Catalog>();
         for each(_loc4_ in this.catalog)
         {
            if(_loc4_.item.groups != null)
            {
               if(_loc4_.item.groups.champion != null)
               {
                  if(_loc2_ in _loc4_.item.groups.champion)
                  {
                     _loc3_[_loc3_.length] = _loc4_;
                  }
               }
            }
         }
         return _loc3_;
      }
   }
}

