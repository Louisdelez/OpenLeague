package com.riotgames.pvpnet.endofgamegiftwindow.services
{
   public class EndOfGameGiftServiceResponseTypes
   {
      
      public static const DEFAULT_ASYNC_TIMEOUT_ERROR_ID:Number = 999;
      
      public static const DEFAULT_ASYNC_TIMEOUT_ERROR_MESSAGE:String = "asyncTimeout";
      
      public static const DEFAULT_DTO_PARSING_ERROR_ID:Number = 888;
      
      public static const SERVICE_UNAVAILABLE_ERROR_ID:Number = 777;
      
      public static const SERVICE_UNAVAILABLE_ERROR_MESSAGE:String = "serviceUnavailable";
      
      public static const DEFAULT_DTO_PARSTING_ERROR_MESSAGE:String = "parsingError";
      
      public static const ERROR_MAX_RP_LIMIT_REACHED:String = "exchange.itemGiftSend.maxRPBalanceLimitReached";
      
      public static const ERROR_SENDER_MAX_GIFT_LIMIT_REACHED:String = "exchange.itemGiftSend.maxLimitReached";
      
      public static const ERROR_RECIPIENT_MAX_GIFT_LIMIT_REACHED:String = "exchange.itemGiftReceive.maxLimitReached";
      
      public static const ERROR_ITEM_NOT_AVAILABLE:String = "exchange.items.itemNotAvailable";
      
      public static const ERROR_ITEM_TYPE_NOT_AVAILABLE:String = "exchange.items.itemTypeNotAvailable";
      
      public static const ERROR_RECIPIENT_MIN_LEVEL_NOT_REACHED:String = "exchange.itemGiftReceive.minLevelRequired";
      
      public static const ERROR_SENDER_MIN_LEVEL_NOT_REACHED:String = "exchange.itemGiftSend.minLevelRequired";
      
      public static const ERROR_MYSTERY_ITEMS_DISABLED:String = "exchange.mystery.item";
      
      public static const ERROR_RECIPIENT_GIFT_POOL_TOO_SMALL:String = "exchange.mystery.pool.notMet";
      
      public static const ERROR_NOT_ENOUGH_CURRENCY:String = "purchase.notEnoughCurrency";
      
      public static const ERROR_RECIPIENT_ALREADY_OWNS_ITEM:String = "purchase.alreadyOwned";
      
      private static const ERROR_GIFTING_DISABLED:String = "exchange.giftingDisabled";
      
      private static const ERROR_GIFT_TYPE_MISMATCH:String = "exchange.items.giftTypeMismatchSentItem";
      
      private static const ERROR_ITEM_REQUIRED:String = "exchange.items.required";
      
      private static const ERROR_STORE_PROCESSOR:String = "exchange.storeprocessor.error";
      
      private static const ERROR_ITEM_OWNERSHIP_EXCHANGE_REQUEST:String = "exchange.itemOwnershipRequest.itemId.required";
      
      private static const ERROR_MALFORMED_EXCHANGE_REQUEST:String = "exchange.malformedRequest";
      
      private static const ERROR_UNKNOWN_INVENTORY_TYPE:String = "purchase.unknownInventoryType";
      
      private static const ERROR_ITEM_OWNERSHIP_PURCHASE_REQUEST:String = "purchase.itemOwnershipRequest.itemId.required";
      
      private static const ERROR_CURRENCY_OWNERSHIP_PURCHASE_REQUEST:String = "purchase.itemOwnershipRequest.currency.required";
      
      private static const ERROR_DELTA_OWNERSHIP_PURCHASE_REQUEST:String = "purchase.itemOwnershipRequest.delta.required";
      
      private static const ERROR_SUMMONERID_OWNERSHIP_PURCHASE_REQUEST:String = "purchase.itemOwnershipRequest.summonerId";
      
      private static const ERROR_UNKNOWN_CURRENCY:String = "purchase.unknownCurrency";
      
      private static const ERROR_ITEM_UNAVAILABLE:String = "purchase.itemUnavailable";
      
      private static const ERROR_INCORRECT_PRICE:String = "purchase.incorrectPrice";
      
      private static const ERROR_MALFORMED_PURCHASE_REQUEST:String = "purchase.malformedRequest";
      
      private static const ERROR_APPLY_DELTAS_FAILED:String = "purchase.applyDeltasFailed";
      
      private static const ERROR_REQUIRED_ITEM:String = "purchaseRequest.items.required";
      
      private static const ERROR_DELTA_MISMATCH:String = "purchaseRequest.delta.mismatch";
      
      private static const ERROR_MISSING_INVENTORY_TYPE:String = "purchaseRequest.itemOwnershipRequest.inventoryType.required";
      
      private static const ERROR_OWNERSHIP_TYPE_REQUIRED:String = "purchaseRequest.itemOwnershipRequest.ownershipType.required";
      
      public function EndOfGameGiftServiceResponseTypes()
      {
         super();
      }
      
      public static function isPlayerFacingError(param1:String) : Boolean
      {
         switch(param1)
         {
            case ERROR_MAX_RP_LIMIT_REACHED:
            case ERROR_SENDER_MAX_GIFT_LIMIT_REACHED:
            case ERROR_RECIPIENT_MAX_GIFT_LIMIT_REACHED:
            case ERROR_ITEM_NOT_AVAILABLE:
            case ERROR_ITEM_TYPE_NOT_AVAILABLE:
            case ERROR_RECIPIENT_MIN_LEVEL_NOT_REACHED:
            case ERROR_SENDER_MIN_LEVEL_NOT_REACHED:
            case ERROR_MYSTERY_ITEMS_DISABLED:
            case ERROR_RECIPIENT_GIFT_POOL_TOO_SMALL:
            case ERROR_NOT_ENOUGH_CURRENCY:
            case ERROR_RECIPIENT_ALREADY_OWNS_ITEM:
               return true;
            default:
               return false;
         }
      }
   }
}

