package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ChampionDelegate
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var inventory:Inventory;
      
      public function ChampionDelegate(param1:Inventory)
      {
         super();
         this.inventory = param1;
      }
      
      public function setChampionActiveState(param1:Champion, param2:Boolean) : void
      {
         param1.active = param2;
      }
      
      public function createChampionRegistry(param1:ArrayCollection) : void
      {
         var _loc4_:Champion = null;
         this.inventory.championIdMapping = new Array();
         this.inventory.championSkinIdMapping = new Object();
         this.inventory.skinSkinIdMapping = new Object();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc4_.championData = this.inventory.championDataDictionary[_loc4_.championId];
            if(_loc4_.championData != null)
            {
               this.setupChampion(_loc4_,_loc2_);
               _loc3_.push(_loc4_);
            }
         }
         this.inventory.championRegistry = _loc2_;
         this.inventory.champions.source = _loc3_;
         this.inventory.champions.refresh();
         this.inventory.isChampionsLoaded = true;
      }
      
      public function createSkinMap(param1:Champion) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.championData.skinInfo)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ > 0)
            {
               this.inventory.championSkinIdMapping[_loc3_] = param1;
            }
         }
      }
      
      public function setChampionFreeToPlay(param1:int) : void
      {
         var _loc2_:Champion = this.inventory.championIdMapping[param1] as Champion;
         if(_loc2_)
         {
            _loc2_.freeToPlay = true;
         }
      }
      
      public function resetChampionActiveStates() : void
      {
         var _loc1_:Champion = null;
         for each(_loc1_ in this.inventory.championRegistry)
         {
            this.setChampionActiveState(_loc1_,true);
         }
      }
      
      public function hasAnyRentalItems(param1:Array) : Boolean
      {
         var _loc2_:Champion = null;
         for each(_loc2_ in param1)
         {
            if(this.isRentalChampion(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isRentalSkin(param1:ChampionSkin) : Boolean
      {
         if(Boolean(param1.isRented()) || Boolean(param1.isExpired()))
         {
            return true;
         }
         return false;
      }
      
      public function updateUnobtainableChampionSkins(param1:ArrayCollection) : void
      {
         var _loc2_:ChampionSkin = null;
         var _loc3_:Champion = null;
         var _loc4_:int = 0;
         var _loc5_:ChampionSkin = null;
         var _loc6_:int = 0;
         for each(_loc5_ in this.inventory.skinSkinIdMapping)
         {
            _loc5_.stillObtainable = true;
         }
         for each(_loc6_ in param1)
         {
            _loc4_ = Math.floor(_loc6_ / 1000) as int;
            _loc3_ = InventoryUtils.findChampionById(_loc4_,this.inventory.championRegistry);
            if(_loc3_)
            {
               _loc2_ = _loc3_.getChampionSkin(_loc6_);
               if(_loc2_)
               {
                  _loc2_.stillObtainable = false;
               }
            }
         }
         this.inventory.unobtainableChampionSkinIDList = param1;
      }
      
      public function setFreeToPlayChampions(param1:Number) : void
      {
         var _loc2_:int = 0;
         for each(_loc2_ in this.inventory.getFreeToPlayChampionIdsForLevel(param1))
         {
            this.setChampionFreeToPlay(_loc2_);
         }
      }
      
      public function getAvailableChampionCount(param1:Array, param2:Boolean = true) : int
      {
         var _loc4_:Champion = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            if(param2 && (Boolean(_loc4_.freeToPlay) || Boolean(_loc4_.freeToPlayReward)) || Boolean(_loc4_.owned))
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      public function setupChampion(param1:Champion, param2:Array) : void
      {
         param1.displayName = RiotResourceLoader.getChampionResourceString("name",param1.skinName,"**" + param1.skinName);
         param1.description = RiotResourceLoader.getChampionResourceString("desc",param1.skinName,"**" + param1.skinName);
         param2[param1.skinName] = param1;
         this.inventory.championIdMapping[param1.championId] = param1;
         this.createSkinMap(param1);
         this.createSkinMapForChampion(param1);
      }
      
      public function createSkinMapForChampion(param1:Champion) : void
      {
         var _loc2_:ChampionSkin = null;
         for each(_loc2_ in param1.championSkins)
         {
            this.inventory.skinSkinIdMapping[_loc2_.skinId] = _loc2_;
         }
      }
      
      public function isRentalChampion(param1:Champion) : Boolean
      {
         if(Boolean(param1.isRented()) || Boolean(param1.isExpired()) || this.hasRentalSkins(param1))
         {
            return true;
         }
         return false;
      }
      
      public function hasRentalSkins(param1:Champion) : Boolean
      {
         var _loc2_:ChampionSkin = null;
         for each(_loc2_ in param1.championSkins)
         {
            if(this.isRentalSkin(_loc2_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function resetChampions() : void
      {
         var _loc1_:Champion = null;
         for each(_loc1_ in this.inventory.championRegistry)
         {
            this.resetChampion(_loc1_);
         }
      }
      
      public function setInactiveChampions() : void
      {
         var _loc1_:String = null;
         var _loc2_:Champion = null;
         for each(_loc1_ in this.inventory.inactiveChampionIdList)
         {
            _loc2_ = this.inventory.championIdMapping[_loc1_] as Champion;
            if(_loc2_)
            {
               this.setChampionActiveState(_loc2_,false);
            }
         }
      }
      
      public function resetChampion(param1:Champion) : void
      {
         param1.freeToPlay = Boolean(param1.isRandomChampion()) || Boolean(param1.isWildCardChampion());
      }
   }
}

