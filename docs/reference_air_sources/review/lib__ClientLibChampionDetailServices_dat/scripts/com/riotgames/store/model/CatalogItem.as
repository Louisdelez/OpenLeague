package com.riotgames.store.model
{
   import blix.util.date.parseDate;
   import blix.util.string.parseBool;
   
   public class CatalogItem
   {
      
      public var active:Boolean;
      
      public var championOwned:Boolean;
      
      public var daysUntilExpiration:uint;
      
      public var description:String;
      
      public var duration:String;
      
      public var effects:String;
      
      public var endDate:Date;
      
      public var entitlementMsg:String;
      
      public var expirationMessage:String;
      
      public var expirationWindow:uint;
      
      public var groups:Object;
      
      public var id:String;
      
      public var inactiveDate:Date;
      
      public var inventoryType:String;
      
      public var ipCost:int;
      
      public var isEntitled:Boolean;
      
      public var isFeatured:Boolean;
      
      public var isHot:Boolean;
      
      public var isNew:Boolean;
      
      public var isOwned:Boolean;
      
      public var isPurchasable:Boolean;
      
      public var isRentable:Boolean;
      
      public var isRented:Boolean;
      
      public var isSale:Boolean;
      
      public var isPerWinRental:Boolean;
      
      public var isTimedRental:Boolean;
      
      public var itemCanBeFree:Boolean;
      
      public var itemIsExpired:Boolean;
      
      public var itemIsExpiring:Boolean;
      
      public var itemStatusRank:uint;
      
      public var name:String;
      
      public var originalIpCost:int;
      
      public var originalRpCost:int;
      
      public var releaseDate:Date;
      
      public var requirementsMet:Boolean;
      
      public var rpCost:int;
      
      public var sortOrder:Number;
      
      public var tags:Array;
      
      public var tier:String;
      
      public var type:String;
      
      public var winCountRemaining:int;
      
      public function CatalogItem()
      {
         super();
      }
      
      public static function unmarshall(param1:Object) : CatalogItem
      {
         var _loc2_:CatalogItem = new CatalogItem();
         _loc2_.championOwned = parseBool(param1.champion_owned);
         _loc2_.requirementsMet = parseBool(param1.requirements_met);
         _loc2_.inventoryType = String(param1.inventory_type);
         _loc2_.isOwned = parseBool(param1.is_owned);
         _loc2_.type = String(param1.type);
         _loc2_.effects = String(param1.effects);
         _loc2_.isEntitled = parseBool(param1.is_entitled);
         _loc2_.tier = String(param1.tier);
         _loc2_.originalIpCost = parseInt(param1.original_ip_cost);
         _loc2_.daysUntilExpiration = parseInt(param1.DaysUntilExpiration);
         _loc2_.winCountRemaining = parseInt(param1.winCountRemaining);
         _loc2_.originalRpCost = parseInt(param1.original_rp_cost);
         _loc2_.name = String(param1.name);
         _loc2_.itemCanBeFree = parseBool(param1.item_can_be_free);
         _loc2_.isHot = parseBool(param1.is_hot);
         _loc2_.itemStatusRank = parseInt(param1.ItemStatusRank);
         _loc2_.isRentable = parseBool(param1.is_rentable);
         _loc2_.isNew = parseBool(param1.is_new);
         _loc2_.active = parseBool(param1.active);
         _loc2_.inactiveDate = parseDate(param1.inactive_date);
         _loc2_.isFeatured = parseBool(param1.is_featured);
         _loc2_.id = String(param1.id);
         _loc2_.releaseDate = parseDate(param1.release_date);
         _loc2_.isTimedRental = parseBool(param1.IsTimedRental);
         _loc2_.duration = String(param1.duration);
         _loc2_.sortOrder = parseFloat(param1.sort_order);
         _loc2_.ipCost = parseInt(param1.ip_cost);
         _loc2_.description = String(param1.description);
         _loc2_.isSale = parseBool(param1.is_sale);
         _loc2_.expirationMessage = String(param1.ExpirationMessage);
         _loc2_.rpCost = parseInt(param1.rp_cost);
         _loc2_.expirationWindow = parseInt(param1.ExpirationWindow);
         _loc2_.endDate = parseDate(param1.end_date);
         _loc2_.isPurchasable = parseBool(param1.is_purchasable);
         _loc2_.tags = param1.tags;
         _loc2_.itemIsExpiring = parseBool(param1.ItemIsExpiring);
         _loc2_.isPerWinRental = parseBool(param1.IsPerWinRental);
         _loc2_.itemIsExpired = parseBool(param1.ItemIsExpired);
         _loc2_.isRented = parseBool(param1.is_rented);
         _loc2_.groups = param1.groups;
         return _loc2_;
      }
   }
}

