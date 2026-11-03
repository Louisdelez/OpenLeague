package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import com.riotgames.platform.common.provider.IStoreImagesProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftCurrencies;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.ImageTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.EndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import flash.utils.Dictionary;
   
   public class GiftListValueObjectFactory implements IGiftListValueObjectFactory
   {
      
      private const PROPERTY_NAME_ITEM_ID:String = "itemId";
      
      private const PROPERTY_NAME_INVENTORY_TYPE:String = "inventoryType";
      
      private const PROPERTY_NAME_RP_COST:String = "rpCost";
      
      private const PROPERTY_NAME_IP_COST:String = "ipCost";
      
      private const PROPERTY_NAME_ICON_URL:String = "iconUrl";
      
      private const PROPERTY_NAME_NAME:String = "name";
      
      private const PROPERTY_NAME_DESCRIPTION:String = "description";
      
      private var _propertiesDictionary:Dictionary;
      
      private var _storeImages:IStoreImagesProvider;
      
      public function GiftListValueObjectFactory()
      {
         super();
         this._propertiesDictionary = new Dictionary();
         this._propertiesDictionary[this.PROPERTY_NAME_ITEM_ID] = Number;
         this._propertiesDictionary[this.PROPERTY_NAME_INVENTORY_TYPE] = String;
         this._propertiesDictionary[this.PROPERTY_NAME_RP_COST] = Number;
         this._propertiesDictionary[this.PROPERTY_NAME_ICON_URL] = String;
         this._propertiesDictionary[this.PROPERTY_NAME_NAME] = String;
         this._propertiesDictionary[this.PROPERTY_NAME_DESCRIPTION] = String;
         ProviderLookup.getProvider(IStoreImagesProvider,this.onStoreImagesProviderReceived);
      }
      
      public function validateEndOfGameGiftDTO(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         for(_loc3_ in this._propertiesDictionary)
         {
            _loc2_ = this.validatePropertyNameAndType(param1,_loc3_,this._propertiesDictionary[_loc3_]);
         }
         return _loc2_;
      }
      
      public function validateSentGiftDTO(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc4_:String = null;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_[this.PROPERTY_NAME_ITEM_ID] = Number;
         _loc3_[this.PROPERTY_NAME_INVENTORY_TYPE] = String;
         _loc3_[this.PROPERTY_NAME_ICON_URL] = String;
         _loc3_[this.PROPERTY_NAME_NAME] = String;
         _loc3_[this.PROPERTY_NAME_DESCRIPTION] = String;
         for(_loc4_ in _loc3_)
         {
            _loc2_ = this.validatePropertyNameAndType(param1,_loc4_,_loc3_[_loc4_]);
         }
         _loc3_ = null;
         return _loc2_;
      }
      
      public function parseEndOfGameGift(param1:Object) : IEndOfGameGift
      {
         return this.constructIEndOfGameGift(param1[this.PROPERTY_NAME_INVENTORY_TYPE],param1[this.PROPERTY_NAME_ITEM_ID],param1[this.PROPERTY_NAME_NAME],param1[this.PROPERTY_NAME_DESCRIPTION],param1[this.PROPERTY_NAME_RP_COST],param1[this.PROPERTY_NAME_ICON_URL]);
      }
      
      public function parseSentGift(param1:Object) : IEndOfGameGift
      {
         return this.constructIEndOfGameGift(param1[this.PROPERTY_NAME_INVENTORY_TYPE],param1[this.PROPERTY_NAME_ITEM_ID],param1[this.PROPERTY_NAME_NAME],param1[this.PROPERTY_NAME_DESCRIPTION],0,param1[this.PROPERTY_NAME_ICON_URL]);
      }
      
      public function validatePropertyNameAndType(param1:Object, param2:String, param3:Class) : Boolean
      {
         if(param1.hasOwnProperty(param2))
         {
            if(param1[param2] is param3)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onStoreImagesProviderReceived(param1:IStoreImagesProvider) : void
      {
         this._storeImages = param1;
      }
      
      private function constructIEndOfGameGift(param1:String, param2:Number, param3:String, param4:String, param5:Number, param6:String) : IEndOfGameGift
      {
         var _loc7_:String = GiftTypes.getGiftType(param1);
         var _loc8_:String = this.constructItemDetailURL(param6,param2,_loc7_);
         return new EndOfGameGift(_loc7_,param2,param3,param4,GiftCurrencies.CURRENCY_RP,param5,param6,_loc8_);
      }
      
      private function constructItemDetailURL(param1:String, param2:Number, param3:String) : String
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         switch(param3)
         {
            case GiftTypes.GIFT_TYPE_CHAMPION:
               return param1;
            case GiftTypes.GIFT_TYPE_SKIN:
               _loc4_ = this.getChampIDFromItemID(param2);
               _loc5_ = this.getSkinIndexFromItemID(param2);
               return this._storeImages.getChampSkinPortraitAssetNameFromChampIDAndSkinIndex(_loc4_,_loc5_);
            case GiftTypes.GIFT_TYPE_MYSTERY:
            case GiftTypes.GIFT_TYPE_MYSTERY_CHAMPION:
            case GiftTypes.GIFT_TYPE_MYSTERY_SKIN:
         }
         return this._storeImages.getMysteryGiftPortraitAssetPath();
      }
      
      private function getChampIDFromItemID(param1:Number) : Number
      {
         return ImageTypes.getChampIDFromItemID(param1);
      }
      
      private function getSkinIndexFromItemID(param1:Number) : Number
      {
         return ImageTypes.getSkinIndexFromItemID(param1);
      }
   }
}

