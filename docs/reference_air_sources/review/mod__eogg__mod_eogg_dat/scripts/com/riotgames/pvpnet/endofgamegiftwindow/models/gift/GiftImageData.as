package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   import blix.IDestructible;
   
   public class GiftImageData implements IDestructible
   {
      
      private var _imageLocation:String;
      
      private var _imageType:String;
      
      public function GiftImageData(param1:String, param2:String)
      {
         super();
         this._imageLocation = param1;
         this._imageType = param2;
      }
      
      public function get imageLocation() : String
      {
         return this._imageLocation;
      }
      
      public function get imageType() : String
      {
         return this._imageType;
      }
      
      public function destroy() : void
      {
         this._imageLocation = null;
         this._imageType = null;
      }
   }
}

