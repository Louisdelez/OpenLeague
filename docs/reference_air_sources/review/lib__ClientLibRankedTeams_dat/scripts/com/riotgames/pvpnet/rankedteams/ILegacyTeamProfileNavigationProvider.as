package com.riotgames.pvpnet.rankedteams
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILegacyTeamProfileNavigationProvider extends IProvider
   {
      
      function goToTeam(param1:TeamId) : void;
   }
}

