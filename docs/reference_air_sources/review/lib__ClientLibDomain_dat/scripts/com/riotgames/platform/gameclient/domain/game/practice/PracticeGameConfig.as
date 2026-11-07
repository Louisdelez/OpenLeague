package com.riotgames.platform.gameclient.domain.game.practice
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.PracticeGameConfig")]
   public class PracticeGameConfig implements IEventDispatcher
   {
      
      public var allowSpectators:String;
      
      public var maxNumPlayers:int;
      
      private var _195623926gameMap:GameMap;
      
      public var passbackUrl:String;
      
      public var gameName:String;
      
      public var gameMutators:ArrayCollection;
      
      public var gamePassword:String;
      
      public var passbackDataPacket:String;
      
      public var region:String;
      
      public var gameTypeConfig:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public var gameMode:String;
      
      public function PracticeGameConfig()
      {
         super();
         this.gameMutators = new ArrayCollection();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMap() : GameMap
      {
         return this._195623926gameMap;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         var _loc2_:Object = this._195623926gameMap;
         if(_loc2_ !== param1)
         {
            this._195623926gameMap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMap",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function stringsMatch(param1:String, param2:String) : Boolean
      {
         if((param1 == null || param1.length == 0) && (param2 == null || param2.length == 0))
         {
            return true;
         }
         return param1 == param2;
      }
      
      public function equals(param1:PracticeGameConfig) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(this.region != param1.region)
         {
            return false;
         }
         if(this.gameName != param1.gameName)
         {
            return false;
         }
         if(this.gameMode != param1.gameMode)
         {
            return false;
         }
         if(this.gameMap != param1.gameMap)
         {
            return false;
         }
         if(this.maxNumPlayers != param1.maxNumPlayers)
         {
            return false;
         }
         if(this.gameTypeConfig != param1.gameTypeConfig)
         {
            return false;
         }
         if(!this.stringsMatch(this.gamePassword,param1.gamePassword))
         {
            return false;
         }
         if(this.allowSpectators != param1.allowSpectators)
         {
            return false;
         }
         if(!this.stringsMatch(this.passbackUrl,param1.passbackUrl))
         {
            return false;
         }
         if(!this.stringsMatch(this.passbackDataPacket,param1.passbackDataPacket))
         {
            return false;
         }
         return true;
      }
   }
}

