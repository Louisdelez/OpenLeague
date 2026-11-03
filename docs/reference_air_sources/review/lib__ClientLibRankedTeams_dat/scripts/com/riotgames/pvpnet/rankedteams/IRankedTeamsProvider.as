package com.riotgames.pvpnet.rankedteams
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.RankedDisplayBucketDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObject;
   import org.igniterealtime.xiff.data.Message;
   
   public interface IRankedTeamsProvider extends IProvider
   {
      
      function isRankedTeamServiceEnabled() : Boolean;
      
      function getRankedTeamsTabButton() : DisplayObject;
      
      function getCreateRankedTeamButton() : DisplayObject;
      
      function showCreateTeamModal() : void;
      
      function getRankedTeamsTabView() : DisplayObject;
      
      function getRankedTeamsStatsView(param1:Signal = null) : DisplayObject;
      
      function getRankedTeams() : Array;
      
      function addListener(param1:String, param2:Function) : void;
      
      function removeListener(param1:String, param2:Function) : void;
      
      function updateTeamStatsView(param1:TeamId, param2:Function = null, param3:Function = null) : void;
      
      function gotoTeamProfile(param1:TeamId, param2:Boolean = false) : void;
      
      function setActiveRankedTeam(param1:TeamId) : void;
      
      function setViewableSummoner(param1:Summoner, param2:SummonerLevel) : void;
      
      function retrieveHighest3v3TeamData(param1:int) : RankedDisplayBucketDTO;
      
      function retrieveHighest5v5TeamData(param1:int) : RankedDisplayBucketDTO;
      
      function setExternalChatAndProfileManagers(param1:IChatRoomProvider, param2:IChatRosterProvider, param3:ProfileDisplayModel) : void;
      
      function handleP2PMessage(param1:Message) : void;
      
      function processNotifications(param1:Player) : void;
   }
}

