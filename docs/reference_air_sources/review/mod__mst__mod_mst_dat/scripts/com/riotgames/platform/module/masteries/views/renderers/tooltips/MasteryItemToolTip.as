package com.riotgames.platform.module.masteries.views.renderers.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.events.PropertyChangeEvent;
   
   public class MasteryItemToolTip extends StatefulView implements IDataRenderer
   {
      
      private var rankText:TextFieldProxy;
      
      private var titleText:TextFieldProxy;
      
      private var descriptionText:TextFieldProxy;
      
      private var reqText:TextFieldProxy;
      
      private var background:SpriteProxy;
      
      private var contentPositioner:SpriteProxy;
      
      private var _model:MasteryItemToolTipModel;
      
      private var layoutContainer:LayoutContainer;
      
      public function MasteryItemToolTip(param1:Context)
      {
         super(param1);
         setLinkage("MasteryTooltip");
      }
      
      private function updateDisplayFields() : void
      {
         var _loc1_:uint = 0;
         this.titleText.setText(this._model.title);
         this.rankText.setText(this._model.rank);
         if(this._model.state == "inactive")
         {
            this.reqText.setText(this._model.requirements);
         }
         else
         {
            this.reqText.setText("");
         }
         this.descriptionText.setHtmlText("<font face=\'ApplicationFont2\'>" + this._model.description + "</font>");
         switch(this._model.groupId)
         {
            case 1:
               _loc1_ = 11934976;
               break;
            case 2:
               _loc1_ = 3381555;
               break;
            case 3:
               _loc1_ = 5025791;
         }
         this.titleText.setTextColor(_loc1_);
         this.setCurrentState(this._model.state);
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
         if(!(param1 is MasteryItemToolTipModel))
         {
            throw new ArgumentError("data property must be of type MasteryItemToolTipModel");
         }
         if(this._model != null)
         {
            this._model.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onModelPropertyChanged);
         }
         this._model = param1 as MasteryItemToolTipModel;
         this._model.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onModelPropertyChanged,false,0,true);
         if(this._model.state == null)
         {
            this._model.state = "inactive";
         }
         this.updateDisplayFields();
      }
      
      private function onModelPropertyChanged(param1:PropertyChangeEvent) : void
      {
         this.updateDisplayFields();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.layoutContainer.setExplicitSize(NaN,NaN);
         this.background.setExplicitSize(NaN,_loc3_.y + this.contentPositioner.getY() + 5);
         this.layoutContainer.setExplicitPosition(this.contentPositioner.getX(),this.contentPositioner.getY());
         return _asset.getBounds(null);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.titleText = new TextFieldProxy(this);
         this.rankText = new TextFieldProxy(this);
         this.reqText = new TextFieldProxy(this);
         this.descriptionText = new TextFieldProxy(this);
         this.background = new SpriteProxy(this);
         this.contentPositioner = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         this.setTimelineChildByName("toolTipTitleText",this.titleText);
         this.setTimelineChildByName("toolTipRankText",this.rankText);
         this.setTimelineChildByName("toolTipRequirementsText",this.reqText);
         this.setTimelineChildByName("toolTipDescriptionText",this.descriptionText);
         this.setTimelineChildByName("background",this.background);
         this.setTimelineChildByName("contentPositioner",this.contentPositioner);
         this.titleText.setAutoSize(TextFieldAutoSize.LEFT);
         this.rankText.setAutoSize(TextFieldAutoSize.LEFT);
         this.reqText.setAutoSize(TextFieldAutoSize.LEFT);
         this.descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this.layoutContainer = new LayoutContainer(this);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(1);
         this.layoutContainer.setLayoutAlgorithm(_loc1_);
         this.layoutContainer.addElement(this.titleText);
         this.layoutContainer.addElement(this.rankText);
         this.layoutContainer.addElement(this.reqText);
         this.layoutContainer.addElement(this.descriptionText);
         this.layoutContainer.getLayoutInvalidated().add(invalidateLayout);
      }
   }
}

