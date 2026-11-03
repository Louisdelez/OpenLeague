package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerCatalog")]
   public class SummonerCatalog implements IEventDispatcher
   {
      
      private var _1397310122talentTree:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1003791059spellBookConfig:ArrayCollection;
      
      public function SummonerCatalog()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set spellBookConfig(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1003791059spellBookConfig;
         if(_loc2_ !== param1)
         {
            this._1003791059spellBookConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellBookConfig",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentTree() : ArrayCollection
      {
         return this._1397310122talentTree;
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
      public function get spellBookConfig() : ArrayCollection
      {
         return this._1003791059spellBookConfig;
      }
      
      public function set talentTree(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1397310122talentTree;
         if(_loc2_ !== param1)
         {
            this._1397310122talentTree = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentTree",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

