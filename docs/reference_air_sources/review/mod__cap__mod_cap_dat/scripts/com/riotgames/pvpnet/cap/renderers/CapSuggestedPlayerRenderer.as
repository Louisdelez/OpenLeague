package com.riotgames.pvpnet.cap.renderers
{
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import flash.events.MouseEvent;
   
   public class CapSuggestedPlayerRenderer extends StatefulView implements IItemRenderer
   {
      
      private var _declineButton:ButtonX;
      
      private var _textField:Text;
      
      private var _index:uint;
      
      private var _suggestedPlayer:SuggestedPlayer;
      
      private var _inviteRequested:Signal = new Signal();
      
      private var _addButton:ButtonX;
      
      private var _declineRequested:Signal = new Signal();
      
      public function CapSuggestedPlayerRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("RecommendedInviteRenderer");
      }
      
      private function handleDeclineButtonClicked(param1:MouseEvent) : void
      {
         this._declineRequested.dispatch(this);
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getDeclineRequested() : ISignal
      {
         return this._declineRequested;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._textField = new Text(this);
         this._textField.setTruncateToFit(true);
         setTimelineChildByName("summonerNameTextField",this._textField);
         this._addButton = new ButtonX(this);
         setTimelineChildByName("addButton",this._addButton);
         this._addButton.addEventListener(MouseEvent.CLICK,this.handleAddButtonClicked);
         this._declineButton = new ButtonX(this);
         setTimelineChildByName("declineButton",this._declineButton);
         this._declineButton.addEventListener(MouseEvent.CLICK,this.handleDeclineButtonClicked);
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._suggestedPlayer)
         {
            this._textField.setText(this._suggestedPlayer.summonerName);
            if(this._suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_HONORED)
            {
               assignToolTip(this._textField,CapLocaleUtil.getResourceString("gf_suggestedPlayers_honored_tooltip","",[this._suggestedPlayer.summonerName]));
            }
            else if(this._suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_VICTORIOUS_COMRADE)
            {
               assignToolTip(this._textField,CapLocaleUtil.getResourceString("gf_suggestedPlayers_victorious_comrade_tooltip","",[this._suggestedPlayer.summonerName]));
            }
            else if(this._suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
            {
               assignToolTip(this._textField,CapLocaleUtil.getResourceString("gf_suggestedPlayers_fof_tooltip","",[this._suggestedPlayer.summonerName,this._suggestedPlayer.commonFriendName]));
            }
            else
            {
               unassignToolTip(this._textField);
            }
            if(this._suggestedPlayer.suggestionReason == SuggestedPlayer.REASON_LEGACY_PLAY_AGAIN)
            {
               setCurrentState("noDecline");
            }
            else
            {
               setCurrentState("withDecline");
            }
         }
      }
      
      public function getData() : *
      {
         return this._suggestedPlayer;
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setData(param1:*) : void
      {
         this._suggestedPlayer = param1;
         this.updateView();
      }
      
      public function getInviteRequested() : ISignal
      {
         return this._inviteRequested;
      }
      
      private function handleAddButtonClicked(param1:MouseEvent) : void
      {
         this._inviteRequested.dispatch(this);
      }
   }
}

