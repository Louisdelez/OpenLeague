package com.riotgames.platform.gameclient.domain.atomFeed
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class Atom10Feed implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _50511102category:String;
      
      private var _931102249rights:String;
      
      private var _1591573360entries:ArrayCollection;
      
      private var _570265847updatedDate:Date;
      
      private var _2060497896subtitle:String;
      
      private var _3355id:String;
      
      private var _110371416title:String;
      
      public function Atom10Feed()
      {
         super();
      }
      
      public static function parseFromXML(param1:XML) : Atom10Feed
      {
         var _loc11_:XML = null;
         var _loc2_:Atom10Feed = new Atom10Feed();
         var _loc3_:Namespace = param1.namespace();
         _loc2_.id = param1._loc3_::id;
         _loc2_.title = param1._loc3_::title;
         var _loc4_:String = param1._loc3_::updated;
         var _loc5_:String = _loc4_.substring(0,4);
         var _loc6_:String = _loc4_.substring(5,7);
         var _loc7_:String = _loc4_.substring(8,10);
         var _loc8_:String = _loc4_.substring(11,13);
         var _loc9_:String = _loc4_.substring(14,16);
         var _loc10_:String = _loc4_.substring(17,19);
         _loc2_.updatedDate = new Date(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         _loc2_.subtitle = param1._loc3_::subtitle;
         _loc2_.category = param1._loc3_::category.@term;
         _loc2_.rights = param1._loc3_::rights;
         _loc2_.entries = new ArrayCollection();
         for each(_loc11_ in param1._loc3_::entry)
         {
            _loc2_.entries.addItem(Atom10Entry.parseFromXML(_loc11_));
         }
         return _loc2_;
      }
      
      public static function parseFromXMLString(param1:String) : Atom10Feed
      {
         var _loc2_:XML = new XML(param1);
         return Atom10Feed.parseFromXML(_loc2_);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get updatedDate() : Date
      {
         return this._570265847updatedDate;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get entries() : ArrayCollection
      {
         return this._1591573360entries;
      }
      
      public function set updatedDate(param1:Date) : void
      {
         var _loc2_:Object = this._570265847updatedDate;
         if(_loc2_ !== param1)
         {
            this._570265847updatedDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"updatedDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rights() : String
      {
         return this._931102249rights;
      }
      
      [Bindable(event="propertyChange")]
      public function get subtitle() : String
      {
         return this._2060497896subtitle;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      public function set entries(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1591573360entries;
         if(_loc2_ !== param1)
         {
            this._1591573360entries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entries",_loc2_,param1));
         }
      }
      
      public function set rights(param1:String) : void
      {
         var _loc2_:Object = this._931102249rights;
         if(_loc2_ !== param1)
         {
            this._931102249rights = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rights",_loc2_,param1));
         }
      }
      
      public function set subtitle(param1:String) : void
      {
         var _loc2_:Object = this._2060497896subtitle;
         if(_loc2_ !== param1)
         {
            this._2060497896subtitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subtitle",_loc2_,param1));
         }
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      public function set category(param1:String) : void
      {
         var _loc2_:Object = this._50511102category;
         if(_loc2_ !== param1)
         {
            this._50511102category = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"category",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get category() : String
      {
         return this._50511102category;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
   }
}

