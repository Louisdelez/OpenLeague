package com.riotgames.pvpnet.itembrowser.sets.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.GUID;
   
   public class ItemSet
   {
      
      public static var UIDS:Number = 0;
      
      public static const MAX_BLOCKS:int = 20;
      
      public static const TYPE_GLOBAL_IMPORTANCE4:String = "global";
      
      public static const TYPE_CUSTOM_IMPORTANCE6:String = "custom";
      
      private var _isGlobalForMapsChanged:Signal = new Signal();
      
      public var blocks:Vector.<ItemSetBlock> = new Vector.<ItemSetBlock>();
      
      private var _isDirty:Boolean;
      
      private var _isGlobalForMaps:Boolean = true;
      
      private var _titleChanged:Signal = new Signal();
      
      private var _isGlobalForChampionsChanged:Signal = new Signal();
      
      private var _assignedMapsChanged:Signal = new Signal();
      
      public var cachedGamesItemsContainedTotal:int = 0;
      
      public var type:String = "custom";
      
      private var _isGlobalForChampions:Boolean = true;
      
      private var _blocksChanged:Signal = new Signal();
      
      public var uid:String = ItemSet.getNewUID();
      
      public var sortrank:Number = 0;
      
      private var _title:String;
      
      private var _assignedMaps:Vector.<uint> = new Vector.<uint>();
      
      public var cachedGamesItemsContainedCostTotal:int = 0;
      
      private var _isDirtyChanged:Signal = new Signal();
      
      private var _assignedChampionsChanged:Signal = new Signal();
      
      public var cachedBlocksContainedTotal:int = 0;
      
      private var _assignedChampions:Vector.<uint> = new Vector.<uint>();
      
      public function ItemSet()
      {
         super();
      }
      
      public static function getNewUID() : String
      {
         return "LOL_" + GUID.create();
      }
      
      public function getAssignedMaps() : Vector.<uint>
      {
         return this._assignedMaps;
      }
      
      public function setIsDirty(param1:Boolean) : void
      {
         if(param1 != this._isDirty || this._isDirty && param1)
         {
            this._isDirty = param1;
            this._isDirtyChanged.dispatch(param1);
         }
      }
      
      public function getAssignedChampionsChanged() : ISignal
      {
         return this._assignedChampionsChanged;
      }
      
      public function setIsGlobalForMaps(param1:Boolean) : void
      {
         if(this._isGlobalForMaps != param1)
         {
            this._isGlobalForMaps = param1;
            this._isGlobalForMapsChanged.dispatch(param1);
            this.setIsDirty(true);
         }
      }
      
      public function setAssignedMaps(param1:Vector.<uint>) : void
      {
         if(param1 != this._assignedMaps)
         {
            this._assignedMaps = param1;
            this._assignedMapsChanged.dispatch(this);
            this.setIsDirty(true);
         }
      }
      
      public function addAssignedChampion(param1:uint) : void
      {
         if(!this._assignedChampions)
         {
            return;
         }
         var _loc2_:int = this._assignedChampions.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._assignedChampions.push(param1);
            this._assignedChampionsChanged.dispatch(this);
            this.setIsDirty(true);
         }
      }
      
      public function getIsDirty() : Boolean
      {
         return this._isDirty;
      }
      
      public function getIsGlobalForMaps() : Boolean
      {
         return this._isGlobalForMaps;
      }
      
      public function getBlocksChanged() : ISignal
      {
         return this._blocksChanged;
      }
      
      public function isChampionIdAssignedToThisItemSet(param1:uint) : Boolean
      {
         return this._assignedChampions.indexOf(param1) != -1;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
         this._titleChanged.dispatch(param1);
         this.setIsDirty(true);
      }
      
      public function getAssignedMapsChanged() : ISignal
      {
         return this._assignedMapsChanged;
      }
      
      public function addBlockAt(param1:ItemSetBlock, param2:uint) : void
      {
         this.blocks.splice(param2,0,param1);
         this._blocksChanged.dispatch();
         this.setIsDirty(true);
      }
      
      public function setAssignedChampions(param1:Vector.<uint>) : void
      {
         if(param1 != this._assignedChampions)
         {
            this._assignedChampions = param1;
            this._assignedChampionsChanged.dispatch(this);
            this.setIsDirty(true);
         }
      }
      
      public function getIsDirtyChanged() : ISignal
      {
         return this._isDirtyChanged;
      }
      
      public function getAssignedChampions() : Vector.<uint>
      {
         return this._assignedChampions;
      }
      
      public function getIsGlobalForChampionsChanged() : ISignal
      {
         return this._isGlobalForChampionsChanged;
      }
      
      public function getIsGlobalForMapsChanged() : ISignal
      {
         return this._isGlobalForMapsChanged;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function getTitleChanged() : ISignal
      {
         return this._titleChanged;
      }
      
      public function removeBlock(param1:ItemSetBlock) : void
      {
         var _loc2_:int = this.blocks.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.blocks.splice(_loc2_,1);
            this._blocksChanged.dispatch();
            this.setIsDirty(true);
         }
      }
      
      public function addBlock(param1:ItemSetBlock) : void
      {
         this.addBlockAt(param1,this.blocks.length);
      }
      
      public function setIsGlobalForChampions(param1:Boolean) : void
      {
         if(this._isGlobalForChampions != param1)
         {
            this._isGlobalForChampions = param1;
            this._isGlobalForChampionsChanged.dispatch(param1);
            this.setIsDirty(true);
         }
      }
      
      public function isMapAssignedToThisItemSet(param1:uint) : Boolean
      {
         return this._assignedMaps.indexOf(param1) != -1;
      }
      
      public function removeAssignedChampion(param1:uint) : void
      {
         if(!this._assignedChampions)
         {
            return;
         }
         var _loc2_:int = this._assignedChampions.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._assignedChampions.splice(_loc2_,1);
            this._assignedChampionsChanged.dispatch(this);
            this.setIsDirty(true);
         }
      }
      
      public function getIsGlobalForChampions() : Boolean
      {
         return this._isGlobalForChampions;
      }
   }
}

