package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.MatchMakerParams")]
   public class MatchMakerParams implements IEventDispatcher
   {
      
      private var _596621326lastMaestroMessage:String;
      
      private var _1164501017queueIds:Array;
      
      private var _1518327835languages:ArrayCollection;
      
      private var _1967128212invitationId:String;
      
      private var _5372702botDifficulty:String;
      
      private var _877713320teamId:TeamId;
      
      private var _3555933team:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MatchMakerParams()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set botDifficulty(param1:String) : void
      {
         var _loc2_:Object = this._5372702botDifficulty;
         if(_loc2_ !== param1)
         {
            this._5372702botDifficulty = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botDifficulty",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set queueIds(param1:Array) : void
      {
         var _loc2_:Object = this._1164501017queueIds;
         if(_loc2_ !== param1)
         {
            this._1164501017queueIds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueIds",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get invitationId() : String
      {
         return this._1967128212invitationId;
      }
      
      [Bindable(event="propertyChange")]
      public function get lastMaestroMessage() : String
      {
         return this._596621326lastMaestroMessage;
      }
      
      [Bindable(event="propertyChange")]
      public function get languages() : ArrayCollection
      {
         return this._1518327835languages;
      }
      
      public function set lastMaestroMessage(param1:String) : void
      {
         var _loc2_:Object = this._596621326lastMaestroMessage;
         if(_loc2_ !== param1)
         {
            this._596621326lastMaestroMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastMaestroMessage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get team() : ArrayCollection
      {
         return this._3555933team;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
      
      [Bindable(event="propertyChange")]
      public function get botDifficulty() : String
      {
         return this._5372702botDifficulty;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueIds() : Array
      {
         return this._1164501017queueIds;
      }
      
      public function set invitationId(param1:String) : void
      {
         var _loc2_:Object = this._1967128212invitationId;
         if(_loc2_ !== param1)
         {
            this._1967128212invitationId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invitationId",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set languages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1518327835languages;
         if(_loc2_ !== param1)
         {
            this._1518327835languages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"languages",_loc2_,param1));
         }
      }
      
      public function set teamId(param1:TeamId) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function set team(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._3555933team;
         if(_loc2_ !== param1)
         {
            this._3555933team = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

