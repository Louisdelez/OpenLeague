package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftMessageDropDownItemData
   {
      
      private var _itemLabel:String;
      
      private var _isSelectable:Boolean;
      
      public function GiftMessageDropDownItemData(param1:String, param2:Boolean)
      {
         super();
         this._itemLabel = param1;
         this._isSelectable = param2;
      }
      
      public function get itemLabel() : String
      {
         return this._itemLabel;
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
   }
}

