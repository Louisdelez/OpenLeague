package com.riotgames.platform.gameclient.buddyImages
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class SummonerIconData implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1762615134restrictedFromUse:Boolean = false;
      
      private var _1191572123selected:Boolean;
      
      private var _1194062988iconId:int;
      
      private var _501509644iconSource:BitmapData;
      
      public function SummonerIconData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get iconSource() : BitmapData
      {
         return this._501509644iconSource;
      }
      
      public function set restrictedFromUse(param1:Boolean) : void
      {
         var _loc2_:Object = this._1762615134restrictedFromUse;
         if(_loc2_ !== param1)
         {
            this._1762615134restrictedFromUse = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"restrictedFromUse",_loc2_,param1));
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:Object = this._1191572123selected;
         if(_loc2_ !== param1)
         {
            this._1191572123selected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected",_loc2_,param1));
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
      public function get selected() : Boolean
      {
         return this._1191572123selected;
      }
      
      public function set iconSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this._501509644iconSource;
         if(_loc2_ !== param1)
         {
            this._501509644iconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconSource",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get restrictedFromUse() : Boolean
      {
         return this._1762615134restrictedFromUse;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set iconId(param1:int) : void
      {
         var _loc2_:Object = this._1194062988iconId;
         if(_loc2_ !== param1)
         {
            this._1194062988iconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get iconId() : int
      {
         return this._1194062988iconId;
      }
   }
}

