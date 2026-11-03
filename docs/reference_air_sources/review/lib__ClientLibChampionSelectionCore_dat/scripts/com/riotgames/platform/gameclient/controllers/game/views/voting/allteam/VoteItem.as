package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionWildCardEnums;
   
   public class VoteItem
   {
      
      public var allVotingComplete:Boolean;
      
      public var champion:Champion;
      
      public var locked:Boolean;
      
      public var size:int = 1;
      
      public var mine:Boolean;
      
      public var chance:Number;
      
      public var winnerDecided:Boolean;
      
      public var winner:Boolean;
      
      public function VoteItem()
      {
         super();
      }
      
      public function get abstain() : Boolean
      {
         return this.champion.championId == ChampionWildCardEnums.ID_ABSTAIN_CHAMPION;
      }
      
      public function get championId() : int
      {
         return this.champion.championId;
      }
      
      public function toString() : String
      {
         return "Champion: " + this.champion.championId + ", locked: " + this.locked + ", size/chance: " + this.size + "/" + this.chance + ", mine: " + this.mine;
      }
   }
}

