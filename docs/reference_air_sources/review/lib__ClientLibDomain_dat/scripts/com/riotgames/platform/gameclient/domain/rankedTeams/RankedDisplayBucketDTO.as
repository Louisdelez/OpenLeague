package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   
   public class RankedDisplayBucketDTO
   {
      
      public var isPersonallyQualified:Boolean;
      
      public var teamName:String;
      
      public var losses:int;
      
      public var onlyDisplayQueueType:Boolean;
      
      public var wins:int;
      
      public var leaves:int;
      
      public var demotionWarningLevel:int = 0;
      
      public var queueType:String;
      
      public var league:LeagueListDTO;
      
      public var leaguePoints:Number;
      
      public var numGamesNeededForQualification:int;
      
      public var isLeague:Boolean = false;
      
      public function RankedDisplayBucketDTO()
      {
         super();
      }
   }
}

