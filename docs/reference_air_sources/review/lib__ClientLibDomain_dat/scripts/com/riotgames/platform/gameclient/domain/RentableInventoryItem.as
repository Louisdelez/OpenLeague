package com.riotgames.platform.gameclient.domain
{
   public class RentableInventoryItem extends AbstractDomainObject
   {
      
      private static const RECENT_PURCHASE_TIME:Number = 1000 * 60 * 60 * 48;
      
      private static const ALMOST_EXPIRED_WIN_COUNT:int = 2;
      
      private static const ALMOST_EXPIRED_TIME:Number = 1000 * 60 * 60 * 24;
      
      private static const MS_PER_DAY:Number = 1000 * 60 * 60 * 24;
      
      private static const MS_PER_HOUR:Number = 1000 * 60 * 60;
      
      private static const MS_PER_MINUTE:Number = 1000 * 60;
      
      private static const MS_PER_SECOND:Number = 1000;
      
      public var winCountRemaining:int;
      
      public var endDate:Number;
      
      public var purchaseDate:Number;
      
      public function RentableInventoryItem()
      {
         super();
      }
      
      public function isRented() : Boolean
      {
         if(this.isOwned())
         {
            return false;
         }
         var _loc1_:Date = new Date();
         var _loc2_:Boolean = false;
         if(this.endDate > 0)
         {
            _loc2_ = this.endDate > _loc1_.getTime();
         }
         return _loc2_ || this.winCountRemaining > 0;
      }
      
      public function isExpired() : Boolean
      {
         return !this.isRented() && !this.isOwned() && this.endDate > 0;
      }
      
      public function rentalDaysRemaining() : int
      {
         var _loc1_:Date = new Date();
         if(this.isRentalTimeRemaining() == false)
         {
            return 0;
         }
         var _loc2_:Number = this.endDate - _loc1_.getTime();
         return int(Math.floor(_loc2_ / MS_PER_DAY));
      }
      
      public function rentalHoursRemaining() : int
      {
         var _loc1_:Date = new Date();
         if(this.isRentalTimeRemaining() == false)
         {
            return 0;
         }
         var _loc2_:Number = this.endDate - _loc1_.getTime();
         var _loc3_:int = Math.floor(_loc2_ / MS_PER_DAY);
         return int(Math.floor((_loc2_ - _loc3_ * MS_PER_DAY) / MS_PER_HOUR));
      }
      
      public function isAlmostExpired() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Date = null;
         var _loc4_:Number = NaN;
         if(this.isRented())
         {
            _loc1_ = true;
            if(this.endDate > 0)
            {
               _loc3_ = new Date();
               _loc4_ = this.endDate - _loc3_.getTime();
               _loc1_ = _loc4_ < ALMOST_EXPIRED_TIME;
            }
            _loc2_ = this.winCountRemaining <= ALMOST_EXPIRED_WIN_COUNT;
            return _loc1_ && _loc2_;
         }
         return false;
      }
      
      public function isOwned() : Boolean
      {
         return this.purchaseDate > 0;
      }
      
      public function set purchased(param1:Number) : void
      {
      }
      
      public function isRentalTimeRemaining() : Boolean
      {
         var _loc1_:Date = new Date();
         if(this.endDate < _loc1_.getTime())
         {
            return false;
         }
         return true;
      }
      
      public function recentPurchase() : Boolean
      {
         if(!this.isOwned())
         {
            return false;
         }
         var _loc1_:Date = new Date();
         var _loc2_:uint = _loc1_.getTime() - this.purchaseDate;
         if(_loc2_ < RECENT_PURCHASE_TIME)
         {
            return true;
         }
         return false;
      }
      
      public function rentalMinutesRemaining() : int
      {
         var _loc1_:Date = new Date();
         if(this.isRentalTimeRemaining() == false)
         {
            return 0;
         }
         var _loc2_:Number = this.endDate - _loc1_.getTime();
         var _loc3_:int = Math.floor(_loc2_ / MS_PER_DAY);
         var _loc4_:int = Math.floor((_loc2_ - _loc3_ * MS_PER_DAY) / MS_PER_HOUR);
         return int(Math.floor(_loc2_ - _loc3_ * MS_PER_DAY - _loc4_ * MS_PER_HOUR) / MS_PER_MINUTE);
      }
   }
}

