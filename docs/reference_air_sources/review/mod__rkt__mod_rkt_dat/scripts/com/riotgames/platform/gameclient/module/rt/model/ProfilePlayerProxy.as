package com.riotgames.platform.gameclient.module.rt.model
{
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class ProfilePlayerProxy extends Proxy
   {
      
      public static const NAME:String = "ProfilePlayerProxy";
      
      public static const FIND_PROFILE_PLAYER_SUCCESS:String = "FIND_PROFILE_PLAYER_SUCCESS";
      
      private var _player:Player;
      
      private var _isLocal:Boolean = true;
      
      public function ProfilePlayerProxy(param1:String = "ProfilePlayerProxy", param2:Object = null)
      {
         super(param1,param2);
      }
      
      private static function summonerAllowedRankedTeams(param1:Summoner, param2:SummonerLevel) : Boolean
      {
         return RTFacade.instance.rtProvider.clientConfig.teamServiceEnabled && param1 && Boolean(param2) && param2.summonerLevel >= Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS;
      }
      
      public static function unescapedJIDFromSummonerId(param1:Number) : UnescapedJID
      {
         var _loc2_:EscapedJID = new EscapedJID("sum" + param1.toString() + "@pvp.net");
         return _loc2_.unescaped;
      }
      
      public function get player() : Player
      {
         return this._player;
      }
      
      public function get memberTeams() : ArrayCollection
      {
         var _loc2_:TeamInfo = null;
         if(!this.playerTeams)
         {
            return null;
         }
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.playerTeams)
         {
            if(_loc2_.memberStatusString == TeamMemberStatus.MEMBER)
            {
               _loc1_.addItem(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get isLocal() : Boolean
      {
         return this._isLocal;
      }
      
      public function set player(param1:Player) : void
      {
         var _loc2_:Boolean = true;
         if(this._player == null && param1 == null)
         {
            _loc2_ = false;
         }
         else if(this._player != null && param1 != null && this._player.playerId == param1.playerId)
         {
            _loc2_ = false;
         }
         this._player = param1;
         facade.sendNotification(FIND_PROFILE_PLAYER_SUCCESS,_loc2_);
      }
      
      public function get invitedTeams() : ArrayCollection
      {
         var _loc2_:TeamInfo = null;
         if(!this.playerTeams)
         {
            return null;
         }
         var _loc1_:ArrayCollection = new ArrayCollection();
         if(this.isLocal)
         {
            for each(_loc2_ in this.playerTeams)
            {
               if(_loc2_.memberStatusString == TeamMemberStatus.INVITED)
               {
                  _loc1_.addItem(_loc2_);
               }
            }
         }
         return _loc1_;
      }
      
      public function get createdTeams() : ArrayCollection
      {
         return this.player ? this.player.createdTeams : null;
      }
      
      public function setSummoner(param1:Summoner, param2:SummonerLevel) : void
      {
         this.player = null;
         RTFacade.profileTeamProxy.team = null;
         if(summonerAllowedRankedTeams(param1,param2))
         {
            if(param1 != null && RTFacade.playerProxy.localPlayer() != null && param1.sumId == RTFacade.playerProxy.localPlayer().playerId)
            {
               this._isLocal = true;
               this.player = RTFacade.playerProxy.localPlayer();
               RTFacade.playerProxy.retrieveLocalPlayer();
            }
            else
            {
               this._isLocal = false;
               RTFacade.playerProxy.showPlayer(param1.sumId);
            }
         }
      }
      
      public function get kickedTeams() : ArrayCollection
      {
         var _loc2_:TeamInfo = null;
         if(!this.playerTeams)
         {
            return null;
         }
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.playerTeams)
         {
            if(_loc2_.memberStatusString == TeamMemberStatus.KICKED)
            {
               _loc1_.addItem(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get playerTeams() : ArrayCollection
      {
         return this.player ? this.player.playerTeams : null;
      }
      
      public function get id() : Number
      {
         return this.player.playerId;
      }
      
      public function get playerId() : Number
      {
         return RTFacade.instance.rtProvider.session.summoner.sumId;
      }
   }
}

