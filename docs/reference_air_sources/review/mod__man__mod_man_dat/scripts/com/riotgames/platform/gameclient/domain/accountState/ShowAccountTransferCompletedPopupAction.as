package com.riotgames.platform.gameclient.domain.accountState
{
   import com.riotgames.platform.gameclient.views.AccountTransfer.AccountTransferDialog;
   
   public class ShowAccountTransferCompletedPopupAction extends BaseShowAccountTransferPopupAction
   {
      
      public function ShowAccountTransferCompletedPopupAction()
      {
         super();
      }
      
      override protected function setupAccountTransferPopup(param1:AccountStateChangeContext, param2:AccountTransferDialog) : void
      {
         param2.setTransferCompleted(param1);
      }
   }
}

