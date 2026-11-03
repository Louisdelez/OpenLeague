package com.riotgames.pvpnet.cap.actions.responses
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.pvpnet.cap.actions.CapStatusMessageAction;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   
   public class CapMatchMadeV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "matchMadeV1";
      
      private var _chatProvider:IChatProvider;
      
      private var _model:CapModel;
      
      private var _inviteGroup:InviteGroup;
      
      private var _controller:ICapController;
      
      private var _playAgainModel:CapPlayAgainModel;
      
      public function CapMatchMadeV1Action(param1:CapModel, param2:CapPlayAgainModel, param3:IDecode, param4:String, param5:IChatProvider, param6:InviteGroup, param7:ICapController)
      {
         super(METHOD_NAME,param3,param4);
         this._model = param1;
         this._chatProvider = param5;
         this._inviteGroup = param6;
         this._playAgainModel = param2;
         this._controller = param7;
      }
      
      private function savePlayAgainData() : void
      {
         if(CapFlowUtil.isCaptain(this._model))
         {
            this._playAgainModel.reinviteList.source = this._inviteGroup.acceptedParticipants.toArray();
            this._playAgainModel.suggestionList.source = this.getSolos(this._model);
            this._playAgainModel.reinviteList.refresh();
         }
      }
      
      private function getSolos(param1:CapModel) : Array
      {
         var _loc2_:CapPlayerSelection = null;
         var _loc3_:Array = [];
         for each(_loc2_ in param1.playerSelections)
         {
            if(_loc2_.isSolo())
            {
               _loc3_.push(_loc2_.summonerName);
            }
         }
         return _loc3_;
      }
      
      private function displayChatMessage() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_status_message_match_made","Match made.");
         var _loc2_:IAction = new CapStatusMessageAction(this._model,this._chatProvider,_loc1_);
         _loc2_.invoke();
      }
      
      private function orderClientToFront() : void
      {
         var _loc1_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         _loc1_.activate();
         _loc1_.orderToFront();
         _loc1_.alwaysInFront = true;
         _loc1_.alwaysInFront = false;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         this._model.hasLaunchedGame = true;
         this._model.pvpNetHomeButtonVisible = false;
         this.orderClientToFront();
         this.displayChatMessage();
         this.disableQuit();
         this.savePlayAgainData();
         this.sendPlayAgainMetrics();
      }
      
      private function disableQuit() : void
      {
         this._model.quitEnabled = false;
      }
      
      private function sendPlayAgainMetrics() : void
      {
         this._model.currentPhase = CapPhase.GAME_STARTING;
         this._controller.trackPlayAgainMetrics();
      }
   }
}

