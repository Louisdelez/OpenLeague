package com.riotgames.platform.common.resource
{
   import com.riotgames.platform.gameclient.domain.RentableInventoryItem;
   import mx.resources.ResourceManager;
   
   public class RentedChampionStatusText
   {
      
      public function RentedChampionStatusText()
      {
         super();
      }
      
      public static function GetHTMLText(param1:Object) : String
      {
         var _loc6_:String = null;
         var _loc2_:RentableInventoryItem = param1 as RentableInventoryItem;
         var _loc3_:int = int(_loc2_.rentalDaysRemaining());
         var _loc4_:int = int(_loc2_.rentalHoursRemaining());
         var _loc5_:int = int(_loc2_.rentalMinutesRemaining());
         if(_loc2_.winCountRemaining > 0)
         {
            if(_loc2_.isRentalTimeRemaining() == true)
            {
               return ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_rentalBoth",[_loc3_,_loc2_.winCountRemaining]);
            }
            return ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_rentalWins",[_loc2_.winCountRemaining]);
         }
         if(_loc3_ == 0 && _loc4_ <= 6)
         {
            return ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_rentalTimeWithMinutes",[_loc4_,_loc5_]);
         }
         return ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_rentalTime",[_loc3_,_loc4_]);
      }
   }
}

