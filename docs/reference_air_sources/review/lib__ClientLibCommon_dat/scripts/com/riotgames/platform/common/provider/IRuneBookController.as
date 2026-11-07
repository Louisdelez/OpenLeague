package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import flash.display.DisplayObject;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   
   public interface IRuneBookController extends IEventDispatcher
   {
      
      function get tier2RunesFiltered() : Boolean;
      
      function set runeBook(param1:SpellBookDTO) : void;
      
      function set tier2RunesFiltered(param1:Boolean) : void;
      
      function addRuneToCombiner(param1:Rune) : void;
      
      function get currentRuneBookPage() : SpellBookPageDTO;
      
      function set isBusy(param1:Boolean) : void;
      
      function initialize() : void;
      
      function get standardSpellBookPageConfiguration() : ArrayCollection;
      
      function set currentRuneBookPage(param1:SpellBookPageDTO) : void;
      
      function get editing() : Boolean;
      
      function setSummonerData(param1:Summoner, param2:Number) : void;
      
      function set summoner(param1:Summoner) : void;
      
      function updateRuneInventoryCount() : void;
      
      function hydrateSpellBook(param1:SpellBookDTO) : void;
      
      function get tier3RunesFiltered() : Boolean;
      
      function get runeCategorySelected() : int;
      
      function set filteredYellowRunes(param1:ArrayCollection) : void;
      
      function set runeCategorySelected(param1:int) : void;
      
      function refreshRuneInventory(param1:Function = null) : void;
      
      function addRunesToInventory(param1:Array, param2:Boolean = true) : ArrayCollection;
      
      function set summonerLevel(param1:Number) : void;
      
      [Bindable(event="propertyChange")]
      function get filteredRedRunes() : ArrayCollection;
      
      function get summonerRunesAwardedList() : ArrayCollection;
      
      function set editing(param1:Boolean) : void;
      
      [Bindable(event="propertyChange")]
      function get filteredBlackRunes() : ArrayCollection;
      
      function saveSpellBook() : void;
      
      function get combining() : Boolean;
      
      function set filteredRedRunes(param1:ArrayCollection) : void;
      
      function set tier1RunesFiltered(param1:Boolean) : void;
      
      function get runeBook() : SpellBookDTO;
      
      function set tier3RunesFiltered(param1:Boolean) : void;
      
      function get isBusy() : Boolean;
      
      function get summoner() : Summoner;
      
      function set filteredBlueRunes(param1:ArrayCollection) : void;
      
      function set categoryNames(param1:ArrayCollection) : void;
      
      [Bindable(event="propertyChange")]
      function get filteredYellowRunes() : ArrayCollection;
      
      function get summonerLevel() : Number;
      
      function removeRuneFromCombiner(param1:Rune, param2:Boolean = true) : void;
      
      function set summonerRunesAwardedList(param1:ArrayCollection) : void;
      
      function get tier1RunesFiltered() : Boolean;
      
      function set filteredBlackRunes(param1:ArrayCollection) : void;
      
      function validateSpellBookName(param1:String) : String;
      
      [Bindable(event="propertyChange")]
      function get filteredBlueRunes() : ArrayCollection;
      
      function set hasUnsavedEdits(param1:Boolean) : void;
      
      function get categoryNames() : ArrayCollection;
      
      function deactivate() : void;
      
      function get hasUnsavedEdits() : Boolean;
      
      function set combining(param1:Boolean) : void;
      
      function promptToSaveBeforeExit(param1:DisplayObject, param2:Function) : void;
      
      function combineRunes(param1:ArrayCollection, param2:Function, param3:Object = null) : void;
      
      function undoRuneBookChanges() : void;
   }
}

