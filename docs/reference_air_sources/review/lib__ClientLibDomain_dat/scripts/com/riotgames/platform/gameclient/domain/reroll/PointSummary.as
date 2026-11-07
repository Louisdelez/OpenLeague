package com.riotgames.platform.gameclient.domain.reroll
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.reroll.pojo.PointSummary")]
   public class PointSummary implements IEventDispatcher
   {
      
      private var _486468081_maxRolls:int;
      
      private var _2107598217_numberOfRolls:int;
      
      private var _2055850137_pointsCostToRoll:Number;
      
      private var _553471667_pointsToNextRoll:Number;
      
      private var _1369119165_currentPoints:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PointSummary()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get _currentPoints() : Number
      {
         return this._1369119165_currentPoints;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function set _268874002pointsToNextRoll(param1:Number) : void
      {
         this._pointsToNextRoll = param1;
      }
      
      private function set _395950226maxRolls(param1:int) : void
      {
         this._maxRolls = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get _pointsCostToRoll() : Number
      {
         return this._2055850137_pointsCostToRoll;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get _pointsToNextRoll() : Number
      {
         return this._553471667_pointsToNextRoll;
      }
      
      private function set _1771252472pointsCostToRoll(param1:Number) : void
      {
         this._pointsCostToRoll = param1;
      }
      
      public function get pointsCostToRoll() : Number
      {
         return this._pointsCostToRoll;
      }
      
      public function get maxRolls() : int
      {
         return this._maxRolls;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set _pointsCostToRoll(param1:Number) : void
      {
         var _loc2_:Object = this._2055850137_pointsCostToRoll;
         if(_loc2_ !== param1)
         {
            this._2055850137_pointsCostToRoll = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_pointsCostToRoll",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set pointsCostToRoll(param1:Number) : void
      {
         var _loc2_:Object = this.pointsCostToRoll;
         if(_loc2_ !== param1)
         {
            this._1771252472pointsCostToRoll = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsCostToRoll",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set _pointsToNextRoll(param1:Number) : void
      {
         var _loc2_:Object = this._553471667_pointsToNextRoll;
         if(_loc2_ !== param1)
         {
            this._553471667_pointsToNextRoll = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_pointsToNextRoll",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set pointsToNextRoll(param1:Number) : void
      {
         var _loc2_:Object = this.pointsToNextRoll;
         if(_loc2_ !== param1)
         {
            this._268874002pointsToNextRoll = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsToNextRoll",_loc2_,param1));
         }
      }
      
      private function set _2142419012currentPoints(param1:Number) : void
      {
         this._currentPoints = param1;
      }
      
      public function set _maxRolls(param1:int) : void
      {
         var _loc2_:Object = this._486468081_maxRolls;
         if(_loc2_ !== param1)
         {
            this._486468081_maxRolls = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_maxRolls",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maxRolls(param1:int) : void
      {
         var _loc2_:Object = this.maxRolls;
         if(_loc2_ !== param1)
         {
            this._395950226maxRolls = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxRolls",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currentPoints(param1:Number) : void
      {
         var _loc2_:Object = this.currentPoints;
         if(_loc2_ !== param1)
         {
            this._2142419012currentPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentPoints",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set numberOfRolls(param1:int) : void
      {
         var _loc2_:Object = this.numberOfRolls;
         if(_loc2_ !== param1)
         {
            this._1324169098numberOfRolls = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numberOfRolls",_loc2_,param1));
         }
      }
      
      public function get pointsToNextRoll() : Number
      {
         return this._pointsToNextRoll;
      }
      
      [Bindable(event="propertyChange")]
      public function get _maxRolls() : int
      {
         return this._486468081_maxRolls;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set _numberOfRolls(param1:int) : void
      {
         var _loc2_:Object = this._2107598217_numberOfRolls;
         if(_loc2_ !== param1)
         {
            this._2107598217_numberOfRolls = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_numberOfRolls",_loc2_,param1));
         }
      }
      
      public function get numberOfRolls() : int
      {
         return this._numberOfRolls;
      }
      
      private function set _1324169098numberOfRolls(param1:int) : void
      {
         this._numberOfRolls = param1;
      }
      
      public function set _currentPoints(param1:Number) : void
      {
         var _loc2_:Object = this._1369119165_currentPoints;
         if(_loc2_ !== param1)
         {
            this._1369119165_currentPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_currentPoints",_loc2_,param1));
         }
      }
      
      public function get currentPoints() : Number
      {
         return this._currentPoints;
      }
      
      public function get rerollProgress() : uint
      {
         if(this._numberOfRolls == this._maxRolls)
         {
            return this.pointsCostToRoll;
         }
         return this.pointsCostToRoll - this.pointsToNextRoll;
      }
      
      [Bindable(event="propertyChange")]
      public function get _numberOfRolls() : int
      {
         return this._2107598217_numberOfRolls;
      }
   }
}

