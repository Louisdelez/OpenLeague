package com.riotgames.platform.gameclient.controllers.game
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   public class GlowComponentController implements IEventDispatcher
   {
      
      private var glowObjects:Dictionary = new Dictionary();
      
      private var _activeGlow:GlowTarget = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GlowComponentController()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function registerGlowTarget(param1:String, param2:DisplayObject) : void
      {
         this.glowObjects[param1] = param2;
      }
      
      public function get activeGlow() : GlowTarget
      {
         return this._activeGlow;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set activeGlow(param1:GlowTarget) : void
      {
         var _loc2_:Object = this.activeGlow;
         if(_loc2_ !== param1)
         {
            this._2043573683activeGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activeGlow",_loc2_,param1));
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
      
      public function stopGlow() : void
      {
         this.activeGlow = null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function startGlow(param1:String, param2:GlowComponentParameters) : void
      {
         var _loc4_:GlowTarget = null;
         var _loc3_:DisplayObject = this.glowObjects[param1];
         if(Boolean(_loc3_))
         {
            _loc4_ = new GlowTarget();
            _loc4_.displayTarget = _loc3_;
            _loc4_.parameters = param2;
            this.activeGlow = _loc4_;
         }
      }
      
      public function unregisterGlowTarget(param1:String) : void
      {
         this.glowObjects[param1] = null;
      }
      
      private function set _2043573683activeGlow(param1:GlowTarget) : void
      {
         this._activeGlow = param1;
      }
   }
}

