package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.utils.RPCObjectUtil;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerParticipantStats")]
   public class PlayerParticipantStats implements IEventDispatcher
   {
      
      private var _996153982ipEarned:Number;
      
      private var _1986068061ipTotal:Number;
      
      private var _94588637statistics:ArrayCollection;
      
      private var _1655724770leveledUp:Boolean;
      
      private var _877713320teamId:Number;
      
      private var _599784949newSpells:ArrayCollection;
      
      private var _1004130666expPointsToNextLevel:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _2111759354experienceTotal:Number;
      
      private var _1537709924championId:Number;
      
      private var _1253236563gameId:Number;
      
      private var _1835578835talentPointsGained:Number;
      
      private var _597616769experienceEarned:Number;
      
      private var _836030906userId:Number;
      
      private var _2142785410_profileIconId:int;
      
      public function PlayerParticipantStats()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get experienceEarned() : Number
      {
         return this._597616769experienceEarned;
      }
      
      public function set experienceEarned(param1:Number) : void
      {
         var _loc2_:Object = this._597616769experienceEarned;
         if(_loc2_ !== param1)
         {
            this._597616769experienceEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"experienceEarned",_loc2_,param1));
         }
      }
      
      public function set _profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._2142785410_profileIconId;
         if(_loc2_ !== param1)
         {
            this._2142785410_profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_profileIconId",_loc2_,param1));
         }
      }
      
      private function set _1359356291profileIconId(param1:int) : void
      {
         this._profileIconId = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get _profileIconId() : int
      {
         return this._2142785410_profileIconId;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this.profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newSpells() : ArrayCollection
      {
         return this._599784949newSpells;
      }
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      public function set newSpells(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._599784949newSpells;
         if(_loc2_ !== param1)
         {
            this._599784949newSpells = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newSpells",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get expPointsToNextLevel() : Number
      {
         return this._1004130666expPointsToNextLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get leveledUp() : Boolean
      {
         return this._1655724770leveledUp;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set expPointsToNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1004130666expPointsToNextLevel;
         if(_loc2_ !== param1)
         {
            this._1004130666expPointsToNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expPointsToNextLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      public function set teamId(param1:Number) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentPointsGained() : Number
      {
         return this._1835578835talentPointsGained;
      }
      
      public function set ipTotal(param1:Number) : void
      {
         var _loc2_:Object = this._1986068061ipTotal;
         if(_loc2_ !== param1)
         {
            this._1986068061ipTotal = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipTotal",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statistics() : ArrayCollection
      {
         return this._94588637statistics;
      }
      
      public function set leveledUp(param1:Boolean) : void
      {
         var _loc2_:Object = this._1655724770leveledUp;
         if(_loc2_ !== param1)
         {
            this._1655724770leveledUp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leveledUp",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set championId(param1:Number) : void
      {
         var _loc2_:Object = this._1537709924championId;
         if(_loc2_ !== param1)
         {
            this._1537709924championId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : Number
      {
         return this._877713320teamId;
      }
      
      public function set gameId(param1:Number) : void
      {
         var _loc2_:Object = this._1253236563gameId;
         if(_loc2_ !== param1)
         {
            this._1253236563gameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get ipTotal() : Number
      {
         return this._1986068061ipTotal;
      }
      
      public function set statistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._94588637statistics;
         if(_loc2_ !== param1)
         {
            this._94588637statistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statistics",_loc2_,param1));
         }
      }
      
      public function set talentPointsGained(param1:Number) : void
      {
         var _loc2_:Object = this._1835578835talentPointsGained;
         if(_loc2_ !== param1)
         {
            this._1835578835talentPointsGained = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentPointsGained",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function toString() : String
      {
         return RPCObjectUtil.toString(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get experienceTotal() : Number
      {
         return this._2111759354experienceTotal;
      }
      
      public function set experienceTotal(param1:Number) : void
      {
         var _loc2_:Object = this._2111759354experienceTotal;
         if(_loc2_ !== param1)
         {
            this._2111759354experienceTotal = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"experienceTotal",_loc2_,param1));
         }
      }
      
      public function set ipEarned(param1:Number) : void
      {
         var _loc2_:Object = this._996153982ipEarned;
         if(_loc2_ !== param1)
         {
            this._996153982ipEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipEarned",_loc2_,param1));
         }
      }
      
      public function get profileIconId() : int
      {
         return this._profileIconId;
      }
      
      [Bindable(event="propertyChange")]
      public function get ipEarned() : Number
      {
         return this._996153982ipEarned;
      }
   }
}

