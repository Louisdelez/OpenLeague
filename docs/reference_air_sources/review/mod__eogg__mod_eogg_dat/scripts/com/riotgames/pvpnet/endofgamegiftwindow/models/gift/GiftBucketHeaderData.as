package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftBucketHeaderData
   {
      
      private var _bucketTitle:String;
      
      private var _giftBucketType:String;
      
      private var _isEnabled:Boolean;
      
      private var _numSubItems:int;
      
      public function GiftBucketHeaderData(param1:String, param2:String, param3:Boolean, param4:int)
      {
         super();
         this._bucketTitle = param1;
         this._giftBucketType = param2;
         this._isEnabled = param3;
         this._numSubItems = param4;
      }
      
      public function get bucketTitle() : String
      {
         return this._bucketTitle;
      }
      
      public function get giftBucketType() : String
      {
         return this._giftBucketType;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function get numSubItems() : int
      {
         return this._numSubItems;
      }
   }
}

