package com.riotgames.platform.gameclient.domain.game
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.game.FeaturedGameInfo")]
   public class FeaturedGameInfo
   {
      
      public var championVoteInfoList:ArrayCollection;
      
      public function FeaturedGameInfo()
      {
         super();
      }
   }
}

