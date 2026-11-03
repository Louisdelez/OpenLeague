package com.riotgames.platform.gameclient.skin.datagrid
{
   import mx.controls.DataGrid;
   
   public class GameDataGrid extends DataGrid
   {
      
      public function GameDataGrid()
      {
         super();
         this.headerClass = GameGridHeader;
      }
   }
}

