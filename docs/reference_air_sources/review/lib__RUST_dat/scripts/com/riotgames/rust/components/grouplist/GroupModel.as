package com.riotgames.rust.components.grouplist
{
   import blix.signals.Signal;
   
   public class GroupModel
   {
      
      private var _headerData:*;
      
      private var _itemData:Array;
      
      private var _unfilteredSize:int;
      
      public var headerChanged:Signal = new Signal();
      
      public var itemsChanged:Signal = new Signal();
      
      private var _expanded:Boolean = true;
      
      public var expandedChanged:Signal = new Signal();
      
      public function GroupModel()
      {
         super();
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         this._expanded = param1;
         this.expandedChanged.dispatch(this);
      }
      
      public function get headerData() : *
      {
         return this._headerData;
      }
      
      public function set headerData(param1:*) : void
      {
         this._headerData = param1;
         this.headerChanged.dispatch(this);
      }
      
      public function get itemData() : Array
      {
         return this._itemData;
      }
      
      public function set itemData(param1:Array) : void
      {
         this._itemData = param1;
         this.itemsChanged.dispatch(this);
      }
      
      public function get unfilteredSize() : int
      {
         return this._unfilteredSize;
      }
      
      public function set unfilteredSize(param1:int) : void
      {
         this._unfilteredSize = param1;
      }
   }
}

