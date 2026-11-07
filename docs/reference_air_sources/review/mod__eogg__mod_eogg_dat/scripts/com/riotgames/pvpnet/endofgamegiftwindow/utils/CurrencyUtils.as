package com.riotgames.pvpnet.endofgamegiftwindow.utils
{
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftCurrencies;
   
   public class CurrencyUtils
   {
      
      public static const CURRENCY_RP_LINKAGE_NAME:String = "assets.currencyIconRP";
      
      public static const CURRENCY_IP_LINKAGE_NAME:String = "assets.currencyIconIP";
      
      public function CurrencyUtils()
      {
         super();
         throw new Error("CurrencyUtils::Constructor - this class contains only static members. Do not instantiate");
      }
      
      public static function getCurrencyIconLinkageByCurrencyType(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case GiftCurrencies.CURRENCY_RP:
               _loc2_ = CURRENCY_RP_LINKAGE_NAME;
               break;
            case GiftCurrencies.CURRENCY_IP:
               _loc2_ = CURRENCY_RP_LINKAGE_NAME;
         }
         return _loc2_;
      }
   }
}

