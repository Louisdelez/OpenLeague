package com.riotgames.pvpnet.system.product
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   
   public interface IProductProvider
   {
      
      function initializeProduct(param1:IMultiProductProvider) : void;
      
      function productClickedCallback() : void;
      
      function getProductInitialized() : IOnceSignal;
      
      function getName() : String;
      
      function getChrome() : IProductChrome;
      
      function getProductButton() : DisplayObjectProxy;
      
      function getIsPatched() : Boolean;
      
      function getIsPatchedChanged() : ISignal;
      
      function getIsLoggedIn() : Boolean;
      
      function getIsLoggedInChanged() : ISignal;
   }
}

