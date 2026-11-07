package com.riotgames.platform.gameclient.domain.rankedTeams
{
   public class TeamStatus
   {
      
      public static const RECRUITING:String = "RECRUITING";
      
      public static const PROVISIONAL:String = "PROVISIONAL";
      
      public static const PRSRVD_PROVISIONAL:String = "PRSRVD_PROVISIONAL";
      
      public static const RANKED:String = "RANKED";
      
      public static const INELIGIBLE:String = "INELIGIBLE";
      
      public function TeamStatus()
      {
         super();
      }
      
      public static function isTeamProvisional(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 == PROVISIONAL || param1 == PRSRVD_PROVISIONAL)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

