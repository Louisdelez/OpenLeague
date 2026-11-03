package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class CapSummaryTooltip extends SpriteProxy
   {
      
      private static const TITLE_TEXT_NAME:String = "titleText";
      
      private static const TITLE_SUBTEXT_NAME:String = "titleSubText";
      
      private static const DESCRIPTION_TEXT_NAME:String = "descriptionText";
      
      private static const BACKGROUND_NAME:String = "background";
      
      protected var titleText:Text;
      
      protected var arrow:SpriteProxy;
      
      protected var background:SpriteProxy;
      
      protected var descriptionText:Text;
      
      protected var textContainer:LayoutContainerView;
      
      protected var titleSubText:Text;
      
      public function CapSummaryTooltip(param1:IContext)
      {
         super(param1);
         setLinkage("SummaryTooltip");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.textContainer.setExplicitSize(NaN,NaN);
         this.background.setExplicitSize(NaN,_loc3_.y + 23);
         this.arrow.setExplicitPosition(NaN,this.background.getY() + this.background.getHeight() / 2 - this.arrow.getHeight() / 2);
         return new Rectangle(0,0,this.background.getX() + this.background.getWidth(),this.background.getY() + this.background.getHeight());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.textContainer = new LayoutContainerView(this);
         this.textContainer.setLayoutAlgorithm(new VerticalLayout());
         setTimelineChildByName("textContainer",this.textContainer);
         this.titleText = new Text(this);
         this.titleText.setAutoSize(TextFieldAutoSize.LEFT);
         this.titleText.getLayoutInvalidated().add(invalidateLayout);
         this.textContainer.setTimelineChildByName(TITLE_TEXT_NAME,this.titleText);
         this.textContainer.addElement(this.titleText);
         this.titleSubText = new Text(this);
         this.titleSubText.setAutoSize(TextFieldAutoSize.LEFT);
         this.titleSubText.getLayoutInvalidated().add(invalidateLayout);
         this.textContainer.setTimelineChildByName(TITLE_SUBTEXT_NAME,this.titleSubText);
         this.textContainer.addElement(this.titleSubText);
         this.descriptionText = new Text(this);
         this.descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this.descriptionText.getLayoutInvalidated().add(invalidateLayout);
         this.textContainer.setTimelineChildByName(DESCRIPTION_TEXT_NAME,this.descriptionText);
         this.textContainer.addElement(this.descriptionText);
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         this.background.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName(BACKGROUND_NAME,this.background);
         this.arrow = new SpriteProxy(this);
         setTimelineChildByName("arrow",this.arrow);
      }
   }
}

