package com.riotgames.platform.gameclient.components.list
{
   import mx.controls.List;
   
   public class BotChampionList extends List
   {
      
      public function BotChampionList()
      {
         super();
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.setStyle("backgroundColor","#020202");
         this.setStyle("rollOverColor","#486B96");
         this.rowHeight = 45;
      }
      
      override public function isItemSelectable(param1:Object) : Boolean
      {
         return Boolean(super.isItemSelectable(param1)) && param1.participant == null;
      }
   }
}

