package com.riotgames.platform.gameclient.events
{
   import flash.events.Event;
   
   public class InventoryEvent extends Event
   {
      
      public static const SPELL_DICTIONARY_CHANGED:String = "spellDictionaryChanged";
      
      public static const CHAMPIONS_CHANGED:String = "championsChanged";
      
      public static const CHAMPIONS_PRE_POPULATED:String = "championsPrePopulated";
      
      public static const CHAMPIONS_RETRIEVED:String = "championsRetrieved";
      
      public static const CHAMPIONS_PRECACHED:String = "championsCached";
      
      public static const ACCOUNT_BALANCE_UPDATED:String = "accountBalanceUpdated";
      
      public static const BAD_FULFILLMENT:String = "badFullfillment";
      
      public static const SHOW_ALERT:String = "showAlert";
      
      public static const SKIN_PURCHASE_PENDING:String = "skinPurchasedPending";
      
      private var _info:Object;
      
      public function InventoryEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._info = param2;
      }
      
      override public function clone() : Event
      {
         return new InventoryEvent(type,this.info,bubbles,cancelable);
      }
      
      public function get info() : Object
      {
         return this._info;
      }
   }
}

