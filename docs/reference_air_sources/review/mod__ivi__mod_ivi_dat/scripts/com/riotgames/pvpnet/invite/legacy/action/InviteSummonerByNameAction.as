package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import com.riotgames.pvpnet.invite.validator.SendInviteValidator;
   import mx.utils.StringUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InviteSummonerByNameAction extends BasicAction
   {
      
      private var _gameQueueConfig:GameQueueConfig;
      
      public var inviteType:String;
      
      private var _summonerService:SummonerService;
      
      private var _inviteBayController:IChatRosterProvider;
      
      public var successfullyInvitedPlayerRosterItem:RosterItemVO;
      
      private var _invitedSummonerName:String;
      
      private var _currentSummonerName:String;
      
      public var payload:String;
      
      public function InviteSummonerByNameAction(param1:String, param2:String, param3:IChatRosterProvider, param4:SummonerService, param5:String, param6:GameQueueConfig, param7:String = null)
      {
         super(false);
         this._invitedSummonerName = param1;
         this._currentSummonerName = param2;
         this._inviteBayController = param3;
         this._gameQueueConfig = param6;
         this.inviteType = param5;
         this.payload = param7;
         this._summonerService = param4;
      }
      
      public function invitePlayerBySummonerName(param1:String) : void
      {
         param1 = StringUtil.trim(param1);
         var _loc2_:IAction = new GetPublicSummonerByNameAction(param1,this._summonerService);
         _loc2_.getCompleted().addOnce(this.onInviteGetSummonerByNameSuccess);
         _loc2_.invoke();
      }
      
      private function onInviteGetSummonerByNameSuccess(param1:String, param2:PublicSummoner) : void
      {
         param1 = this.sanitizeSummonerName(param1);
         if(param2 == null || param2.internalName == null)
         {
            this.onInvitePlayerError(MessageDictionary.PLAYER_NOT_FOUND,[param1]);
            return;
         }
         if(param2.name.length == 0 || param2.name == this._currentSummonerName)
         {
            return;
         }
         var _loc3_:SendInviteValidator = new SendInviteValidator();
         if(!_loc3_.publicSummonerMeetsLevelRequirement(param2,this._gameQueueConfig))
         {
            this.onInvitePlayerError("invite_error_requirements",[param1]);
            return;
         }
         var _loc4_:RosterItemVO = this.getRosterItemFromPublicSummoner(param2);
         if(!this._inviteBayController.isSummonerBuddy(_loc4_.displayName))
         {
            _loc4_.displayName = param2.name;
         }
         else if(_loc4_.show == Presence.SHOW_DND)
         {
            this.onInvitePlayerError(MessageDictionary.PLAYER_NOT_AVAILABLE,[param1]);
            return;
         }
         this.successfullyInvitedPlayerRosterItem = _loc4_;
         complete();
      }
      
      private function sanitizeSummonerName(param1:String) : String
      {
         var _loc2_:RegExp = /</g;
         var _loc3_:RegExp = />/g;
         return param1.replace(_loc2_,"&lt;").replace(_loc3_,"&gt;");
      }
      
      public function getSuccessfullyInvitedPlayerRosterItem() : RosterItemVO
      {
         return this.successfullyInvitedPlayerRosterItem;
      }
      
      private function getRosterItemFromPublicSummoner(param1:PublicSummoner) : RosterItemVO
      {
         var _loc2_:UnescapedJID = new UnescapedJID(ChatController.jidFromSummonerId(param1.summonerId));
         return RosterItemVO.get(_loc2_,true);
      }
      
      override protected function doInvocation() : void
      {
         if(this._invitedSummonerName.length == 0 || Boolean(this._currentSummonerName) && Boolean(this._invitedSummonerName.toLowerCase() == this._currentSummonerName.toLowerCase()))
         {
            this.onInvitePlayerError(MessageDictionary.PLAYER_NOT_AVAILABLE,[this._invitedSummonerName]);
            return;
         }
         this.invitePlayerBySummonerName(this._invitedSummonerName);
      }
      
      private function onInvitePlayerError(param1:String, param2:Array) : void
      {
         var _loc3_:IAction = new DisplayInviteErrorAlertAction(param1,param2);
         _loc3_.getErred().addOnce(err);
         _loc3_.invoke();
      }
   }
}

