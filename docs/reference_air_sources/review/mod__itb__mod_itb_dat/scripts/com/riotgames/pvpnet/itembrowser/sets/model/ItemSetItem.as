package com.riotgames.pvpnet.itembrowser.sets.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.gameItems.model.GameItem;
   
   public class ItemSetItem
   {
      
      public static const DATA_FORMAT:String = "itemSetItemData";
      
      private var _gameItem:GameItem;
      
      private var _stacksChanged:Signal = new Signal();
      
      private var _gameItemChanged:Signal = new Signal();
      
      private var _stacks:int = 1;
      
      public function ItemSetItem(param1:GameItem = null, param2:int = 1)
      {
         super();
         this.setGameItem(param1);
         this.setStacks(param2);
      }
      
      public function getStacks() : int
      {
         return this._stacks;
      }
      
      public function getGameItem() : GameItem
      {
         return this._gameItem;
      }
      
      public function setGameItem(param1:GameItem) : void
      {
         if(param1 != this._gameItem)
         {
            this._gameItem = param1;
            this._gameItemChanged.dispatch();
         }
      }
      
      public function setStacks(param1:int) : void
      {
         if(param1 != this._stacks)
         {
            if(this._gameItem)
            {
               if(param1 > this._gameItem.stacks)
               {
                  this._stacks = this._gameItem.stacks;
               }
               else if(param1 < 1)
               {
                  this._stacks = 1;
               }
               else
               {
                  this._stacks = param1;
               }
               this._stacksChanged.dispatch();
            }
         }
      }
      
      public function getGameItemChanged() : ISignal
      {
         return this._gameItemChanged;
      }
      
      public function getStacksChanged() : ISignal
      {
         return this._stacksChanged;
      }
   }
}

