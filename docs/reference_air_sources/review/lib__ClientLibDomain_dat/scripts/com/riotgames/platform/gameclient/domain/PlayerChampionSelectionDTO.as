package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.game.PlayerChampionSelectionDTO")]
   public class PlayerChampionSelectionDTO extends AbstractDomainObject
   {
      
      public var spell1Id:Number;
      
      public var championId:int;
      
      public var spell2Id:Number;
      
      public var summonerInternalName:String;
      
      public var selectedSkinIndex:int;
      
      public function PlayerChampionSelectionDTO()
      {
         super();
      }
   }
}

