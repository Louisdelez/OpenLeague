package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public interface IEndOfGameGift
   {
      
      function get itemInventoryType() : String;
      
      function get itemName() : String;
      
      function get itemDescription() : String;
      
      function get itemID() : Number;
      
      function get currencyType() : String;
      
      function get itemCost() : Number;
      
      function get iconURL() : String;
      
      function get detailImageURL() : String;
   }
}

