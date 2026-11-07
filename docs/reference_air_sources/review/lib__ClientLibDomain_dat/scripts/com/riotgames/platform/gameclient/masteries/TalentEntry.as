package com.riotgames.platform.gameclient.masteries
{
   import com.riotgames.platform.gameclient.domain.Entry;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.masterybook.TalentEntry")]
   public class TalentEntry extends Entry
   {
      
      private var _talentId:int;
      
      private var _rank:int;
      
      public function TalentEntry()
      {
         super();
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      public function get talentId() : int
      {
         return this._talentId;
      }
      
      private function set _3492908rank(param1:int) : void
      {
         this._rank = param1;
      }
      
      private function set _615305433talentId(param1:int) : void
      {
         this._talentId = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set talentId(param1:int) : void
      {
         var _loc2_:Object = this.talentId;
         if(_loc2_ !== param1)
         {
            this._615305433talentId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set rank(param1:int) : void
      {
         var _loc2_:Object = this.rank;
         if(_loc2_ !== param1)
         {
            this._3492908rank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rank",_loc2_,param1));
         }
      }
   }
}

