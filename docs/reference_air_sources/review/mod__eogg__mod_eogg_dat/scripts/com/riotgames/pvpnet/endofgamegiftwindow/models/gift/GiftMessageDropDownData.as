package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   import blix.ds.IListX;
   import blix.ds.ListX;
   
   public class GiftMessageDropDownData
   {
      
      private var _label:String;
      
      private var _noneSelectedLabel:String;
      
      private var _listData:Vector.<GiftMessageDropDownItemData>;
      
      public function GiftMessageDropDownData(param1:String, param2:String, param3:Vector.<GiftMessageDropDownItemData>)
      {
         super();
         this._label = param1;
         this._noneSelectedLabel = param2;
         this._listData = param3;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function get noneSelectedLabel() : String
      {
         return this._noneSelectedLabel;
      }
      
      public function get listData() : IListX
      {
         return new ListX(this._listData);
      }
   }
}

