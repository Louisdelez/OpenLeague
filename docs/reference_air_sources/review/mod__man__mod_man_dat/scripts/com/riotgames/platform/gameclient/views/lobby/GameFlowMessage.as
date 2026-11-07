package com.riotgames.platform.gameclient.views.lobby
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.events.MouseEvent;
   
   public class GameFlowMessage extends SpriteProxy
   {
      
      private var messageText:TextFieldProxy;
      
      private var bodyText:TextFieldProxy;
      
      private var headerText:TextFieldProxy;
      
      private var tip:StatefulView;
      
      public function GameFlowMessage(param1:IContext)
      {
         super(param1);
         setLinkage("cgf.QueueInfoMessage");
      }
      
      override protected function createChildren() : void
      {
         this.messageText = new AutoSizeTextFieldProxy(this);
         this.setTimelineChildByName("messageText",this.messageText);
         this.tip = new StatefulView(this);
         this.setTimelineChildByName("tooltip",this.tip);
         this.tip.setCurrentState("hide");
         this.headerText = new TextFieldProxy(this);
         this.setTimelineChildByName("tooltip.tipContent.tipHeaderText",this.headerText);
         this.bodyText = new TextFieldProxy(this);
         this.setTimelineChildByName("tooltip.tipContent.tipBodyText",this.bodyText);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.tip.setCurrentState("show");
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.tip.setCurrentState("hide");
      }
      
      public function setContent(param1:String, param2:String, param3:String) : void
      {
         this.tip.setCurrentState("hide");
         this.messageText.setText(param1);
         this.headerText.setText(param2);
         this.bodyText.setText(param3);
      }
   }
}

