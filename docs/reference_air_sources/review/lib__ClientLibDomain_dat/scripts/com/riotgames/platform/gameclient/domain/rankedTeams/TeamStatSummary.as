package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.stats.TeamStatSummary")]
   public class TeamStatSummary extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1907013297teamStatDetails:ArrayCollection;
      
      private var _877713320teamId:TeamId;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TeamStatSummary()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set teamStatDetails(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1907013297teamStatDetails;
         if(_loc2_ !== param1)
         {
            this._1907013297teamStatDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamStatDetails",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      [Bindable(event="propertyChange")]
      public function get teamStatDetails() : ArrayCollection
      {
         return this._1907013297teamStatDetails;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function retrieveTeamStatDetail(param1:String) : TeamStatDetail
      {
         var _loc2_:TeamStatDetail = null;
         for each(_loc2_ in this.teamStatDetails)
         {
            if(_loc2_.teamStatType == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

