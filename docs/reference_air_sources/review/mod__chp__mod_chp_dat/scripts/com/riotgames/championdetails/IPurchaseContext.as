package com.riotgames.championdetails
{
   import com.riotgames.store.model.Catalog;
   import flash.net.URLRequest;
   
   public interface IPurchaseContext
   {
      
      function openPurchaseScreen(param1:Catalog, param2:URLRequest) : void;
   }
}

