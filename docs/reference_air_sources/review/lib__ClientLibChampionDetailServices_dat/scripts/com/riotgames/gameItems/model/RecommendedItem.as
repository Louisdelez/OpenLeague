package com.riotgames.gameItems.model
{
   public class RecommendedItem
   {
      
      public var itemId:uint;
      
      public var gameMode:String;
      
      public function RecommendedItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[RecommendedItem itemId=\'" + this.itemId + "\' gameMode=\'" + this.gameMode + "\']";
      }
   }
}

