package com.riotgames.platform.gameclient.masteries
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.Talent")]
   public class Talent extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1769659137gameCode:int;
      
      private var _1221537286prereqTalentGameCode:int;
      
      private var _1799987566talentGroupId:int;
      
      private var _3373707name:String;
      
      private var _165949409level4Desc:int;
      
      private var _1386076078minLevel:int;
      
      private var _844043184maxRank:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _110459703tltId:int;
      
      private var _100346066index:int;
      
      private var _365020937talentRowId:int;
      
      private var _164102367level2Desc:int;
      
      private var _1063908180minTier:int;
      
      private var _165025888level3Desc:int;
      
      private var _166872930level5Desc:int;
      
      private var _163178846level1Desc:int;
      
      public function Talent()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get prereqTalentGameCode() : int
      {
         return this._1221537286prereqTalentGameCode;
      }
      
      [Bindable(event="propertyChange")]
      public function get talentRowId() : int
      {
         return this._365020937talentRowId;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get level3Desc() : int
      {
         return this._165025888level3Desc;
      }
      
      public function set talentRowId(param1:int) : void
      {
         var _loc2_:Object = this._365020937talentRowId;
         if(_loc2_ !== param1)
         {
            this._365020937talentRowId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentRowId",_loc2_,param1));
         }
      }
      
      public function set prereqTalentGameCode(param1:int) : void
      {
         var _loc2_:Object = this._1221537286prereqTalentGameCode;
         if(_loc2_ !== param1)
         {
            this._1221537286prereqTalentGameCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"prereqTalentGameCode",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
         }
      }
      
      public function set minTier(param1:int) : void
      {
         var _loc2_:Object = this._1063908180minTier;
         if(_loc2_ !== param1)
         {
            this._1063908180minTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minTier",_loc2_,param1));
         }
      }
      
      public function set index(param1:int) : void
      {
         var _loc2_:Object = this._100346066index;
         if(_loc2_ !== param1)
         {
            this._100346066index = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"index",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxRank() : int
      {
         return this._844043184maxRank;
      }
      
      [Bindable(event="propertyChange")]
      public function get tltId() : int
      {
         return this._110459703tltId;
      }
      
      public function set level1Desc(param1:int) : void
      {
         var _loc2_:Object = this._163178846level1Desc;
         if(_loc2_ !== param1)
         {
            this._163178846level1Desc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level1Desc",_loc2_,param1));
         }
      }
      
      public function set level2Desc(param1:int) : void
      {
         var _loc2_:Object = this._164102367level2Desc;
         if(_loc2_ !== param1)
         {
            this._164102367level2Desc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level2Desc",_loc2_,param1));
         }
      }
      
      public function set level3Desc(param1:int) : void
      {
         var _loc2_:Object = this._165025888level3Desc;
         if(_loc2_ !== param1)
         {
            this._165025888level3Desc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level3Desc",_loc2_,param1));
         }
      }
      
      public function set level4Desc(param1:int) : void
      {
         var _loc2_:Object = this._165949409level4Desc;
         if(_loc2_ !== param1)
         {
            this._165949409level4Desc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level4Desc",_loc2_,param1));
         }
      }
      
      public function set level5Desc(param1:int) : void
      {
         var _loc2_:Object = this._166872930level5Desc;
         if(_loc2_ !== param1)
         {
            this._166872930level5Desc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level5Desc",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get index() : int
      {
         return this._100346066index;
      }
      
      [Bindable(event="propertyChange")]
      public function get minTier() : int
      {
         return this._1063908180minTier;
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      public function set talentGroupId(param1:int) : void
      {
         var _loc2_:Object = this._1799987566talentGroupId;
         if(_loc2_ !== param1)
         {
            this._1799987566talentGroupId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentGroupId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get level1Desc() : int
      {
         return this._163178846level1Desc;
      }
      
      [Bindable(event="propertyChange")]
      public function get level2Desc() : int
      {
         return this._164102367level2Desc;
      }
      
      [Bindable(event="propertyChange")]
      public function get level4Desc() : int
      {
         return this._165949409level4Desc;
      }
      
      [Bindable(event="propertyChange")]
      public function get level5Desc() : int
      {
         return this._166872930level5Desc;
      }
      
      [Bindable(event="propertyChange")]
      public function get talentGroupId() : int
      {
         return this._1799987566talentGroupId;
      }
      
      public function set maxRank(param1:int) : void
      {
         var _loc2_:Object = this._844043184maxRank;
         if(_loc2_ !== param1)
         {
            this._844043184maxRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxRank",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set tltId(param1:int) : void
      {
         var _loc2_:Object = this._110459703tltId;
         if(_loc2_ !== param1)
         {
            this._110459703tltId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tltId",_loc2_,param1));
         }
      }
      
      public function set gameCode(param1:int) : void
      {
         var _loc2_:Object = this._1769659137gameCode;
         if(_loc2_ !== param1)
         {
            this._1769659137gameCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameCode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameCode() : int
      {
         return this._1769659137gameCode;
      }
   }
}

