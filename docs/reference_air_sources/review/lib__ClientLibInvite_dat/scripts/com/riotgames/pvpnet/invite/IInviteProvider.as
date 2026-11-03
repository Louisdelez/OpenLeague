package com.riotgames.pvpnet.invite
{
   import blix.action.IAction;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.queuerestriction.controller.IQueueRestrictionController;
   
   public interface IInviteProvider extends IProvider
   {
      
      function getInviteGroup() : InviteGroup;
      
      function getOpenInvitePanelAction() : IAction;
      
      function getRankedInviteController() : IInviteRankedTeamController;
      
      function getInviteController() : IInviteController;
      
      function getQueueRestrictionController() : IQueueRestrictionController;
   }
}

