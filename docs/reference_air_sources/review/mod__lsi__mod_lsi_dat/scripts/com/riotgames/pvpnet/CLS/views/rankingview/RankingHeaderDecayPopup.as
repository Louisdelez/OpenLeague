package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.greensock.TweenMax;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class RankingHeaderDecayPopup extends StatefulView
   {
      
      private var decayTitleText:TextFieldProxy;
      
      private var decayText:TextFieldProxy;
      
      private var closeButton:ButtonX;
      
      private var currentMessage:String;
      
      private var messagesShown:Array = [];
      
      public function RankingHeaderDecayPopup(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.decayText = new TextFieldProxy(this);
         setTimelineChildByName("decayText",this.decayText);
         this.decayTitleText = new TextFieldProxy(this);
         setTimelineChildByName("decayTitleText",this.decayTitleText);
         this.decayTitleText.setHtmlText(ResourceManager.getInstance().getString("resources","league_system_decay_title"));
         this.closeButton = new ButtonX(this);
         setTimelineChildByName("closeButton",this.closeButton);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onClickCloseButton);
         this.decayText.setAlpha(0);
         this.decayTitleText.setAlpha(0);
         this.setCurrentState("hide");
      }
      
      private function onClickCloseButton(param1:MouseEvent) : void
      {
         this.hide();
         this.messagesShown.push(this.currentMessage);
      }
      
      public function hide() : void
      {
         this.decayTitleText.setAlpha(0);
         this.decayText.setText("");
         this.decayText.setAlpha(0);
         this.setCurrentState("hide");
      }
      
      public function show(param1:String, param2:Boolean = false) : void
      {
         if(this.messagesShown.indexOf(param1) != -1 && !param2)
         {
            return;
         }
         this.setVisible(true);
         this.setCurrentState("show");
         this.decayText.setText(param1);
         TweenMax.allTo([this.decayTitleText.getSetterProxy(),this.decayText.getSetterProxy()],UserPreferencesManager.userPrefs.enableAnimations ? 0.5 : 0,{"alpha":1});
         this.currentMessage = param1;
      }
   }
}

