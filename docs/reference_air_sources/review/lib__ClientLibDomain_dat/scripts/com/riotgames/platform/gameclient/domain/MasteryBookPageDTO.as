package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.masterybook.MasteryBookPageDTO")]
   public class MasteryBookPageDTO extends AbstractBookPage
   {
      
      public function MasteryBookPageDTO()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function set talentEntries(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.talentEntries;
         if(_loc2_ !== param1)
         {
            this._85014012talentEntries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentEntries",_loc2_,param1));
         }
      }
      
      private function set _85014012talentEntries(param1:ArrayCollection) : void
      {
         this.entries = param1;
      }
      
      public function get talentEntries() : ArrayCollection
      {
         return entries;
      }
   }
}

