package com.riotgames.pvpnet.seasonrewards.views.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   
   public class RewardToolTip extends SpriteProxy implements IDataRenderer
   {
      
      private var iconDisplay:SpriteProxy;
      
      private var title:TextFieldProxy;
      
      private var description:TextFieldProxy;
      
      private var icon:StatefulView;
      
      private var iconBorder:StatefulView;
      
      public function RewardToolTip(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this.setLinkage("RewardTooltip");
         this.iconDisplay = new SpriteProxy(this);
         this.title = new TextFieldProxy(this);
         this.description = new TextFieldProxy(this);
         this.icon = new StatefulView(this);
         this.iconBorder = new StatefulView(this);
         setTimelineChildByName("iconDisplay",this.iconDisplay);
         setTimelineChildByName("titleText",this.title);
         setTimelineChildByName("descriptionText",this.description);
         this.iconDisplay.setTimelineChildByName("icon",this.icon);
         this.iconDisplay.setTimelineChildByName("iconBorder",this.iconBorder);
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         this.iconDisplay.setTimelineChildByName("requirementText",_loc1_);
         _loc1_.setText("");
         _loc1_.setVisible(false);
      }
      
      public function setData(param1:*) : void
      {
         this.title.setText(param1.title);
         this.description.setText(param1.description);
         this.icon.setCurrentState(param1.icon);
      }
      
      public function getData() : *
      {
         return null;
      }
   }
}

