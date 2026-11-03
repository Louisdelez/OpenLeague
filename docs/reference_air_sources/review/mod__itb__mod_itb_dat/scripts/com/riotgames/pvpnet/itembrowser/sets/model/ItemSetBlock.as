package com.riotgames.pvpnet.itembrowser.sets.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   public class ItemSetBlock
   {
      
      public static const MAX_ITEMS:uint = 20;
      
      public static const DATA_FORMAT:String = "itemSetBlockModel";
      
      public var items:Vector.<ItemSetItem> = new Vector.<ItemSetItem>();
      
      public var type:String = "";
      
      private var _blockTitleChanged:Signal = new Signal();
      
      public var cachedGamesItemsContainedTotal:int = 0;
      
      private var _itemsChanged:Signal = new Signal();
      
      public function ItemSetBlock()
      {
         super();
      }
      
      public function getBlockTitleChanged() : ISignal
      {
         return this._blockTitleChanged;
      }
      
      public function addItem(param1:ItemSetItem) : void
      {
         this.addItemAt(param1,this.items.length);
      }
      
      public function addItemAt(param1:ItemSetItem, param2:uint) : void
      {
         this.items.splice(param2,0,param1);
         this._itemsChanged.dispatch();
      }
      
      public function getItemsChanged() : ISignal
      {
         return this._itemsChanged;
      }
      
      public function setTitle(param1:String) : void
      {
         this.type = param1;
         this._blockTitleChanged.dispatch();
      }
      
      public function removeItem(param1:ItemSetItem) : void
      {
         var _loc2_:int = this.items.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.items.splice(_loc2_,1);
            this._itemsChanged.dispatch();
         }
      }
      
      public function getDisplayName() : String
      {
         var _loc1_:String = ResourceManager.getInstance().getString("itemBrowser","item_set_type_" + this.type);
         if(_loc1_ == null || StringUtil.trim(_loc1_).length <= 0)
         {
            _loc1_ = this.type;
         }
         return _loc1_;
      }
   }
}

