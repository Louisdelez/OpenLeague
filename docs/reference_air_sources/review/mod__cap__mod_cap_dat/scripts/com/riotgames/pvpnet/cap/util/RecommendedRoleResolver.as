package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.model.CapRole;
   
   public class RecommendedRoleResolver
   {
      
      public static const NOT_RECOMMENDED:uint = 0;
      
      public static const RECOMMENDED_PRIMARY:uint = 1;
      
      public static const RECOMMENDED_SECONDARY:uint = 2;
      
      public static const PRIMARY_INDEX:uint = 0;
      
      public static const SECONDARY_INDEX:uint = 1;
      
      public function RecommendedRoleResolver()
      {
         super();
      }
      
      private function getSecondarySearchTag(param1:Array) : String
      {
         var _loc2_:String = param1[SECONDARY_INDEX];
         return _loc2_.toLowerCase();
      }
      
      private function getPrimarySearchTag(param1:Array) : String
      {
         var _loc2_:String = param1[PRIMARY_INDEX];
         return _loc2_.toLowerCase();
      }
      
      public function getRecommendation(param1:Champion, param2:CapRole) : uint
      {
         if(!param1 || !param2)
         {
            return NOT_RECOMMENDED;
         }
         if(!param1.searchTags || !param2.championSearchTag)
         {
            return NOT_RECOMMENDED;
         }
         var _loc3_:Array = param1.searchTags;
         var _loc4_:String = param2.championSearchTag.toLowerCase();
         if(Boolean(_loc3_[PRIMARY_INDEX]) && this.getPrimarySearchTag(_loc3_) == _loc4_)
         {
            return RECOMMENDED_PRIMARY;
         }
         if(Boolean(_loc3_[SECONDARY_INDEX]) && this.getSecondarySearchTag(_loc3_) == _loc4_)
         {
            return RECOMMENDED_SECONDARY;
         }
         return NOT_RECOMMENDED;
      }
   }
}

