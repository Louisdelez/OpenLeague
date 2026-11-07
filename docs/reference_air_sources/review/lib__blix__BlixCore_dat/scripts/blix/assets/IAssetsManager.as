package blix.assets
{
   import blix.signals.ISignal;
   
   public interface IAssetsManager
   {
      
      function getAssetsChanged() : ISignal;
      
      function getAssetByLinkage(param1:String, param2:* = null) : Class;
   }
}

