package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.dto.RosterDTO")]
   public class Roster extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1341402536memberList:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1054729426ownerId:Number;
      
      public function Roster()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function retrieveMemberStatus(param1:Number) : String
      {
         var _loc2_:TeamMemberInfo = null;
         for each(_loc2_ in this.memberList)
         {
            if(_loc2_.playerId == param1)
            {
               return _loc2_.status;
            }
         }
         return null;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerId() : Number
      {
         return this._1054729426ownerId;
      }
      
      public function set memberList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1341402536memberList;
         if(_loc2_ !== param1)
         {
            this._1341402536memberList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberList",_loc2_,param1));
         }
      }
      
      public function set ownerId(param1:Number) : void
      {
         var _loc2_:Object = this._1054729426ownerId;
         if(_loc2_ !== param1)
         {
            this._1054729426ownerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get memberList() : ArrayCollection
      {
         return this._1341402536memberList;
      }
   }
}

