package com.riotgames.platform.gameclient.domain.atomFeed
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class Atom10Link implements IEventDispatcher
   {
      
      private var _112793rel:String;
      
      private var _102727412label:String;
      
      private var _3575610type:String;
      
      private var _3211051href:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function Atom10Link()
      {
         super();
      }
      
      public static function parseFromXML(param1:XML) : Atom10Link
      {
         var _loc2_:Atom10Link = new Atom10Link();
         var _loc3_:Namespace = param1.namespace();
         var _loc4_:Namespace = param1.namespace("lol");
         _loc2_.rel = param1.@rel;
         _loc2_.href = param1.@href;
         _loc2_.type = param1.@type;
         _loc2_.label = _loc4_ != null ? param1._loc4_::@label : null;
         return _loc2_;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
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
      public function get rel() : String
      {
         return this._112793rel;
      }
      
      public function set href(param1:String) : void
      {
         var _loc2_:Object = this._3211051href;
         if(_loc2_ !== param1)
         {
            this._3211051href = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"href",_loc2_,param1));
         }
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this._102727412label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get href() : String
      {
         return this._3211051href;
      }
      
      public function set rel(param1:String) : void
      {
         var _loc2_:Object = this._112793rel;
         if(_loc2_ !== param1)
         {
            this._112793rel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : String
      {
         return this._102727412label;
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
   }
}

