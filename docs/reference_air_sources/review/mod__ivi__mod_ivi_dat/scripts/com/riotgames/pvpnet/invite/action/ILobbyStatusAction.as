package com.riotgames.pvpnet.invite.action
{
   import blix.action.IAction;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   
   public interface ILobbyStatusAction extends IAction
   {
      
      function getLobbyStatus() : LobbyStatus;
   }
}

