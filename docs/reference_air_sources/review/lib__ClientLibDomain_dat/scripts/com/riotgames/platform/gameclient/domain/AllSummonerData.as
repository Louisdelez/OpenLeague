package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.AllSummonerData")]
   public class AllSummonerData extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1751869106summoner:Summoner;
      
      private var _1435247567spellBook:SpellBookDTO;
      
      private var _560666430summonerDefaultSpells:SummonerDefaultSpells;
      
      private var _2145603135summonerTalentsAndPoints:SummonerTalentsAndPoints;
      
      private var _1232274276summonerLevelAndPoints:SummonerLevelAndPoints;
      
      private var _1545882922summonerLevel:SummonerLevel;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AllSummonerData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerTalentsAndPoints() : SummonerTalentsAndPoints
      {
         return this._2145603135summonerTalentsAndPoints;
      }
      
      public function set summonerTalentsAndPoints(param1:SummonerTalentsAndPoints) : void
      {
         var _loc2_:Object = this._2145603135summonerTalentsAndPoints;
         if(_loc2_ !== param1)
         {
            this._2145603135summonerTalentsAndPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerTalentsAndPoints",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set summonerLevelAndPoints(param1:SummonerLevelAndPoints) : void
      {
         var _loc2_:Object = this._1232274276summonerLevelAndPoints;
         if(_loc2_ !== param1)
         {
            this._1232274276summonerLevelAndPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevelAndPoints",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get summoner() : Summoner
      {
         return this._1751869106summoner;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevel() : SummonerLevel
      {
         return this._1545882922summonerLevel;
      }
      
      public function set summoner(param1:Summoner) : void
      {
         var _loc2_:Object = this._1751869106summoner;
         if(_loc2_ !== param1)
         {
            this._1751869106summoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoner",_loc2_,param1));
         }
      }
      
      public function set spellBook(param1:SpellBookDTO) : void
      {
         var _loc2_:Object = this._1435247567spellBook;
         if(_loc2_ !== param1)
         {
            this._1435247567spellBook = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellBook",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevelAndPoints() : SummonerLevelAndPoints
      {
         return this._1232274276summonerLevelAndPoints;
      }
      
      public function set summonerLevel(param1:SummonerLevel) : void
      {
         var _loc2_:Object = this._1545882922summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spellBook() : SpellBookDTO
      {
         return this._1435247567spellBook;
      }
      
      public function set summonerDefaultSpells(param1:SummonerDefaultSpells) : void
      {
         var _loc2_:Object = this._560666430summonerDefaultSpells;
         if(_loc2_ !== param1)
         {
            this._560666430summonerDefaultSpells = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerDefaultSpells",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerDefaultSpells() : SummonerDefaultSpells
      {
         return this._560666430summonerDefaultSpells;
      }
   }
}

