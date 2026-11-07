package com.riotgames.platform.gameclient.module.rt.view.history
{
   import blix.assets.proxy.OverviewHeader;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.Context;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import mx.collections.ArrayCollection;
   
   public class OverviewHeader extends StatefulView
   {
      
      private var timestampText:TextFieldProxy;
      
      private var gameLengthText:TextFieldProxy;
      
      private var mapText:TextFieldProxy;
      
      private var thisTeamName:TextFieldProxy;
      
      private var otherTeamScore:TextFieldProxy;
      
      private var thisTeamScore:TextFieldProxy;
      
      private var otherTeamName:TextFieldProxy;
      
      private var outcomeText:TextFieldProxy;
      
      public function OverviewHeader(param1:Context)
      {
         super(param1);
      }
      
      public function showStats(param1:EndOfGameStats, param2:MatchHistorySummary) : void
      {
         if(param2.win)
         {
            this.outcomeText.setText(RTResource.getString("mhOverviewVictory"));
         }
         else if(param2.invalid)
         {
            this.outcomeText.setText(RTResource.getString("mhOverviewInvalid"));
         }
         else
         {
            this.outcomeText.setText(RTResource.getString("mhOverviewDefeat"));
         }
         var _loc3_:Date = new Date();
         _loc3_.setTime(param2.date);
         this.timestampText.setText(DateUtil.getDateAndTimeString(_loc3_));
         this.gameLengthText.setText(DateUtil.secondsToTimeString(param1.gameLength));
         this.mapText.setText(RiotResourceLoader.getMapResourceString("displayname",param2.mapId,""));
         var _loc4_:TeamInfo = param1.myTeamInfo;
         var _loc5_:TeamInfo = param1.otherTeamInfo;
         this.thisTeamName.setText(_loc4_.tag);
         this.otherTeamName.setText(_loc5_.tag);
         this.thisTeamScore.setText(this.compileKDA(param1.teamPlayerParticipantStats));
         this.otherTeamScore.setText(this.compileKDA(param1.otherTeamPlayerParticipantStats));
      }
      
      private function compileKDA(param1:ArrayCollection) : String
      {
         var _loc5_:PlayerParticipantStatsSummary = null;
         var _loc6_:PlayerStat = null;
         var _loc7_:PlayerStat = null;
         var _loc8_:PlayerStat = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in param1)
         {
            _loc6_ = PlayerStat.findStat(RawStatType.CHAMPION_KILLS,_loc5_.statistics);
            _loc7_ = PlayerStat.findStat(RawStatType.DEATHS,_loc5_.statistics);
            _loc8_ = PlayerStat.findStat(RawStatType.ASSISTS,_loc5_.statistics);
            _loc2_ += _loc6_.value;
            _loc3_ += _loc7_.value;
            _loc4_ += _loc8_.value;
         }
         return RTResource.getString("mhKDA",[_loc2_,_loc3_,_loc4_]);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:blix.assets.proxy.OverviewHeader = new blix.assets.proxy.OverviewHeader();
         this.outcomeText = _loc1_.outcomeText.create(this);
         this.timestampText = _loc1_.ratingChangeText.create(this);
         this.mapText = _loc1_.mapText.create(this);
         this.gameLengthText = _loc1_.gameLengthText.create(this);
         this.thisTeamName = _loc1_.thisTeamName.create(this);
         this.otherTeamName = _loc1_.otherTeamName.create(this);
         this.thisTeamScore = _loc1_.thisTeamScore.create(this);
         this.otherTeamScore = _loc1_.otherTeamScore.create(this);
      }
   }
}

