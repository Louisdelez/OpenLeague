package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneCombiner;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.SlotEntry;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import mx.collections.ArrayCollection;
   
   public class RuneBookUtils
   {
      
      public static const PAGE_NAME_TOKEN:String = "@@!PaG3!@@";
      
      public function RuneBookUtils()
      {
         super();
      }
      
      public static function canAddToSlot(param1:Rune, param2:RuneSlot, param3:int) : Boolean
      {
         return param2.runeType.equals(param1.runeType) && param2.minLevel <= param3;
      }
      
      public static function localizeRunePage(param1:SpellBookPageDTO) : void
      {
         var _loc2_:SlotEntry = null;
         if(param1 == null || param1.getEntries() == null)
         {
            return;
         }
         for each(_loc2_ in param1.getEntries())
         {
            if(Boolean(_loc2_.getRune()))
            {
               localizeRune(_loc2_.getRune());
            }
         }
      }
      
      public static function localizeRune(param1:Rune) : void
      {
         var _loc2_:ItemEffect = null;
         if(param1 == null)
         {
            return;
         }
         param1.displayName = RiotResourceLoader.getItemResourceString("name",param1.itemId,param1.displayName);
         param1.displayDescription = RiotResourceLoader.getItemResourceString("description",param1.itemId,param1.displayDescription);
         for each(_loc2_ in param1.itemEffects)
         {
            _loc2_.displayName = RiotResourceLoader.getEffectResourceString("description",_loc2_.name,_loc2_.name);
         }
      }
      
      public static function removeRuneFromList(param1:ArrayCollection, param2:SummonerRune) : Boolean
      {
         var _loc5_:int = 0;
         var _loc3_:Function = param1.filterFunction;
         param1.filterFunction = null;
         param1.refresh();
         var _loc4_:SummonerRune = findSummonerRune(param1,param2);
         if(_loc4_ != null)
         {
            _loc5_ = int(param1.getItemIndex(_loc4_));
            if(_loc5_ > -1)
            {
               param1.removeItemAt(_loc5_);
               param1.filterFunction = _loc3_;
               param1.refresh();
               return true;
            }
         }
         param1.filterFunction = _loc3_;
         param1.refresh();
         return false;
      }
      
      public static function containsSummonerRune(param1:ArrayCollection, param2:SummonerRune) : Boolean
      {
         return findSummonerRune(param1,param2) != null;
      }
      
      public static function findSummonerRune(param1:ArrayCollection, param2:SummonerRune) : SummonerRune
      {
         var _loc3_:SummonerRune = null;
         if(param1 == null || param2 == null)
         {
            return null;
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_.runeId == param2.runeId)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function localizeSummonerRunes(param1:Array) : void
      {
         var _loc2_:SummonerRune = null;
         for each(_loc2_ in param1)
         {
            localizeRune(_loc2_.rune);
         }
      }
      
      public static function getRuneCombiner(param1:int, param2:ArrayCollection, param3:ArrayCollection) : int
      {
         var _loc4_:RuneCombiner = null;
         for each(_loc4_ in param3)
         {
            if(param1 == _loc4_.inputTier && param2.length == _loc4_.inputCount)
            {
               return _loc4_.id;
            }
         }
         return -1;
      }
      
      public static function localizeRuneBook(param1:SpellBookDTO) : void
      {
         var _loc3_:SpellBookPageDTO = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 1;
         for each(_loc3_ in param1.bookPages)
         {
            localizeRunePage(_loc3_);
            _loc2_++;
         }
      }
   }
}

