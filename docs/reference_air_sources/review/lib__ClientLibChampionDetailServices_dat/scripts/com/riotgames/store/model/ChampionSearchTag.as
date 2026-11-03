package com.riotgames.store.model
{
   public class ChampionSearchTag
   {
      
      public var id:uint;
      
      public var name:String;
      
      public var displayName:String;
      
      public function ChampionSearchTag()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[ChampionSearchTag id=" + this.id + " displayName=" + this.displayName + "]";
      }
   }
}

