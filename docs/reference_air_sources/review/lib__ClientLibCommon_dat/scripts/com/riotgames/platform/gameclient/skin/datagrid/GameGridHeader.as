package com.riotgames.platform.gameclient.skin.datagrid
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import mx.controls.dataGridClasses.DataGridHeader;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class GameGridHeader extends mx.controls.dataGridClasses.DataGridHeader
   {
      
      public function GameGridHeader()
      {
         super();
         cachedPaddingTop = 20;
      }
      
      override protected function drawHeaderIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         var _loc8_:Graphics = param1.graphics;
         _loc8_.clear();
         _loc8_.beginFill(param6,0.7);
         _loc8_.drawRect(6,6,param4 - 12,param5 - 12);
         _loc8_.endFill();
         param1.x = param2;
         param1.y = param3;
         var _loc9_:Array = [new BlurFilter(6,6,2)];
         param1.filters = _loc9_;
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
         var _loc8_:Graphics = param1.graphics;
         _loc8_.clear();
         _loc8_.beginFill(param6,0.7);
         _loc8_.drawRect(6,6,param4 - 12,param5 - 12);
         _loc8_.endFill();
         param1.x = param2;
         param1.y = param3;
         var _loc9_:Array = [new BlurFilter(6,6,2)];
         param1.filters = _loc9_;
      }
   }
}

