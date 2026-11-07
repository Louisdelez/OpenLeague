package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.runes.RuneType")]
   public class RuneType extends AbstractDomainObject implements IEventDispatcher
   {
      
      private static var _470763519BLUE_RUNE:int = 5;
      
      private static var _1666914341YELLOW_RUNE:int = 3;
      
      private static var _26815048RED_RUNE:int = 1;
      
      private static var _1123368038BLACK_RUNE:int = 7;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _1547279921runeTypeId:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RuneType()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public static function get YELLOW_RUNE() : int
      {
         return RuneType._1666914341YELLOW_RUNE;
      }
      
      [Bindable(event="propertyChange")]
      public static function get BLACK_RUNE() : int
      {
         return RuneType._1123368038BLACK_RUNE;
      }
      
      public static function set YELLOW_RUNE(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = RuneType._1666914341YELLOW_RUNE;
         if(_loc2_ !== param1)
         {
            RuneType._1666914341YELLOW_RUNE = param1;
            _loc3_ = RuneType.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(RuneType,"YELLOW_RUNE",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get RED_RUNE() : int
      {
         return RuneType._26815048RED_RUNE;
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set RED_RUNE(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = RuneType._26815048RED_RUNE;
         if(_loc2_ !== param1)
         {
            RuneType._26815048RED_RUNE = param1;
            _loc3_ = RuneType.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(RuneType,"RED_RUNE",_loc2_,param1));
            }
         }
      }
      
      public static function set BLACK_RUNE(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = RuneType._1123368038BLACK_RUNE;
         if(_loc2_ !== param1)
         {
            RuneType._1123368038BLACK_RUNE = param1;
            _loc3_ = RuneType.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(RuneType,"BLACK_RUNE",_loc2_,param1));
            }
         }
      }
      
      public static function set BLUE_RUNE(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = RuneType._470763519BLUE_RUNE;
         if(_loc2_ !== param1)
         {
            RuneType._470763519BLUE_RUNE = param1;
            _loc3_ = RuneType.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(RuneType,"BLUE_RUNE",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get BLUE_RUNE() : int
      {
         return RuneType._470763519BLUE_RUNE;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function getColorValue(param1:int = -1) : uint
      {
         if(param1 == -1)
         {
            param1 = this.runeTypeId;
         }
         switch(param1)
         {
            case RuneType.BLUE_RUNE:
               return 5025791;
            case RuneType.RED_RUNE:
               return 14483456;
            case RuneType.YELLOW_RUNE:
               return 14540032;
            case RuneType.BLACK_RUNE:
               return 11360767;
            default:
               return 16777215;
         }
      }
      
      public function getColorString(param1:int = -1) : String
      {
         if(param1 == -1)
         {
            param1 = this.runeTypeId;
         }
         switch(param1)
         {
            case RuneType.BLUE_RUNE:
               return "#4CAFFF";
            case RuneType.RED_RUNE:
               return "#DD0000";
            case RuneType.YELLOW_RUNE:
               return "#DDDD00";
            case RuneType.BLACK_RUNE:
               return "#AD59FF";
            default:
               return "#FFFFFF";
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function localizeNameSingular() : String
      {
         switch(this.runeTypeId)
         {
            case RuneType.BLUE_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_blue_single");
            case RuneType.RED_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_red_single");
            case RuneType.YELLOW_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_yellow_single");
            case RuneType.BLACK_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_black_single");
            default:
               return "";
         }
      }
      
      public function toString() : String
      {
         return "type: " + this.runeTypeId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get runeTypeId() : int
      {
         return this._1547279921runeTypeId;
      }
      
      public function localizeName() : String
      {
         switch(this.runeTypeId)
         {
            case RuneType.BLUE_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_blue");
            case RuneType.RED_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_red");
            case RuneType.YELLOW_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_yellow");
            case RuneType.BLACK_RUNE:
               return ResourceManager.getInstance().getString("resources","runebook_runeInventory_black");
            default:
               return "";
         }
      }
      
      public function set runeTypeId(param1:int) : void
      {
         var _loc2_:Object = this._1547279921runeTypeId;
         if(_loc2_ !== param1)
         {
            this._1547279921runeTypeId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeTypeId",_loc2_,param1));
         }
      }
      
      public function equals(param1:RuneType) : Boolean
      {
         return param1 == this || param1 != null && param1.runeTypeId == this.runeTypeId;
      }
   }
}

