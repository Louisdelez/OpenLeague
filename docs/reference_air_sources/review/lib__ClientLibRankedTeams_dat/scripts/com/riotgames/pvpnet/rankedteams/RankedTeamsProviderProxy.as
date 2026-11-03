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
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObject;
   import org.igniterealtime.xiff.data.Message;
   
   public class RankedTeamsProviderProxy extends ProviderProxyBase implements IRankedTeamsProvider
   {
      
      private static var _instance:RankedTeamsProviderProxy;
      
      public function RankedTeamsProviderProxy()
      {
         super(IRankedTeamsProvider);
      }
      
      public static function get instance() : RankedTeamsProviderProxy
      {
         if(_instance == null)
         {
            _instance = new RankedTeamsProviderProxy();
         }
         return _instance;
      }
      
      public function isRankedTeamServiceEnabled() : Boolean
      {
         return _invoke("isRankedTeamServiceEnabled");
      }
      
      public function getRankedTeamsTabButton() : DisplayObject
      {
         return null;
      }
      
      public function getCreateRankedTeamButton() : DisplayObject
      {
         return null;
      }
      
      public function showCreateTeamModal() : void
      {
         _invoke("showCreateTeamModal");
      }
      
      public function getRankedTeamsTabView() : DisplayObject
      {
         return null;
      }
      
      public function getRankedTeamsStatsView(param1:Signal = null) : DisplayObject
      {
         return null;
      }
      
      public function getRankedTeams() : Array
      {
         return _invoke("getRankedTeams",[]);
      }
      
      public function addListener(param1:String, param2:Function) : void
      {
         _invoke("addListener",[param1,param2]);
      }
      
      public function removeListener(param1:String, param2:Function) : void
      {
         _invoke("removeListener",[param1,param2]);
      }
      
      public function updateTeamStatsView(param1:TeamId, param2:Function = null, param3:Function = null) : void
      {
         _invoke("updateTeamStatsView",[param1,param2,param3]);
      }
      
      public function gotoTeamProfile(param1:TeamId, param2:Boolean = false) : void
      {
         _invoke("gotoTeamProfile",[param1,param2]);
      }
      
      public function setActiveRankedTeam(param1:TeamId) : void
      {
         _invoke("setActiveRankedTeam",[param1]);
      }
      
      public function setViewableSummoner(param1:Summoner, param2:SummonerLevel) : void
      {
         _invoke("setViewableSummoner",[param1,param2]);
      }
      
      public function retrieveHighest3v3TeamData(param1:int) : RankedDisplayBucketDTO
      {
         return _invoke("retrieveHighest3v3TeamData",[param1]);
      }
      
      public function retrieveHighest5v5TeamData(param1:int) : RankedDisplayBucketDTO
      {
         return _invoke("retrieveHighest5v5TeamData",[param1]);
      }
      
      public function setExternalChatAndProfileManagers(param1:IChatRoomProvider, param2:IChatRosterProvider, param3:ProfileDisplayModel) : void
      {
         _invoke("setExternalChatAndProfileManagers",[param1,param2,param3]);
      }
      
      public function handleP2PMessage(param1:Message) : void
      {
         _invoke("handleP2PMessage",[param1]);
      }
      
      public function processNotifications(param1:Player) : void
      {
         _invoke("processNotifications",[param1]);
      }
   }
}

