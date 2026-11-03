package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.leagues.pojo.MiniSeriesDTO")]
   public class MiniSeriesDTO implements IEventDispatcher
   {
      
      private var _3649559wins:int;
      
      private var _880905839target:int;
      
      private var _1096968431losses:int;
      
      private var _834577929timeLeftToPlayMillis:Number;
      
      private var _1001078227progress:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MiniSeriesDTO()
      {
         super();
      }
      
      public static function createFromObject(param1:Object) : MiniSeriesDTO
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:MiniSeriesDTO = new MiniSeriesDTO();
         if(param1.hasOwnProperty("target"))
         {
            _loc2_.target = param1["target"];
         }
         if(param1.hasOwnProperty("wins"))
         {
            _loc2_.wins = param1["wins"];
         }
         if(param1.hasOwnProperty("losses"))
         {
            _loc2_.losses = param1["losses"];
         }
         if(param1.hasOwnProperty("progress"))
         {
            _loc2_.progress = param1["progress"];
         }
         if(param1.hasOwnProperty("timeLeftToPlayMillis"))
         {
            _loc2_.timeLeftToPlayMillis = param1["timeLeftToPlayMillis"];
         }
         return _loc2_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLeftToPlayMillis() : Number
      {
         return this._834577929timeLeftToPlayMillis;
      }
      
      [Bindable(event="propertyChange")]
      public function get target() : int
      {
         return this._880905839target;
      }
      
      public function set timeLeftToPlayMillis(param1:Number) : void
      {
         var _loc2_:Object = this._834577929timeLeftToPlayMillis;
         if(_loc2_ !== param1)
         {
            this._834577929timeLeftToPlayMillis = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLeftToPlayMillis",_loc2_,param1));
         }
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
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : int
      {
         return this._1096968431losses;
      }
      
      public function set progress(param1:String) : void
      {
         var _loc2_:Object = this._1001078227progress;
         if(_loc2_ !== param1)
         {
            this._1001078227progress = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progress",_loc2_,param1));
         }
      }
      
      public function set losses(param1:int) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get progress() : String
      {
         return this._1001078227progress;
      }
      
      public function set target(param1:int) : void
      {
         var _loc2_:Object = this._880905839target;
         if(_loc2_ !== param1)
         {
            this._880905839target = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"target",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
   }
}

