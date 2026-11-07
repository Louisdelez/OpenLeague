package com.riotgames.pvpnet.runes.viewcontroller
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.RuneCategories;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   
   public class RuneFilter
   {
      
      private var _changed:Signal = new Signal();
      
      private var _exclusiveTierFilter:uint = 0;
      
      private var _tier1Shown:Boolean = true;
      
      private var _tier2Shown:Boolean = true;
      
      private var _tier3Shown:Boolean = true;
      
      private var _runeCategory:int = RuneCategories.RUNE_CATEGORY_ALL;
      
      public function RuneFilter()
      {
         super();
      }
      
      public function getChanged() : ISignal
      {
         return this._changed;
      }
      
      public function filter(param1:SummonerRune, param2:int, param3:Array) : Boolean
      {
         var _loc4_:Boolean = true;
         if(param1.rune == null)
         {
            return false;
         }
         _loc4_ &&= this.filterByRuneCategory(param1);
         if(this._exclusiveTierFilter == 0)
         {
            switch(param1.rune.tier)
            {
               case 1:
                  _loc4_ &&= this._tier1Shown;
                  break;
               case 2:
                  _loc4_ &&= this._tier2Shown;
                  break;
               case 3:
                  _loc4_ &&= this._tier3Shown;
            }
         }
         else
         {
            _loc4_ &&= param1.rune.tier == this._exclusiveTierFilter;
         }
         return _loc4_;
      }
      
      private function filterByRuneCategory(param1:SummonerRune) : Boolean
      {
         var _loc2_:ItemEffect = null;
         if(this._runeCategory == RuneCategories.RUNE_CATEGORY_ALL || param1.rune.itemEffects.length == 0)
         {
            return true;
         }
         for each(_loc2_ in param1.rune.itemEffects)
         {
            if(_loc2_)
            {
               if(_loc2_.effectCategory == this._runeCategory)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getRuneCategory() : int
      {
         return this._runeCategory;
      }
      
      public function setRuneCategory(param1:int) : void
      {
         this._runeCategory = param1;
         this._changed.dispatch(this);
      }
      
      public function getTier1Shown() : Boolean
      {
         return this._tier1Shown;
      }
      
      public function setTier1Shown(param1:Boolean) : void
      {
         this._tier1Shown = param1;
         this._changed.dispatch(this);
      }
      
      public function getTier2Shown() : Boolean
      {
         return this._tier2Shown;
      }
      
      public function setTier2Shown(param1:Boolean) : void
      {
         this._tier2Shown = param1;
         this._changed.dispatch(this);
      }
      
      public function getTier3Shown() : Boolean
      {
         return this._tier3Shown;
      }
      
      public function setTier3Shown(param1:Boolean) : void
      {
         this._tier3Shown = param1;
         this._changed.dispatch(this);
      }
      
      public function setExclusiveTier(param1:uint) : void
      {
         this._exclusiveTierFilter = param1;
         this._changed.dispatch(this);
      }
      
      public function getExclusiveTier() : uint
      {
         return this._exclusiveTierFilter;
      }
   }
}

