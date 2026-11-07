package com.riotgames.platform.gameclient.domain.social
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class SocialNetworkContact implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1714148973displayName:String;
      
      private var _1843485230network:String;
      
      private var _2062782441networkId:String;
      
      private var _1960030843invited:Number = -1;
      
      private var _2021920828hashedNetworkId:String;
      
      private var _1526632677summoners:ArrayCollection;
      
      public function SocialNetworkContact()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set summoners(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1526632677summoners;
         if(_loc2_ !== param1)
         {
            this._1526632677summoners = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoners",_loc2_,param1));
         }
      }
      
      public function set networkId(param1:String) : void
      {
         var _loc2_:Object = this._2062782441networkId;
         if(_loc2_ !== param1)
         {
            this._2062782441networkId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"networkId",_loc2_,param1));
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
      
      public function set network(param1:String) : void
      {
         var _loc2_:Object = this._1843485230network;
         if(_loc2_ !== param1)
         {
            this._1843485230network = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"network",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get summoners() : ArrayCollection
      {
         return this._1526632677summoners;
      }
      
      [Bindable(event="propertyChange")]
      public function get networkId() : String
      {
         return this._2062782441networkId;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get network() : String
      {
         return this._1843485230network;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set invited(param1:Number) : void
      {
         var _loc2_:Object = this._1960030843invited;
         if(_loc2_ !== param1)
         {
            this._1960030843invited = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invited",_loc2_,param1));
         }
      }
      
      public function set hashedNetworkId(param1:String) : void
      {
         var _loc2_:Object = this._2021920828hashedNetworkId;
         if(_loc2_ !== param1)
         {
            this._2021920828hashedNetworkId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hashedNetworkId",_loc2_,param1));
         }
      }
      
      public function addSummonerIfMissing(param1:SocialNetworkSummonerDTO) : Boolean
      {
         var _loc2_:SocialNetworkSummonerDTO = null;
         if(!this.summoners)
         {
            this.summoners = new ArrayCollection();
         }
         for each(_loc2_ in this.summoners)
         {
            if(_loc2_.sumId == param1.sumId)
            {
               return false;
            }
         }
         this.summoners.addItem(param1);
         return true;
      }
      
      [Bindable(event="propertyChange")]
      public function get invited() : Number
      {
         return this._1960030843invited;
      }
      
      [Bindable(event="propertyChange")]
      public function get hashedNetworkId() : String
      {
         return this._2021920828hashedNetworkId;
      }
   }
}

