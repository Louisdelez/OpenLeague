package com.riotgames.rust.asset
{
   import blix.assets.AssetsLoader;
   
   public class RustAssetLoader extends AssetsLoader
   {
      
      protected var _assetLinkagePostfix:String = null;
      
      public function RustAssetLoader()
      {
         super();
      }
      
      override public function getAssetByLinkage(param1:String, param2:* = null) : Class
      {
         var _loc3_:Class = null;
         if(this._assetLinkagePostfix != null)
         {
            _loc3_ = super.getAssetByLinkage(param1 + this._assetLinkagePostfix,param2);
            if(_loc3_ == null)
            {
               _loc3_ = super.getAssetByLinkage(param1,param2);
            }
            return _loc3_;
         }
         return super.getAssetByLinkage(param1,param2);
      }
      
      public function setAssetLinkagePostfix(param1:String) : void
      {
         this._assetLinkagePostfix = param1;
      }
   }
}

