package com.riotgames.platform.gameclient.skin.datagrid
{
   import flash.display.Graphics;
   import mx.skins.halo.DataGridHeaderSeparator;
   
   public class DataGridHeaderSeparator extends mx.skins.halo.DataGridHeaderSeparator
   {
      
      public function DataGridHeaderSeparator()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,5542110,0.3);
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(0,param2);
         _loc3_.lineStyle(1,1187891,0.3);
         _loc3_.moveTo(1,0);
         _loc3_.lineTo(1,param2);
      }
   }
}

