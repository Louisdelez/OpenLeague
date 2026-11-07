package com.riotgames.platform.gameclient.domain.inventory
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.boost.SummonerActiveBoostsDTO")]
   public class ActiveBoosts implements IEventDispatcher
   {
      
      public static const IP:Number = 1;
      
      public static const XP:Number = 2;
      
      public static var MILLIS_DAY:int = 86400000;
      
      public static var MILLIS_HOUR:int = 3600000;
      
      public static var MILLIS_MIN:int = 60000;
      
      private var _1310686553displayXpBoostPerWinCount:String;
      
      private var checkBoostTimer:Timer;
      
      public var _ipBoostPerWinCount:Number;
      
      public var _summonerId:Number;
      
      private var _1515615904displayIpEndDate:String;
      
      private var _1437338223displayXpEndDate:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public var _xpBoostEndDate:Number;
      
      public var _xpBoostPerWinCount:Number;
      
      public var _ipBoostEndDate:Number;
      
      private var _1301004041displayIpBoostTooltip:String;
      
      private var _760496854displayIpBoostPerWinCount:String;
      
      public function ActiveBoosts()
      {
         super();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get summonerId() : Number
      {
         return this._summonerId;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set xpBoostPerWinCount(param1:Number) : void
      {
         this._xpBoostPerWinCount = param1;
         this.displayXpBoostPerWinCount = this._xpBoostPerWinCount + " " + ResourceManager.getInstance().getString("resources","summonerProfile_info_boostPerWin_tooltip");
      }
      
      public function set summonerId(param1:Number) : void
      {
         this._summonerId = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayIpBoostTooltip() : String
      {
         return this._1301004041displayIpBoostTooltip;
      }
      
      public function set displayIpBoostTooltip(param1:String) : void
      {
         var _loc2_:Object = this._1301004041displayIpBoostTooltip;
         if(_loc2_ !== param1)
         {
            this._1301004041displayIpBoostTooltip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayIpBoostTooltip",_loc2_,param1));
         }
      }
      
      public function set ipBoostEndDate(param1:Number) : void
      {
         this._ipBoostEndDate = param1;
         if(param1 == 0)
         {
            return;
         }
         this.displayIpEndDate = this.formatIpEndDate();
         this.updateDisplayIpBoostTooltip();
         this.startCheckBoostTimer();
      }
      
      public function get xpBoostEndDate() : Number
      {
         return this._xpBoostEndDate;
      }
      
      private function get xpTimeBoostEnabled() : Boolean
      {
         if(this.xpBoostEndDate == 0)
         {
            return false;
         }
         var _loc1_:Date = new Date();
         if(_loc1_.getTime() < this.xpBoostEndDate)
         {
            return true;
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayXpBoostPerWinCount() : String
      {
         return this._1310686553displayXpBoostPerWinCount;
      }
      
      public function set displayIpBoostPerWinCount(param1:String) : void
      {
         var _loc2_:Object = this._760496854displayIpBoostPerWinCount;
         if(_loc2_ !== param1)
         {
            this._760496854displayIpBoostPerWinCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayIpBoostPerWinCount",_loc2_,param1));
         }
      }
      
      private function handleTimerUpdate(param1:TimerEvent) : void
      {
         if(!this.ipBoostEnabled && !this.xpBoostEnabled)
         {
            this.checkBoostTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerUpdate,false);
            this.checkBoostTimer.stop();
            this.checkBoostTimer = null;
         }
         this.displayIpEndDate = this.formatIpEndDate();
         this.displayXpEndDate = this.formatXpEndDate();
         this.updateDisplayIpBoostTooltip();
      }
      
      public function get xpBoostEnabled() : Boolean
      {
         if(this.xpBoostPerWinCount > 0)
         {
            return true;
         }
         return this.xpTimeBoostEnabled;
      }
      
      public function set xpBoostEndDate(param1:Number) : void
      {
         this._xpBoostEndDate = param1;
         if(param1 == 0)
         {
            return;
         }
         this.displayXpEndDate = this.formatXpEndDate();
         this.startCheckBoostTimer();
      }
      
      private function updateDisplayIpBoostTooltip() : void
      {
         this.displayIpBoostTooltip = "";
         if(this.ipBoostPerWinCount > 0)
         {
            this.displayIpBoostTooltip += this.displayIpBoostPerWinCount;
         }
         if(this.ipTimeBoostEnabled)
         {
            if(this.displayIpBoostTooltip.length > 0)
            {
               this.displayIpBoostTooltip += "\n";
            }
            this.displayIpBoostTooltip += this.formatIpEndDate();
         }
      }
      
      public function get xpBoostPerWinCount() : Number
      {
         return this._xpBoostPerWinCount;
      }
      
      public function set displayIpEndDate(param1:String) : void
      {
         var _loc2_:Object = this._1515615904displayIpEndDate;
         if(_loc2_ !== param1)
         {
            this._1515615904displayIpEndDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayIpEndDate",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function formatIpEndDate() : String
      {
         if(this._ipBoostEndDate == 0)
         {
            return "";
         }
         return ResourceManager.getInstance().getString("resources","summonerProfile_info_boostExpiry_tooltip",this.calcTimeDiff(new Date(this._ipBoostEndDate)));
      }
      
      public function get ipBoostEndDate() : Number
      {
         return this._ipBoostEndDate;
      }
      
      public function set displayXpBoostPerWinCount(param1:String) : void
      {
         var _loc2_:Object = this._1310686553displayXpBoostPerWinCount;
         if(_loc2_ !== param1)
         {
            this._1310686553displayXpBoostPerWinCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayXpBoostPerWinCount",_loc2_,param1));
         }
      }
      
      private function startCheckBoostTimer() : void
      {
         if(this.checkBoostTimer == null)
         {
            this.checkBoostTimer = new Timer(1800000);
            this.checkBoostTimer.addEventListener(TimerEvent.TIMER,this.handleTimerUpdate,false,0,true);
            this.checkBoostTimer.start();
         }
      }
      
      private function get ipTimeBoostEnabled() : Boolean
      {
         if(this.ipBoostEndDate == 0)
         {
            return false;
         }
         var _loc1_:Date = new Date();
         if(_loc1_.getTime() < this.ipBoostEndDate)
         {
            return true;
         }
         return false;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayIpBoostPerWinCount() : String
      {
         return this._760496854displayIpBoostPerWinCount;
      }
      
      public function formatXpEndDate() : String
      {
         if(this._xpBoostEndDate == 0)
         {
            return "";
         }
         return ResourceManager.getInstance().getString("resources","summonerProfile_info_boostExpiry_tooltip",this.calcTimeDiff(new Date(this._xpBoostEndDate)));
      }
      
      public function set displayXpEndDate(param1:String) : void
      {
         var _loc2_:Object = this._1437338223displayXpEndDate;
         if(_loc2_ !== param1)
         {
            this._1437338223displayXpEndDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayXpEndDate",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get ipBoostEnabled() : Boolean
      {
         if(this.ipBoostPerWinCount > 0)
         {
            return true;
         }
         return this.ipTimeBoostEnabled;
      }
      
      public function calcTimeDiff(param1:Date) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Date = new Date();
         var _loc3_:Number = param1.getTime() - _loc2_.getTime();
         if(_loc3_ > ActiveBoosts.MILLIS_DAY)
         {
            _loc6_ = _loc3_ / ActiveBoosts.MILLIS_DAY;
            _loc3_ -= _loc6_ * ActiveBoosts.MILLIS_DAY;
         }
         if(_loc3_ > ActiveBoosts.MILLIS_HOUR)
         {
            _loc5_ = _loc3_ / ActiveBoosts.MILLIS_HOUR;
            _loc3_ -= _loc5_ * ActiveBoosts.MILLIS_HOUR;
         }
         if(_loc3_ > ActiveBoosts.MILLIS_MIN)
         {
            _loc4_ = _loc3_ / ActiveBoosts.MILLIS_MIN;
            _loc3_ -= _loc4_ * ActiveBoosts.MILLIS_MIN;
         }
         return [_loc6_.toString(),_loc5_.toString()];
      }
      
      public function set ipBoostPerWinCount(param1:Number) : void
      {
         this._ipBoostPerWinCount = param1;
         this.displayIpBoostPerWinCount = this._ipBoostPerWinCount + " " + ResourceManager.getInstance().getString("resources","summonerProfile_info_boostPerWin_tooltip");
         this.updateDisplayIpBoostTooltip();
      }
      
      [Bindable(event="propertyChange")]
      public function get displayXpEndDate() : String
      {
         return this._1437338223displayXpEndDate;
      }
      
      public function get ipBoostPerWinCount() : Number
      {
         return this._ipBoostPerWinCount;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayIpEndDate() : String
      {
         return this._1515615904displayIpEndDate;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

