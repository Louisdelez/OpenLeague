package com.riotgames.platform.gameclient.domain
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   
   public interface IChampionFilter
   {
      
      function setSearchTags(param1:Array) : void;
      
      function getChanged() : ISignal;
      
      function getFilterString() : String;
      
      function setCustomFilterFunction(param1:Function) : void;
      
      function setFilterString(param1:String) : void;
      
      function setOwnedState(param1:uint) : void;
      
      function resetSearchTags() : void;
      
      function getCustomFilterFunction() : Function;
      
      function filter(param1:Champion, param2:int = -1, param3:Array = null) : Boolean;
      
      function setTagState(param1:SearchTagData, param2:Boolean, param3:Boolean = true) : *;
      
      function getSearchTags() : Array;
      
      function sortByDisplayName(param1:Object, param2:Object, param3:Array = null) : int;
   }
}

