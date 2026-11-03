package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import mx.utils.ObjectUtil;
   
   public class PlayerStatCategory
   {
      
      public static const SCORE_CATEGORY:String = "SCORE_CATEGORY";
      
      public static const OBJECTIVE_CATEGORY:String = "OBJECTIVE_CATEGORY";
      
      public static const COMBAT_CATEGORY:String = "COMBAT_CATEGORY";
      
      public static const DAMAGE_DONE_CATEGORY:String = "DAMAGE_DONE_CATEGORY";
      
      public static const DAMAGE_TAKEN_CATEGORY:String = "DAMAGE_TAKEN_CATEGORY";
      
      public static const MISC_CATEGORY:String = "MISC_CATEGORY";
      
      public static const CATEGORIES:Object = {
         "SCORE_CATEGORY":PlayerStatCategory.SCORE_CATEGORY,
         "OBJECTIVE_CATEGORY":PlayerStatCategory.OBJECTIVE_CATEGORY,
         "COMBAT_CATEGORY":PlayerStatCategory.COMBAT_CATEGORY,
         "DAMAGE_DONE_CATEGORY":PlayerStatCategory.DAMAGE_DONE_CATEGORY,
         "DAMAGE_TAKEN_CATEGORY":PlayerStatCategory.DAMAGE_TAKEN_CATEGORY,
         "MISC_CATEGORY":PlayerStatCategory.MISC_CATEGORY
      };
      
      public var name:String = "MISC_CATEGORY";
      
      private var _displayName:String;
      
      public function PlayerStatCategory(param1:String = "")
      {
         super();
         if(Boolean(param1) && param1 != "")
         {
            this.name = param1;
         }
         this._displayName = RiotResourceLoader.getStatResourceString(param1,"**" + param1);
      }
      
      public static function categoryCompareFunction(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStatCategory = param1 as PlayerStatCategory;
         var _loc5_:PlayerStatCategory = param2 as PlayerStatCategory;
         if(!_loc4_)
         {
            return -1;
         }
         if(!_loc5_)
         {
            return 1;
         }
         if(!_loc4_ && !_loc5_)
         {
            return 0;
         }
         return ObjectUtil.numericCompare(_loc4_.priority,_loc5_.priority);
      }
      
      public function get priority() : int
      {
         var _loc1_:int = 0;
         switch(this.name)
         {
            case SCORE_CATEGORY:
               _loc1_ = 0;
               break;
            case OBJECTIVE_CATEGORY:
               _loc1_ = 1;
               break;
            case COMBAT_CATEGORY:
               _loc1_ = 2;
               break;
            case DAMAGE_DONE_CATEGORY:
               _loc1_ = 3;
               break;
            case DAMAGE_TAKEN_CATEGORY:
               _loc1_ = 4;
               break;
            default:
               _loc1_ = int.MAX_VALUE;
         }
         return _loc1_;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
   }
}

