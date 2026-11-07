package com.riotgames.store.dao
{
   import com.riotgames.store.model.PurchaseItemParams;
   
   public interface IStoreCatalogDao
   {
      
      function getCatalogForUser(param1:Function, param2:Function) : void;
      
      function purchaseItem(param1:PurchaseItemParams, param2:Function, param3:Function) : void;
   }
}

