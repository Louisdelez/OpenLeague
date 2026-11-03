package com.riotgames.platform.gameclient.masteries
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.TalentGroup")]
   public class TalentGroup extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _talentRows:ArrayCollection;
      
      private var _991666338tltGroupId:int;
      
      private var _3373707name:String;
      
      private var _100346066index:int;
      
      private var sort:Sort;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TalentGroup()
      {
         super();
         var _loc1_:SortField = new SortField();
         this.sort = new Sort();
         _loc1_.name = "tltRowId";
         _loc1_.numeric = true;
         this.sort.fields = [_loc1_];
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      private function set _1397248229talentRows(param1:ArrayCollection) : void
      {
         if(param1 !== this._talentRows)
         {
            this._talentRows = param1;
            if(this._talentRows != null)
            {
               this._talentRows.sort = this.sort;
               this._talentRows.refresh();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set talentRows(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.talentRows;
         if(_loc2_ !== param1)
         {
            this._1397248229talentRows = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentRows",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get index() : int
      {
         return this._100346066index;
      }
      
      [Bindable(event="propertyChange")]
      public function get tltGroupId() : int
      {
         return this._991666338tltGroupId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get talentRows() : ArrayCollection
      {
         return this._talentRows;
      }
      
      public function set index(param1:int) : void
      {
         var _loc2_:Object = this._100346066index;
         if(_loc2_ !== param1)
         {
            this._100346066index = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"index",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set tltGroupId(param1:int) : void
      {
         var _loc2_:Object = this._991666338tltGroupId;
         if(_loc2_ !== param1)
         {
            this._991666338tltGroupId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tltGroupId",_loc2_,param1));
         }
      }
   }
}

