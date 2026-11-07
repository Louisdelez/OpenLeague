package com.riotgames.pvpnet.tournament.view
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.pvpnet.tournament.TournamentCodeProvider;
   import com.riotgames.rust.components.PromptingTextView;
   import flash.events.MouseEvent;
   
   public class TournamentCodePanel extends SpriteProxy
   {
      
      private var codeProvider:TournamentCodeProvider;
      
      private var joinGameButton:AudioButton;
      
      private var codeValidationText:TextFieldProxy;
      
      private var codeInput:PromptingTextView;
      
      public function TournamentCodePanel(param1:IContext)
      {
         super(param1);
         setLinkage("tc.TournamentCodePanel");
         this.codeProvider = getDependency(TournamentCodeProvider);
      }
      
      private function onTextChanged() : void
      {
         var _loc1_:Boolean = false;
         if(!this.codeInput.isShowingPrompt)
         {
            _loc1_ = this.codeProvider.validateCode(this.codeInput.getText());
            if(_loc1_)
            {
               this.codeValidationText.setText(RiotResourceLoader.getString("tournamentCodeValid","**valid"));
               this.joinGameButton.setEnabled(true);
            }
            else
            {
               this.codeValidationText.setText(RiotResourceLoader.getString("tournamentCodeInvalid","**not valid"));
               this.joinGameButton.setEnabled(false);
            }
         }
         else
         {
            this.codeValidationText.setText("");
            this.joinGameButton.setEnabled(false);
         }
      }
      
      protected function wire(param1:String, param2:Class = null) : *
      {
         if(param2 == null)
         {
            param2 = SpriteProxy;
         }
         var _loc3_:DisplayObjectProxy = new param2(this);
         setTimelineChildByName(param1,_loc3_);
         return _loc3_;
      }
      
      override protected function createChildren() : void
      {
         this.codeInput = this.wire("codeInput",PromptingTextView);
         this.codeInput.promptText = RiotResourceLoader.getString("tournamentCodePrompt","**prompt");
         this.codeInput.onTextChanged.add(this.onTextChanged);
         this.codeValidationText = this.wire("codeValidationText",TextFieldProxy);
         this.codeValidationText.setText("");
         this.joinGameButton = this.wire("joinGameButton",AudioButton);
         var _loc1_:TextFieldProxy = new TextFieldProxy(this.joinGameButton);
         this.joinGameButton.setTimelineChildByName("label",_loc1_);
         _loc1_.setText(RiotResourceLoader.getString("tournamentCodeJoinGame"));
         this.joinGameButton.addEventListener(MouseEvent.CLICK,this.onJoinClicked);
         this.joinGameButton.setEnabled(false);
      }
      
      private function onJoinClicked(param1:MouseEvent) : void
      {
         this.codeProvider.injectCode(this.codeInput.getText());
         this.codeInput.setText("bleh");
         this.codeInput.setText(null);
         this.onTextChanged();
      }
   }
}

