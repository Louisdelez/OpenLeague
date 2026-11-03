package com.riotgames.pvpnet.contextualeducation
{
   import blix.assets.proxy.SpriteProxy;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IContextualEducationProvider extends IProvider
   {
      
      function getContextualEducationDisplay() : SpriteProxy;
      
      function prepareTip(param1:PlayerParticipantStatsSummary, param2:Boolean, param3:EndOfGameStats) : Boolean;
   }
}

