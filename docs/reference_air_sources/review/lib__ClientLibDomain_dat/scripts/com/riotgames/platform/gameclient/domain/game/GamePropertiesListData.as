package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   public final class GamePropertiesListData implements IEventDispatcher
   {
      
      public var enabled:Boolean = false;
      
      public var meetsQueuePrerequisites:Boolean = true;
      
      public var baseLocaleKey:String = "";
      
      public var queuePrerequisiteNotMetTipMessage:String;
      
      public var parsedQueuePrerequisites:Array;
      
      public var queuePrerequisiteNotMetMessage:String;
      
      public var queueLevelRequirement:int = 0;
      
      public var toolTip:String = "";
      
      public var gameKey:String;
      
      private var _1424381023nextStep:Object = null;
      
      public var modifierProperties:Dictionary = new Dictionary();
      
      public var internalName:String = "";
      
      public var isAspirational:Boolean = false;
      
      public var displayTitle:String = "";
      
      public var parentList:GameOptionsList = null;
      
      public var subTitle:String = "";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GamePropertiesListData()
      {
         super();
      }
      
      public function get aspirationalToolTip() : String
      {
         var _loc1_:String = "";
         if(this.queueLevelRequirement > 0)
         {
            _loc1_ += RiotResourceLoader.getString(this.baseLocaleKey + "_aspirational_tooltip",null,[this.queueLevelRequirement]);
         }
         else if(this.nextStep is XML && Boolean(this.nextStep.@championCountRequirementNotMet))
         {
            _loc1_ += this.nextStep.@message;
         }
         return _loc1_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      
      public function refresh() : void
      {
         if(this.nextStep is GameOptionsList)
         {
            this.enabled = this.nextStep.enabled;
         }
         else if(this.nextStep is XML)
         {
            this.enabled = this.nextStep.@enabled == "true";
         }
         if(this.nextStep is GameOptionsList)
         {
            this.isAspirational = this.nextStep.isAspirational;
         }
         else if(this.nextStep is XML)
         {
            this.isAspirational = this.nextStep.@showAspirationalStep == "true";
         }
         if(this.isAspirational)
         {
            if(this.nextStep is GameOptionsList)
            {
               this.queueLevelRequirement = this.nextStep.queueLevelRequirement;
            }
            else if(this.nextStep is XML)
            {
               this.queueLevelRequirement = this.nextStep.@queueLevelRequirement;
            }
         }
      }
      
      public function setSelected() : Boolean
      {
         return this.parentList.selectChild(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get nextStep() : Object
      {
         return this._1424381023nextStep;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set nextStep(param1:Object) : void
      {
         var _loc2_:Object = this._1424381023nextStep;
         if(_loc2_ !== param1)
         {
            this._1424381023nextStep = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nextStep",_loc2_,param1));
         }
      }
   }
}

