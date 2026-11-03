package com.riotgames.platform.gameclient.controllers.help
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class NewbieTipsController implements IEventDispatcher
   {
      
      private var _tipContent:String = "";
      
      private var _tipHeader:String = "";
      
      private var _isOpen:Boolean = false;
      
      private var _xPos:Number = 0;
      
      private var _yPos:Number = 0;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function NewbieTipsController()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function closeTip() : void
      {
         this.isOpen = false;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function set _1180237164isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function set tipContent(param1:String) : void
      {
         var _loc2_:Object = this.tipContent;
         if(_loc2_ !== param1)
         {
            this._1882441890tipContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tipContent",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get tipHeader() : String
      {
         return this._tipHeader;
      }
      
      [Bindable(event="propertyChange")]
      public function set tipHeader(param1:String) : void
      {
         var _loc2_:Object = this.tipHeader;
         if(_loc2_ !== param1)
         {
            this._1873899272tipHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tipHeader",_loc2_,param1));
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      private function set _3655356xPos(param1:Number) : void
      {
         this._xPos = param1;
      }
      
      public function get tipContent() : String
      {
         return this._tipContent;
      }
      
      private function set _3685147yPos(param1:Number) : void
      {
         this._yPos = param1;
      }
      
      private function set _1873899272tipHeader(param1:String) : void
      {
         this._tipHeader = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set isOpen(param1:Boolean) : void
      {
         var _loc2_:Object = this.isOpen;
         if(_loc2_ !== param1)
         {
            this._1180237164isOpen = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isOpen",_loc2_,param1));
         }
      }
      
      public function get yPos() : Number
      {
         return this._yPos;
      }
      
      public function openNewbieTip(param1:String, param2:String = "", param3:Number = -1, param4:Number = -1) : void
      {
         if(Boolean(UserPreferencesManager.userPrefs) && !UserPreferencesManager.userPrefs.newbieTipsEnabled)
         {
            return;
         }
         this.tipContent = param1;
         if(param3 >= 0)
         {
            this.xPos = param3;
         }
         if(param4 >= 0)
         {
            this.yPos = param4;
         }
         this.tipHeader = param2;
         this.isOpen = true;
      }
      
      [Bindable(event="propertyChange")]
      public function set yPos(param1:Number) : void
      {
         var _loc2_:Object = this.yPos;
         if(_loc2_ !== param1)
         {
            this._3685147yPos = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yPos",_loc2_,param1));
         }
      }
      
      private function set _1882441890tipContent(param1:String) : void
      {
         this._tipContent = param1;
      }
      
      public function get xPos() : Number
      {
         return this._xPos;
      }
      
      [Bindable(event="propertyChange")]
      public function set xPos(param1:Number) : void
      {
         var _loc2_:Object = this.xPos;
         if(_loc2_ !== param1)
         {
            this._3655356xPos = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPos",_loc2_,param1));
         }
      }
   }
}

