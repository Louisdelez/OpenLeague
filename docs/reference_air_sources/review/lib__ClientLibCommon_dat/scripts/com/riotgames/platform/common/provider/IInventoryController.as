package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameItem;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.store.RentalUpdateNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public interface IInventoryController extends IEventDispatcher
   {
      
      function findChampionBySkinName(param1:String) : Champion;
      
      function findGameItemDefinitionbyId(param1:Number) : GameItem;
      
      function processAccountBalanceNotification(param1:StoreAccountBalanceNotification) : void;
      
      function loadUserInventory() : void;
      
      function updateChampionsRoster(param1:ArrayCollection, param2:ArrayCollection, param3:ArrayCollection, param4:Number) : void;
      
      function setBalanceFromLoginPacket(param1:Number, param2:Number) : void;
      
      function getChampionById(param1:int) : Champion;
      
      function checkDisabledSkins() : void;
      
      function getAvailableChampionCount(param1:Boolean) : int;
      
      function updateSpellDictionary(param1:Dictionary) : void;
      
      function processStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void;
      
      function populateSecondarySearchTags(param1:Array) : void;
      
      function get inventory() : IInventory;
      
      function createChampionFilter(param1:Array) : IChampionFilter;
      
      function getSpellById(param1:int) : Spell;
      
      function processRawFulfillment(param1:Object) : void;
      
      function processRentalUpdateNotification(param1:RentalUpdateNotification) : void;
      
      function hasAnyRentalItems() : Boolean;
      
      function populateSearchTags(param1:Array) : void;
      
      function getSkinById(param1:Number, param2:Champion) : ChampionSkin;
      
      function getActiveSpells() : ArrayCollection;
      
      function isSpellDisabledForMode(param1:int, param2:String) : Boolean;
      
      function updateChampionSkins(param1:ArrayCollection) : void;
      
      function findChampionById(param1:Number) : Champion;
      
      function refreshChampionsRoster(param1:Number) : void;
      
      function createSearchTags() : Array;
      
      function getRuneCount(param1:int) : uint;
   }
}

