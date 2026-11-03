package com.riotgames.championdetails.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.toolTip.DescriptiveToolTipAsset;
   import blix.components.renderer.IDataRenderer;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class DescriptiveToolTip extends SpriteProxy implements IDataRenderer
   {
      
      private var titleText:TextFieldProxy;
      
      private var hotKeyText:TextFieldProxy;
      
      private var costText:TextFieldProxy;
      
      private var descriptionText:TextFieldProxy;
      
      private var _model:DescriptiveToolTipModel;
      
      private var layoutContainer:LayoutContainer;
      
      private var background:SpriteProxy;
      
      private var contentPositioner:SpriteProxy;
      
      public function DescriptiveToolTip(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage(DescriptiveToolTipAsset.LINKAGE);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:DescriptiveToolTipAsset = new DescriptiveToolTipAsset();
         this.titleText = _loc1_.titleText.create(this);
         this.hotKeyText = _loc1_.hotKeyText.create(this);
         this.costText = _loc1_.costText.create(this);
         this.descriptionText = _loc1_.descriptionText.create(this);
         this.descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this.background = _loc1_.background.create(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         this.contentPositioner = _loc1_.contentPositioner.create(this);
         this.layoutContainer = new LayoutContainer(this);
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.setGap(1);
         this.layoutContainer.setLayoutAlgorithm(_loc2_);
         this.layoutContainer.addElement(this.titleText);
         this.layoutContainer.addElement(this.costText);
         this.layoutContainer.addElement(this.descriptionText);
         this.layoutContainer.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!(param1 is DescriptiveToolTipModel))
         {
            throw new ArgumentError("data property must be of type DescriptiveToolTipModel");
         }
         this._model = param1 as DescriptiveToolTipModel;
         this.titleText.setText(this._model.title);
         this.hotKeyText.setText(this._model.hotKey);
         this.costText.setText(this._model.cost);
         this.costText.setIncludeInLayout(!!this._model.cost);
         this.descriptionText.setHtmlText("<font face=\'ApplicationFont1\'>" + this._model.description + "</font>");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.layoutContainer.setExplicitSize(NaN,NaN);
         this.background.setExplicitSize(NaN,_loc3_.y + this.contentPositioner.getY() * 2 + 5);
         this.layoutContainer.setExplicitPosition(this.contentPositioner.getX(),this.contentPositioner.getY());
         return _asset.getBounds(null);
      }
   }
}

