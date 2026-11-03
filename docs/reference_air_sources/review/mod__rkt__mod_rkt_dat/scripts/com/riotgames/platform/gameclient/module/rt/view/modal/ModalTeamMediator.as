package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.core.IFlexDisplayObject;
   import mx.managers.PopUpManager;
   import mx.resources.ResourceManager;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ModalTeamMediator extends Mediator
   {
      
      public static const NAME:String = "ModalTeamMediator";
      
      public function ModalTeamMediator(param1:String = "ModalTeamMediator", param2:Object = null)
      {
         super(param1,param2);
      }
      
      private function showPopup(param1:IFlexDisplayObject) : void
      {
         var _loc2_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(param1,_loc2_,true);
         PopUpManager.centerPopUp(param1);
      }
      
      public function showRemoveTeamMemberModal(param1:String, param2:Number, param3:TeamId) : void
      {
         var _loc4_:Object = {
            "summonerName":param1,
            "playerId":param2,
            "teamId":param3
         };
         var _loc5_:TwoButtonGenericModalData = new TwoButtonGenericModalData();
         _loc5_.title = RTResource.getString("manageRemoveTeamMemberTitle");
         _loc5_.message = RTResource.getString("manageRemoveTeamMember",[param1]);
         _loc5_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_cancel");
         _loc5_.rightButtonLabel = RTResource.getString("manageRemoveTeamMemberRight");
         _loc5_.rightButtonCallback = this.onShowRemoveTeamMemberModal;
         _loc5_.callbackProperty = _loc4_;
         this.showTwoButtonGenericModal(_loc5_);
      }
      
      private function onShowRemoveTeamMemberModal(param1:Object) : void
      {
         RTFacade.playerProxy.kickPlayer(param1.playerId,param1.teamId,param1.summonerName);
      }
      
      public function showCreateTeamModal() : void
      {
         var _loc1_:CreateTeamModal = new CreateTeamModal();
         this.showPopup(_loc1_);
      }
      
      public function showDisbandTeamModal(param1:String, param2:Function) : void
      {
         var _loc3_:DisbandTeamModal = new DisbandTeamModal();
         _loc3_.callbackSuccess = param2;
         _loc3_.teamName = param1;
         this.showPopup(_loc3_);
      }
      
      public function showPromoteCaptainModal(param1:ArrayCollection, param2:String, param3:String, param4:Function) : void
      {
         var _loc5_:PromoteCaptainModal = new PromoteCaptainModal();
         _loc5_.canidates = param1;
         _loc5_.callbackSuccess = param4;
         _loc5_.messageText = param2;
         _loc5_.confirmButtonText = param3;
         this.showPopup(_loc5_);
      }
      
      public function showCancelInviteModal(param1:String, param2:Number, param3:TeamId) : void
      {
         var _loc4_:Object = {
            "summonerName":param1,
            "playerId":param2,
            "teamId":param3
         };
         var _loc5_:TwoButtonGenericModalData = new TwoButtonGenericModalData();
         _loc5_.title = RTResource.getString("revokeInviteTitle");
         _loc5_.message = RTResource.getString("revokeInviteBody",[param1]);
         _loc5_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_cancel");
         _loc5_.rightButtonLabel = RTResource.getString("revokeInviteRight");
         _loc5_.rightButtonCallback = this.onShowCancelInviteModal;
         _loc5_.callbackProperty = _loc4_;
         this.showTwoButtonGenericModal(_loc5_);
      }
      
      private function onShowCancelInviteModal(param1:Object) : void
      {
         RTFacade.playerProxy.cancelInvite(param1.playerId,param1.teamId);
      }
      
      public function showTwoButtonGenericModal(param1:TwoButtonGenericModalData) : void
      {
         var _loc2_:TwoButtonGenericModal = new TwoButtonGenericModal();
         _loc2_.parameters = param1;
         this.showPopup(_loc2_);
      }
   }
}

