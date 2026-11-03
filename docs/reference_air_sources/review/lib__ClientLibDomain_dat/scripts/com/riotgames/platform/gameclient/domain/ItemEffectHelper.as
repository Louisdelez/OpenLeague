package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import mx.formatters.NumberFormatter;
   
   public class ItemEffectHelper
   {
      
      public static const FLAT_MOD:uint = 0;
      
      public static const PERCENT_MOD:uint = 1;
      
      public static const maxLevel:uint = 18;
      
      public static const per5Multiplier:Number = 5;
      
      public static const perMinuteMultiplier:uint = 60;
      
      private static var formatter:NumberFormatter = null;
      
      public function ItemEffectHelper()
      {
         super();
      }
      
      public static function getValueFormattingForItemEffect(param1:ItemEffect) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:Object = ItemEffectHelper.getItemEffectFormatInfo(param1);
         return getValueFormatting(param1.value,_loc2_["effectType"],_loc2_["multiplier"]);
      }
      
      public static function getValueFormatting(param1:Number, param2:uint, param3:Number) : String
      {
         var _loc4_:String = "";
         if(formatter == null)
         {
            formatter = new NumberFormatter();
            formatter.rounding = "nearest";
            formatter.useNegativeSign = true;
            formatter.decimalSeparatorFrom = RiotResourceLoader.getString("decimal_seperator",".");
            formatter.thousandsSeparatorFrom = RiotResourceLoader.getString("thousands_seperator",",");
            formatter.decimalSeparatorTo = RiotResourceLoader.getString("decimal_seperator",".");
            formatter.thousandsSeparatorTo = RiotResourceLoader.getString("thousands_seperator",",");
         }
         var _loc5_:Number = param1 * param3;
         if(param2 == ItemEffectHelper.PERCENT_MOD)
         {
            _loc5_ *= 100;
         }
         if(_loc5_ < 1)
         {
            formatter.precision = 2;
         }
         else if(_loc5_ < 10)
         {
            formatter.precision = 1;
         }
         else
         {
            formatter.precision = 0;
         }
         _loc4_ = formatter.format(_loc5_);
         if(param2 == ItemEffectHelper.PERCENT_MOD)
         {
            _loc4_ += "%";
         }
         return _loc4_;
      }
      
      public static function getItemEffectFormatInfo(param1:ItemEffect) : Object
      {
         var _loc2_:uint = ItemEffectHelper.FLAT_MOD;
         var _loc3_:Number = 1;
         switch(param1.name)
         {
            case "FlatHPPoolMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatHPModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatMPPoolMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatMPModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "PercentHPPoolMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "PercentMPPoolMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "FlatHPRegenMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = per5Multiplier;
               break;
            case "rFlatHPRegenModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel * per5Multiplier;
               break;
            case "FlatMPRegenMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = per5Multiplier;
               break;
            case "rFlatMPRegenModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = per5Multiplier * maxLevel;
               break;
            case "FlatArmorMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatArmorModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "rFlatArmorPenetrationMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatArmorPenetrationModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatPhysicalDamageMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatPhysicalDamageModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatMagicDamageMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatMagicDamageModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "rFlatMovementSpeedModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "PercentMovementSpeedMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rPercentMovementSpeedModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "PercentAttackSpeedMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rPercentAttackSpeedModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "rFlatDodgeMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatDodgeModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "PercentDodgeMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "FlatCritChanceMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatCritChanceModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatCritDamageMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatCritDamageModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatSpellBlockMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatSpellBlockModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatEXPBonus":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rPercentCooldownMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rPercentCooldownModPerLevel":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = maxLevel;
               break;
            case "rFlatTimeDeadMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatGoldPer10Mod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatMagicPenetrationMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatMagicPenetrationModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "PercentEXPBonus":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "rPercentTimeDeadMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = -1;
               break;
            case "FlatEnergyPoolMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = 1;
               break;
            case "rFlatEnergyModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = maxLevel;
               break;
            case "FlatEnergyRegenMod":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = per5Multiplier;
               break;
            case "rFlatEnergyRegenModPerLevel":
               _loc2_ = ItemEffectHelper.FLAT_MOD;
               _loc3_ = per5Multiplier * maxLevel;
               break;
            case "PercentLifeStealMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
               break;
            case "PercentSpellVampMod":
               _loc2_ = ItemEffectHelper.PERCENT_MOD;
               _loc3_ = 1;
         }
         return {
            "effectType":_loc2_,
            "multiplier":_loc3_
         };
      }
   }
}

