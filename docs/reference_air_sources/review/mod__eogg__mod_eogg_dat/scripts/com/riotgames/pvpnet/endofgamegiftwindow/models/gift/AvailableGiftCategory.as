package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   import blix.IDestructible;
   
   public class AvailableGiftCategory implements IDestructible
   {
      
      private var _categoryTitle:String;
      
      private var _giftType:String;
      
      private var _bucketIsEnabled:Boolean;
      
      private var _giftList:Vector.<IEndOfGameGift>;
      
      public function AvailableGiftCategory(param1:String, param2:String, param3:Boolean)
      {
         super();
         this._categoryTitle = param1;
         this._giftType = param2;
         this._bucketIsEnabled = param3;
         this._giftList = new Vector.<IEndOfGameGift>();
      }
      
      public function addGift(param1:IEndOfGameGift) : void
      {
         this._giftList.push(param1);
      }
      
      public function get giftBucketHeaderData() : GiftBucketHeaderData
      {
         return new GiftBucketHeaderData(this._categoryTitle,this._giftType,this._bucketIsEnabled,this._giftList.length);
      }
      
      public function get giftList() : Vector.<IEndOfGameGift>
      {
         return this._giftList;
      }
      
      public function destroy() : void
      {
         var _loc1_:IEndOfGameGift = null;
         while(this._giftList.length > 0)
         {
            _loc1_ = this._giftList.shift();
            _loc1_ = null;
         }
         this._giftList = null;
      }
   }
}

