package com.riotgames.platform.gameclient.module.rt.model
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeaguesDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.controller.RTShowServiceError;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.platform.gameclient.services.TeamService;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import mx.rpc.events.ResultEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class TeamProxy extends Proxy
   {
      
      public static const NAME:String = "TeamProxy";
      
      public static const SHOW_TEAM_STARTED:String = "SHOW_TEAM_STARTED";
      
      public static const CREATE_TEAM_SUCCESS:String = "CREATE_TEAM_SUCCESS";
      
      public static const CREATE_TEAM_ERROR:String = "CREATE_TEAM_ERROR";
      
      public static const FIND_TEAM_SUCCESS:String = "FIND_TEAM_SUCCESS";
      
      public static const DOES_NAME_EXIST:String = "DOES_NAME_EXIST";
      
      public static const DOES_TAG_EXIST:String = "DOES_TAG_EXIST";
      
      public static const NAME_TAG_VALIDATION_ERROR:String = "NAME_TAG_VALIDATION_ERROR";
      
      private var _currentSearch:String;
      
      private var _isTeamPending:Boolean;
      
      private var _currentTeam:Team;
      
      private var _leagueDataLoaded:Boolean = false;
      
      public function TeamProxy(param1:String = "TeamProxy", param2:Object = null)
      {
         super(param1,param2);
      }
      
      private function get leagueService() : CLSServicePlatform
      {
         return RTFacade.instance.rtProvider.serviceProxy.leagueService;
      }
      
      public function get isTeamPending() : Boolean
      {
         return this._isTeamPending;
      }
      
      public function get teamStatsProxy() : TeamStatsProxy
      {
         return RTFacade.statsProxy;
      }
      
      private function onFindTeamSuccess(param1:ResultEvent) : void
      {
         this._isTeamPending = false;
         if(param1.result is Team)
         {
            this._currentTeam = Team(param1.result);
            if(ClientConfig.instance.leagueServiceEnabled)
            {
               this.leagueService.getLeaguesForTeam(this._currentTeam.teamId.fullId,this.onGetLeagues);
            }
            else
            {
               this.profileTeamProxy.team = this._currentTeam;
            }
         }
         else
         {
            facade.sendNotification(RTShowServiceError.SHOW_ERROR,{"errorCode":"TEAM_NOT_FOUND"});
         }
      }
      
      private function onDoesNameExist(param1:ResultEvent) : void
      {
         sendNotification(DOES_NAME_EXIST,param1);
      }
      
      private function onDoesTagExist(param1:ResultEvent) : void
      {
         sendNotification(DOES_TAG_EXIST,param1);
      }
      
      private function get teamService() : TeamService
      {
         return RTFacade.instance.rtProvider.serviceProxy.teamService;
      }
      
      public function isTagAvailable(param1:String) : void
      {
         this.teamService.isTagValidAndAvailable(param1,this.onDoesTagExist,this.onComplete,this.onNameTagValidationError);
      }
      
      private function onFindTeamByTagSuccess(param1:ResultEvent) : void
      {
         if(param1.result is Team)
         {
            this.onFindTeamSuccess(param1);
         }
         else
         {
            this.teamService.findTeamByName(this._currentSearch,this.onFindTeamByNameSuccess,this.onComplete,this.onError);
         }
      }
      
      public function showTeamByName(param1:String) : void
      {
         this._currentSearch = param1;
         this.serviceStateProxy.onServiceCall();
         this.teamService.findTeamByTag(param1,this.onFindTeamByTagSuccess,this.onComplete,this.onError);
      }
      
      public function get profileTeamProxy() : ProfileTeamProxy
      {
         return RTFacade.instance.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      private function onError(param1:Object) : void
      {
         facade.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
      }
      
      private function onCreateTeamSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         sendNotification(CREATE_TEAM_SUCCESS,_loc2_);
         RTFacade.playerProxy.retrieveLocalPlayer();
         if(_loc2_)
         {
            this.showTeamById(_loc2_.teamId,true);
            RTFacade.instance.rtProvider.soundManager.play(AudioKeys.RT_TEAM_ACCEPT_1);
         }
      }
      
      public function showTeamById(param1:TeamId, param2:Boolean, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(this.profileTeamProxy.team)
         {
            if(!param2 && this.profileTeamProxy.team.teamId.fullId == param1.fullId)
            {
               return;
            }
         }
         if(!param3)
         {
            RTFacade.instance.sendNotification(SHOW_TEAM_STARTED);
         }
         this._isTeamPending = true;
         this.profileTeamProxy.isDataOnly = param3;
         this.profileTeamProxy.isViewExternal = param4;
         this.teamService.findTeamById(param1,this.onFindTeamSuccess,this.onComplete,this.onError);
      }
      
      private function onGetLeagues(param1:ResultEvent) : void
      {
         var _loc3_:LeagueListDTO = null;
         var _loc2_:SummonerLeaguesDTO = param1.result as SummonerLeaguesDTO;
         this._leagueDataLoaded = true;
         for each(_loc3_ in _loc2_.summonerLeagues)
         {
            this.leagueService.cache.addLeague(_loc3_,true);
         }
         if(this._currentTeam)
         {
            this.profileTeamProxy.team = this._currentTeam;
         }
      }
      
      private function onCreateTeamError(param1:ServerError) : void
      {
         sendNotification(CREATE_TEAM_ERROR,param1);
      }
      
      private function get serviceStateProxy() : ServiceStateProxy
      {
         return RTFacade.instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public function isNameAvailable(param1:String) : void
      {
         this.teamService.isNameValidAndAvailable(param1,this.onDoesNameExist,this.onComplete,this.onNameTagValidationError);
      }
      
      private function onComplete(param1:Object) : void
      {
         this.serviceStateProxy.onServiceCallComplete();
      }
      
      public function createTeam(param1:String, param2:String) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.createTeam(param1,param2,this.onCreateTeamSuccess,this.onComplete,this.onCreateTeamError);
      }
      
      private function onFindTeamByNameSuccess(param1:ResultEvent) : void
      {
         if(param1.result is Team)
         {
            this.onFindTeamSuccess(param1);
         }
         else
         {
            facade.sendNotification(RTShowServiceError.SHOW_ERROR,{"errorCode":"TEAM_NOT_FOUND"});
         }
      }
      
      public function onTeamRosterChanged(param1:TeamId) : void
      {
         if(Boolean(this.profileTeamProxy.team) && Boolean(this.profileTeamProxy.team.teamId.Compare(param1)))
         {
            this.showTeamById(param1,true);
         }
      }
      
      private function onNameTagValidationError(param1:Object) : void
      {
         sendNotification(NAME_TAG_VALIDATION_ERROR,param1);
      }
   }
}

