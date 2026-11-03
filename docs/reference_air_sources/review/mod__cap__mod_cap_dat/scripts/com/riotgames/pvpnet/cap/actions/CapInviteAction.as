package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   
   public class CapInviteAction extends BasicAction
   {
      
      private var _inviteProvider:IInviteProvider;
      
      private var _capModel:CapModel;
      
      public function CapInviteAction(param1:CapModel, param2:IInviteProvider)
      {
         super(false);
         this._capModel = param1;
         this._inviteProvider = param2;
      }
      
      override protected function doInvocation() : void
      {
         this._inviteProvider.getInviteGroup().groupId = this._capModel.groupId;
         var _loc1_:IAction = this._inviteProvider.getOpenInvitePanelAction();
         if(_loc1_)
         {
            _loc1_.invoke();
         }
         complete();
      }
   }
}

