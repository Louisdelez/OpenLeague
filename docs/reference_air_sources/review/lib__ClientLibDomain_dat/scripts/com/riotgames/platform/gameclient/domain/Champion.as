package com.riotgames.platform.gameclient.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.champion.ChampionDTO")]
   public class Champion extends RentableInventoryItem implements IEventDispatcher
   {
      
      public static const RANDOM_SKIN_NAME:String = "Random";
      
      private var _botEnabled:Boolean;
      
      private var _championPropertiesChanged:Signal = new Signal();
      
      private var _active:Boolean;
      
      private var _banned:Boolean = false;
      
      private var _freeToPlayReward:Boolean;
      
      private var _1724546052description:String;
      
      private var _freeToPlay:Boolean;
      
      private var _1922186452ownedByYourTeam:Boolean = true;
      
      private var _1714148973displayName:String;
      
      private var _championData:Object = new Object();
      
      private var _defaultSkin:ChampionSkin;
      
      private var _owned:Boolean;
      
      private var _championSkins:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1537709924championId:int;
      
      private var _836332663ownedByEnemyTeam:Boolean = true;
      
      public function Champion()
      {
         super();
      }
      
      public static function create(param1:String) : Champion
      {
         var _loc2_:Champion = new Champion();
         _loc2_.displayName = param1;
         return _loc2_;
      }
      
      private function set _195285075championSkins(param1:ArrayCollection) : void
      {
         var _loc2_:ChampionSkin = null;
         this._championSkins = param1;
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               _loc2_.setChampion(this);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set botEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.botEnabled;
         if(_loc2_ !== param1)
         {
            this._484841606botEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botEnabled",_loc2_,param1));
         }
      }
      
      public function getChampionSkin(param1:Number) : ChampionSkin
      {
         var _loc3_:ChampionSkin = null;
         var _loc2_:ChampionSkin = null;
         for each(_loc3_ in this.championSkins)
         {
            if(_loc3_.skinId == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      private function set _35914986freeToPlayReward(param1:Boolean) : void
      {
         if(param1 == this._freeToPlayReward)
         {
            return;
         }
         this._freeToPlayReward = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      private function set _1422950650active(param1:Boolean) : void
      {
         if(param1 == this._active)
         {
            return;
         }
         this._active = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      public function set ownedByEnemyTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this._836332663ownedByEnemyTeam;
         if(_loc2_ !== param1)
         {
            this._836332663ownedByEnemyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownedByEnemyTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this.active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
         }
      }
      
      public function isRandomChampion() : Boolean
      {
         return this.skinName == RANDOM_SKIN_NAME && !this.isWildCardChampion();
      }
      
      public function get banned() : Boolean
      {
         return this._banned;
      }
      
      private function set _484841606botEnabled(param1:Boolean) : void
      {
         if(param1 == this._botEnabled)
         {
            return;
         }
         this._botEnabled = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      private function set _710477343searchTags(param1:Array) : void
      {
         this._championData.searchTags = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get ownedByYourTeam() : Boolean
      {
         return this._1922186452ownedByYourTeam;
      }
      
      [Bindable(event="propertyChange")]
      public function set banned(param1:Boolean) : void
      {
         var _loc2_:Object = this.banned;
         if(_loc2_ !== param1)
         {
            this._1396343010banned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"banned",_loc2_,param1));
         }
      }
      
      private function set _1396343010banned(param1:Boolean) : void
      {
         if(param1 == this._banned)
         {
            return;
         }
         this._banned = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      private function set _872293925freeToPlay(param1:Boolean) : void
      {
         if(param1 == this._freeToPlay)
         {
            return;
         }
         this._freeToPlay = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      public function get passiveIcon() : String
      {
         return this._championData.passiveIcon;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set skinName(param1:String) : void
      {
         var _loc2_:Object = this.skinName;
         if(_loc2_ !== param1)
         {
            this._2143407528skinName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set owned(param1:Boolean) : void
      {
         var _loc2_:Object = this.owned;
         if(_loc2_ !== param1)
         {
            this._106164901owned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owned",_loc2_,param1));
         }
      }
      
      public function set ownedByYourTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this._1922186452ownedByYourTeam;
         if(_loc2_ !== param1)
         {
            this._1922186452ownedByYourTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownedByYourTeam",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function set championSkins(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.championSkins;
         if(_loc2_ !== param1)
         {
            this._195285075championSkins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkins",_loc2_,param1));
         }
      }
      
      public function get defaultSkin() : ChampionSkin
      {
         if(this._defaultSkin == null)
         {
            this._defaultSkin = new ChampionSkin(true);
            this._defaultSkin.setChampion(this);
            this._defaultSkin.championId = this.championId;
            this._defaultSkin.skinIndex = 0;
            this._defaultSkin.skinId = 0;
         }
         return this._defaultSkin;
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : int
      {
         return this._1537709924championId;
      }
      
      private function set _1095042677secondarySearchTags(param1:Array) : void
      {
         this._championData.secondarySearchTags = param1;
      }
      
      public function getCurrentChampionSkin() : ChampionSkin
      {
         var _loc2_:ChampionSkin = null;
         var _loc1_:ChampionSkin = null;
         for each(_loc2_ in this.championSkins)
         {
            if(_loc2_.lastSelected)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         if(_loc1_ == null)
         {
            _loc1_ = this.defaultSkin;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return this.displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      public function get secondarySearchTags() : Array
      {
         return this._championData.searchTagsSecondary;
      }
      
      private function set _270338995championData(param1:Object) : void
      {
         this._championData = param1;
      }
      
      public function get magicRank() : int
      {
         return this._championData.magicRank;
      }
      
      [Bindable(event="propertyChange")]
      public function set championData(param1:Object) : void
      {
         var _loc2_:Object = this.championData;
         if(_loc2_ !== param1)
         {
            this._270338995championData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championData",_loc2_,param1));
         }
      }
      
      public function get botEnabled() : Boolean
      {
         return this._botEnabled;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get difficultyRank() : int
      {
         return this._championData.difficultyRank;
      }
      
      [Bindable(event="propertyChange")]
      public function get ownedByEnemyTeam() : Boolean
      {
         return this._836332663ownedByEnemyTeam;
      }
      
      public function get attackRank() : int
      {
         return this._championData.attackRank;
      }
      
      public function get defenseRank() : int
      {
         return this._championData.defenseRank;
      }
      
      public function setAsRandomChampion() : void
      {
         this.skinName = RANDOM_SKIN_NAME;
         this.championId = -1;
         this.searchTags = new Array();
         this.freeToPlay = true;
         this.owned = true;
         this.active = true;
      }
      
      public function get owned() : Boolean
      {
         return this._owned;
      }
      
      public function get skinName() : String
      {
         return this._championData.skinName;
      }
      
      public function get championSkins() : ArrayCollection
      {
         return this._championSkins;
      }
      
      public function get championData() : Object
      {
         return this._championData;
      }
      
      [Bindable(event="propertyChange")]
      public function set freeToPlay(param1:Boolean) : void
      {
         var _loc2_:Object = this.freeToPlay;
         if(_loc2_ !== param1)
         {
            this._872293925freeToPlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freeToPlay",_loc2_,param1));
         }
      }
      
      public function isAvailable(param1:Boolean) : Boolean
      {
         if(param1)
         {
            return this._owned || this.isRented() || this._freeToPlay || this._freeToPlayReward;
         }
         return this._owned || this.isRented() || this._freeToPlayReward;
      }
      
      [Bindable(event="propertyChange")]
      public function set searchTags(param1:Array) : void
      {
         var _loc2_:Object = this.searchTags;
         if(_loc2_ !== param1)
         {
            this._710477343searchTags = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"searchTags",_loc2_,param1));
         }
      }
      
      private function set _106164901owned(param1:Boolean) : void
      {
         if(param1 == this._owned)
         {
            return;
         }
         this._owned = param1;
         this._championPropertiesChanged.dispatch();
      }
      
      public function set championId(param1:int) : void
      {
         var _loc2_:Object = this._1537709924championId;
         if(_loc2_ !== param1)
         {
            this._1537709924championId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championId",_loc2_,param1));
         }
      }
      
      private function set _2143407528skinName(param1:String) : void
      {
         this._championData.skinName = param1;
      }
      
      public function get skinInfo() : Object
      {
         return this._championData.skinInfo;
      }
      
      public function get abilityIcon1() : String
      {
         return this._championData.abilityIcon1;
      }
      
      public function get abilityIcon2() : String
      {
         return this._championData.abilityIcon2;
      }
      
      public function get abilityIcon3() : String
      {
         return this._championData.abilityIcon3;
      }
      
      public function get abilityIcon4() : String
      {
         return this._championData.abilityIcon4;
      }
      
      public function isWildCardChampion() : Boolean
      {
         return this.championId == ChampionWildCardEnums.ID_ABSTAIN_CHAMPION;
      }
      
      public function setAsWildCardChampion(param1:int) : void
      {
         this.skinName = RANDOM_SKIN_NAME;
         this.championId = param1;
         this.searchTags = new Array();
         this.freeToPlay = true;
         this.owned = true;
         this.active = true;
         if(!this.isWildCardChampion())
         {
            throw new Error("Wild Card Champion id of " + param1 + " not recognized.");
         }
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      public function get freeToPlay() : Boolean
      {
         return this._freeToPlay;
      }
      
      public function setCurrentChampionSkin(param1:Number) : void
      {
         var _loc2_:ChampionSkin = null;
         for each(_loc2_ in this.championSkins)
         {
            if(_loc2_.skinId == param1)
            {
               _loc2_.setLastSelected_silent(true);
            }
            else
            {
               _loc2_.setLastSelected_silent(false);
            }
         }
      }
      
      public function get searchTags() : Array
      {
         return this._championData.searchTags;
      }
      
      public function getChampionPropertiesChanged() : ISignal
      {
         return this._championPropertiesChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function set freeToPlayReward(param1:Boolean) : void
      {
         var _loc2_:Object = this.freeToPlayReward;
         if(_loc2_ !== param1)
         {
            this._35914986freeToPlayReward = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freeToPlayReward",_loc2_,param1));
         }
      }
      
      public function get freeToPlayReward() : Boolean
      {
         return this._freeToPlayReward;
      }
      
      [Bindable(event="propertyChange")]
      public function set secondarySearchTags(param1:Array) : void
      {
         var _loc2_:Object = this.secondarySearchTags;
         if(_loc2_ !== param1)
         {
            this._1095042677secondarySearchTags = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondarySearchTags",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}

