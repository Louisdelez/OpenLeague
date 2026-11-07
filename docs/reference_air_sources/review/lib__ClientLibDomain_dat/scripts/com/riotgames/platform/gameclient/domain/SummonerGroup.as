package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerGroup")]
   public class SummonerGroup implements IEventDispatcher
   {
      
      public static const SLOT_HEAD:String = "Head";
      
      public static const SLOT_CHEST:String = "Chest";
      
      public static const SLOT_LEGS:String = "Legs";
      
      public static const SLOT_GLOVES:String = "Gloves";
      
      public static const SLOT_BOOTS:String = "Boots";
      
      public static const SLOT_WEAPON:String = "Weapon";
      
      public static const SLOT_TRINKETS:String = "Trinkets";
      
      public static const SLOT_CONSUMABLE:String = "Consumable";
      
      public static const SLOT_NONEQUIP:String = "Nonequipped";
      
      private var _547161327isCurrent:String;
      
      private var _3373707name:String;
      
      private var _1724546052description:String;
      
      private var _98628832grpId:Number;
      
      private var _47913873summonerGroupItems:ArrayCollection;
      
      private var _109797574sumId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerGroup()
      {
         super();
      }
      
      public function set grpId(param1:Number) : void
      {
         var _loc2_:Object = this._98628832grpId;
         if(_loc2_ !== param1)
         {
            this._98628832grpId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grpId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sumId() : Number
      {
         return this._109797574sumId;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set sumId(param1:Number) : void
      {
         var _loc2_:Object = this._109797574sumId;
         if(_loc2_ !== param1)
         {
            this._109797574sumId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sumId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
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
      
      public function getItemBySlot(param1:String) : Item
      {
         var _loc2_:SummonerGroupItem = null;
         if(this.summonerGroupItems != null)
         {
            for each(_loc2_ in this.summonerGroupItems)
            {
               if(_loc2_ != null && _loc2_.item != null && _loc2_.item.itemType != null && _loc2_.item.itemType.name == param1)
               {
                  return _loc2_.item;
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get grpId() : Number
      {
         return this._98628832grpId;
      }
      
      public function set isCurrent(param1:String) : void
      {
         var _loc2_:Object = this._547161327isCurrent;
         if(_loc2_ !== param1)
         {
            this._547161327isCurrent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isCurrent",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set summonerGroupItems(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._47913873summonerGroupItems;
         if(_loc2_ !== param1)
         {
            this._47913873summonerGroupItems = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerGroupItems",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isCurrent() : String
      {
         return this._547161327isCurrent;
      }
      
      public function setItemBySlot(param1:String, param2:Item) : void
      {
         var _loc4_:SummonerGroupItem = null;
         var _loc5_:SummonerGroupItemPK = null;
         var _loc6_:SummonerGroupItem = null;
         var _loc3_:Boolean = false;
         if(this.summonerGroupItems != null)
         {
            for each(_loc4_ in this.summonerGroupItems)
            {
               if(_loc4_ != null && _loc4_.slotName == param1)
               {
                  _loc4_.item = param2;
                  _loc3_ = true;
               }
            }
         }
         else
         {
            this.summonerGroupItems = new ArrayCollection();
         }
         if(_loc3_ == false && param2 != null)
         {
            _loc5_ = new SummonerGroupItemPK();
            _loc5_.grpId = this.grpId;
            _loc5_.itemId = param2.itemId;
            _loc5_.slotName = param1;
            _loc6_ = new SummonerGroupItem();
            _loc6_.comp_id = _loc5_;
            _loc6_.item = param2;
            _loc6_.slotName = param1;
            this.summonerGroupItems.addItem(_loc6_);
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerGroupItems() : ArrayCollection
      {
         return this._47913873summonerGroupItems;
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

