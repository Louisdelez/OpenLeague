package com.riotgames.pvpnet.system.product
{
   import blix.signals.ISignal;
   
   public interface IMultiProductProvider
   {
      
      function getProducts() : Vector.<IProductProvider>;
      
      function getCurrentProduct() : IProductProvider;
      
      function setCurrentProduct(param1:IProductProvider) : void;
      
      function setCurrentProductByName(param1:String) : Boolean;
      
      function getCurrentProductChanged() : ISignal;
   }
}

