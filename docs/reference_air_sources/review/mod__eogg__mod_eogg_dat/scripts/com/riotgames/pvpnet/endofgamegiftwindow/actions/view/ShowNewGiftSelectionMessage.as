package com.riotgames.pvpnet.endofgamegiftwindow.actions.view
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class ShowNewGiftSelectionMessage extends BasicAction
   {
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _newMessage:String;
      
      private var _senderName:String;
      
      public function ShowNewGiftSelectionMessage(param1:IEndOfGameGiftViewMediator, param2:String, param3:String)
      {
         this._view = param1;
         this._newMessage = param2;
         this._senderName = param3;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         this._view.setNewGiftMessage(this._newMessage,this._senderName);
         complete();
      }
   }
}

