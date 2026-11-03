package com.riotgames.platform.gameclient.controllers.game.views.skinrental
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.enum.ButtonStatesEnum;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.MouseEvent;
   
   public class SkinRentalButton extends LabelButtonX
   {
      
      private var clickable:Boolean = true;
      
      private var unlocked:Boolean = false;
      
      private var clicked:Signal = new Signal();
      
      private var pricing:SpriteProxy;
      
      public function SkinRentalButton(param1:IContext)
      {
         super(param1);
         setLinkage("SkinRentalButton");
      }
      
      public function setClickable(param1:Boolean) : void
      {
         this.clickable = param1;
         this.refreshState();
      }
      
      public function setUnlocked(param1:Boolean) : void
      {
         this.unlocked = param1;
         this.refreshState();
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         if(this.clickable)
         {
            this.clicked.dispatch(this.clicked);
         }
      }
      
      public function getClicked() : ISignal
      {
         return this.clicked;
      }
      
      override protected function refreshState() : void
      {
         if(this.unlocked)
         {
            setCurrentState("unlocked");
         }
         else if(!this.clickable)
         {
            setCurrentState(ButtonStatesEnum.DISABLED);
         }
         else
         {
            super.refreshState();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.pricing = new SpriteProxy(this);
         setTimelineChildByName("pricing",this.pricing);
         this.addEventListener(MouseEvent.CLICK,this.onClicked,false,0,true);
      }
   }
}

