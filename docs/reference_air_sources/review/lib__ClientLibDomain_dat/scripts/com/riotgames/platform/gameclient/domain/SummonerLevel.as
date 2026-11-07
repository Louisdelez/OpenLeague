package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerLevel")]
   public class SummonerLevel extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1606126239infTierMod:Number;
      
      private var _848050759expToNextLevel:Number;
      
      private var _1745738979expTierMod:Number;
      
      private var _1545882922summonerLevel:Number;
      
      private var _504563792summonerTier:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerLevel()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set expTierMod(param1:Number) : void
      {
         var _loc2_:Object = this._1745738979expTierMod;
         if(_loc2_ !== param1)
         {
            this._1745738979expTierMod = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expTierMod",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevel() : Number
      {
         return this._1545882922summonerLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get infTierMod() : Number
      {
         return this._1606126239infTierMod;
      }
      
      public function set summonerTier(param1:Number) : void
      {
         var _loc2_:Object = this._504563792summonerTier;
         if(_loc2_ !== param1)
         {
            this._504563792summonerTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerTier",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get expTierMod() : Number
      {
         return this._1745738979expTierMod;
      }
      
      public function set summonerLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1545882922summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      public function set expToNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this._848050759expToNextLevel;
         if(_loc2_ !== param1)
         {
            this._848050759expToNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expToNextLevel",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get expToNextLevel() : Number
      {
         return this._848050759expToNextLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerTier() : Number
      {
         return this._504563792summonerTier;
      }
      
      public function set infTierMod(param1:Number) : void
      {
         var _loc2_:Object = this._1606126239infTierMod;
         if(_loc2_ !== param1)
         {
            this._1606126239infTierMod = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"infTierMod",_loc2_,param1));
         }
      }
   }
}

