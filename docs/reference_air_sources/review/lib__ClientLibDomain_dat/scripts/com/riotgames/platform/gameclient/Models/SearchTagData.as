package com.riotgames.platform.gameclient.Models
{
   public class SearchTagData
   {
      
      public var enabled:Boolean = false;
      
      public var searchTag:String;
      
      public var searchTagDisplayName:String = "";
      
      public function SearchTagData(param1:String, param2:String, param3:Boolean = false)
      {
         super();
         this.searchTag = param1;
         this.searchTagDisplayName = param2;
         this.enabled = param3;
      }
   }
}

