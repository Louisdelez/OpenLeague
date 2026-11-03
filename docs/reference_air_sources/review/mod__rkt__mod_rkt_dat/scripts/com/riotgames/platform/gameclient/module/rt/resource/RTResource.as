package com.riotgames.platform.gameclient.module.rt.resource
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class RTResource
   {
      
      private static const RANKED_TEAMS_BUNDLE_ID:String = "rankedTeams";
      
      public function RTResource()
      {
         super();
      }
      
      public static function getString(param1:String, param2:Array = null) : String
      {
         var _loc3_:String = RiotResourceLoader.getResourceString(RANKED_TEAMS_BUNDLE_ID,param1,"**" + param1,param2);
         return _loc3_.split("\\n").join("\n");
      }
   }
}

