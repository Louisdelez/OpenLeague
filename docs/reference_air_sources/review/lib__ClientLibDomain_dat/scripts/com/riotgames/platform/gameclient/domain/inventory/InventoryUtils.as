package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class InventoryUtils
   {
      
      public function InventoryUtils()
      {
         super();
      }
      
      public static function makeHydratedRune(param1:int, param2:Dictionary) : Rune
      {
         var _loc4_:Object = null;
         var _loc5_:ItemEffect = null;
         var _loc3_:Rune = new Rune();
         _loc3_.itemId = param1;
         _loc3_.name = param2[param1].name;
         _loc3_.description = param2[param1].description;
         _loc3_.runeType = param2[param1].runeType;
         _loc3_.imagePath = param2[param1].imagePath;
         _loc3_.tier = param2[param1].tier;
         _loc3_.itemEffects = new ArrayCollection();
         for each(_loc4_ in param2[param1].itemEffects)
         {
            _loc5_ = new ItemEffect();
            _loc5_.name = _loc4_.name;
            _loc5_.displayName = _loc5_.name;
            _loc5_.value = _loc4_.value;
            _loc5_.effectCategory = _loc4_.categoryId;
            _loc5_.effectType = _loc4_.runeType;
            _loc3_.itemEffects.addItem(_loc5_);
         }
         return _loc3_;
      }
      
      public static function findChampionById(param1:Number, param2:Array) : Champion
      {
         var _loc3_:Champion = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.championId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function hydrateRuneData(param1:SummonerRune, param2:Dictionary) : void
      {
         if(param1.rune == null || param1.rune.imagePath == null)
         {
            param1.rune = makeHydratedRune(param1.runeId,param2);
         }
      }
   }
}

