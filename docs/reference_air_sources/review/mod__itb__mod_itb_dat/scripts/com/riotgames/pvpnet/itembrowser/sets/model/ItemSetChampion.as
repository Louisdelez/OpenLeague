package com.riotgames.pvpnet.itembrowser.sets.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public class ItemSetChampion
   {
      
      private var _assignedItemSetsChanged:Signal = new Signal();
      
      private var _champion:Champion;
      
      private var _championChanged:Signal = new Signal();
      
      private var _assignedItemSets:Vector.<ItemSet> = new Vector.<ItemSet>();
      
      public function ItemSetChampion(param1:Champion)
      {
         super();
         this._champion = param1;
      }
      
      public function addAssignedItemSet(param1:ItemSet) : void
      {
         var _loc2_:int = this._assignedItemSets.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._assignedItemSets.push(param1);
            this._assignedItemSetsChanged.dispatch();
         }
      }
      
      public function getChampionDisplayName() : String
      {
         return this._champion.displayName;
      }
      
      public function getAssignedItemSets() : Vector.<ItemSet>
      {
         return this._assignedItemSets;
      }
      
      public function setAssignedItemSets(param1:Vector.<ItemSet>) : void
      {
         if(param1 != this._assignedItemSets)
         {
            this._assignedItemSets = param1;
            this._assignedItemSetsChanged.dispatch();
         }
      }
      
      public function getChampionID() : int
      {
         return this._champion.championId;
      }
      
      public function getAssignedItemSetsChanged() : ISignal
      {
         return this._assignedItemSetsChanged;
      }
      
      public function removeAssignedItemSet(param1:ItemSet) : void
      {
         var _loc2_:int = this._assignedItemSets.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._assignedItemSets.splice(_loc2_,1);
            this._assignedItemSetsChanged.dispatch();
         }
      }
      
      public function getChampion() : Champion
      {
         return this._champion;
      }
   }
}

