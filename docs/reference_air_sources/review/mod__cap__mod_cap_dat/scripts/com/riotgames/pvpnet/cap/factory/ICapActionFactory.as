package com.riotgames.pvpnet.cap.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public interface ICapActionFactory
   {
      
      function getRetrieveEstimatedWaitTimeAction(param1:Champion, param2:CapRole, param3:CapPosition, param4:int) : IAction;
      
      function getCreateGroupAction(param1:int) : IAction;
      
      function getRevealNextAvailableSlotAction() : IAction;
      
      function getSelectMasteryPageAction(param1:MasteryPageInfoSummary) : IAction;
      
      function getTrackDemandBoardMetricsAction() : IAction;
      
      function getSearchForAnotherGroupServiceCall() : IAction;
      
      function getAcceptCandidateServiceCall(param1:Number) : IAction;
      
      function getConfirmQuitAction(param1:Boolean) : IAction;
      
      function getDeclineCandidateServiceCall(param1:Number) : IAction;
      
      function getSelectRunePageAction(param1:SpellBookPageDTO) : IAction;
      
      function getHideViewAction() : IAction;
      
      function getJoinGroupAction() : IAction;
      
      function getConfigureMasterGameControllerAction() : IAction;
      
      function getRetrievePlayerInfoAction(param1:int) : IAction;
      
      function getSearchForCandidatesAction() : IAction;
      
      function getKickPlayerAction(param1:CapPlayerSelection) : IAction;
      
      function getQuitAction() : IAction;
      
      function getInviteAction() : IAction;
      
      function getSelectAdvertisedPositionAction(param1:CapPosition, param2:int = -1) : IAction;
      
      function getSelectRoleAction(param1:CapRole, param2:int = -1) : IAction;
      
      function getSelectPositionAction(param1:CapPosition, param2:int = -1) : IAction;
      
      function getIndicateGroupDeclineAsCandidateAction() : IAction;
      
      function getDockedPromptAction(param1:Boolean, param2:String, param3:String, param4:String, param5:String, param6:String = null, param7:String = null, param8:Function = null, param9:Object = null, param10:Boolean = true, param11:int = -1) : IAction;
      
      function getStatusMessageAction(param1:String) : IAction;
      
      function getSelectSkinAction(param1:ChampionSkin) : IAction;
      
      function getSelectChampionAction(param1:Champion) : IAction;
      
      function getSelectAdvertisedRoleAction(param1:CapRole, param2:int = -1) : IAction;
      
      function getCreateSoloQueryAction(param1:int) : IAction;
      
      function getIndicateGroupAcceptAsCandidateAction() : IAction;
      
      function getSpecSolosServiceCall() : IAction;
      
      function getRetrieveFeatureTogglesAction() : IAction;
      
      function getSelectSpellsAction(param1:Spell, param2:Spell) : IAction;
      
      function getTrackEnhancedPlayAgainMetricsAction(param1:Boolean, param2:Boolean, param3:String, param4:Array, param5:InviteGroup) : IAction;
      
      function getStartMatchmakingAction() : IAction;
      
      function getIndicateReadinessAction(param1:Boolean) : IAction;
   }
}

