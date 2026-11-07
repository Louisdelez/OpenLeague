package com.riotgames.platform.gameclient.domain.summoner
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo")]
   public class LevelUpInfo implements IEventDispatcher
   {
      
      public static const MAX_LEVEL:int = 30;
      
      private var _1199243345nextLevel:Number = 0;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _623422778pointsEarned:Number = 0;
      
      private var _1450930571currentLevel:Number = 0;
      
      private var _1995011888lastPercentCompleteForNextLevel:Number = 0;
      
      private var _504377593summonerName:String;
      
      private var _578190767totalExperiencePoints:Number = 0;
      
      private var _2130969940pointsNeededToLevelUp:Number = 0;
      
      public function LevelUpInfo()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set pointsEarned(param1:Number) : void
      {
         var _loc2_:Object = this._623422778pointsEarned;
         if(_loc2_ !== param1)
         {
            this._623422778pointsEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsEarned",_loc2_,param1));
         }
      }
      
      public function get totalPointsNeededForNextLevel() : Number
      {
         return this.totalExperiencePoints + this.pointsNeededToLevelUp;
      }
      
      public function get percentCompleteForNextLevel() : Number
      {
         if(this.totalExperiencePoints + this.pointsNeededToLevelUp == 0)
         {
            return 0;
         }
         return this.totalExperiencePoints / this.totalPointsNeededForNextLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function set totalPointsNeededForNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this.totalPointsNeededForNextLevel;
         if(_loc2_ !== param1)
         {
            this._1216261244totalPointsNeededForNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalPointsNeededForNextLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentLevel() : Number
      {
         return this._1450930571currentLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function set percentCompleteForNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this.percentCompleteForNextLevel;
         if(_loc2_ !== param1)
         {
            this._235134650percentCompleteForNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"percentCompleteForNextLevel",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get lastPercentCompleteForNextLevel() : Number
      {
         return this._1995011888lastPercentCompleteForNextLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get nextLevel() : Number
      {
         return this._1199243345nextLevel;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set currentLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1450930571currentLevel;
         if(_loc2_ !== param1)
         {
            this._1450930571currentLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentLevel",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set pointsNeededToLevelUp(param1:Number) : void
      {
         var _loc2_:Object = this._2130969940pointsNeededToLevelUp;
         if(_loc2_ !== param1)
         {
            this._2130969940pointsNeededToLevelUp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsNeededToLevelUp",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get totalExperiencePoints() : Number
      {
         return this._578190767totalExperiencePoints;
      }
      
      public function set nextLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1199243345nextLevel;
         if(_loc2_ !== param1)
         {
            this._1199243345nextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nextLevel",_loc2_,param1));
         }
      }
      
      private function set _235134650percentCompleteForNextLevel(param1:Number) : void
      {
      }
      
      public function set totalExperiencePoints(param1:Number) : void
      {
         var _loc2_:Object = this._578190767totalExperiencePoints;
         if(_loc2_ !== param1)
         {
            this._578190767totalExperiencePoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalExperiencePoints",_loc2_,param1));
         }
      }
      
      public function set lastPercentCompleteForNextLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1995011888lastPercentCompleteForNextLevel;
         if(_loc2_ !== param1)
         {
            this._1995011888lastPercentCompleteForNextLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastPercentCompleteForNextLevel",_loc2_,param1));
         }
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
      }
      
      private function set _1216261244totalPointsNeededForNextLevel(param1:Number) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsEarned() : Number
      {
         return this._623422778pointsEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsNeededToLevelUp() : Number
      {
         return this._2130969940pointsNeededToLevelUp;
      }
   }
}

