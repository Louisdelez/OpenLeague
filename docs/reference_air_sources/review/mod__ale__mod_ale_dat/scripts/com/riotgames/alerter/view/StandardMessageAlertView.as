package com.riotgames.alerter.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.rust.focus.RiotFocusManager;
   import com.riotgames.util.logging.getLogger;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import mx.logging.ILogger;
   
   public class StandardMessageAlertView extends StatefulView
   {
      
      protected var logger:ILogger = getLogger(this);
      
      protected var _alertAction:AlertAction;
      
      protected var affirmativeButton:LabelButtonX;
      
      protected var negativeButton:LabelButtonX;
      
      protected var background:SpriteProxy;
      
      protected var titleText:Text;
      
      protected var bodyText:Text;
      
      protected var sizer:SpriteProxy;
      
      protected var verticalLayout:VerticalLayout;
      
      protected var verticalLayoutContainer:LayoutContainer;
      
      protected var buttonsContainer:LayoutContainer;
      
      public function StandardMessageAlertView(param1:IContext)
      {
         super(param1);
         setLinkage("StandardAlertView");
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:Padding = null;
         super.configureAsset(param1);
         if(param1)
         {
            _loc2_ = new Padding();
            _loc2_.top = this.bodyText.getY();
            _loc2_.right = this.sizer.getWidth() - this.bodyText.getWidth() - this.bodyText.getX();
            _loc2_.bottom = this.sizer.getBounds(param1).bottom - this.affirmativeButton.getBounds(param1).bottom;
            _loc2_.left = this.bodyText.getX();
            this.verticalLayout.setPadding(_loc2_);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.verticalLayout = new VerticalLayout();
         this.verticalLayout.setGap(15);
         this.verticalLayoutContainer = new LayoutContainer();
         this.verticalLayoutContainer.setLayoutAlgorithm(this.verticalLayout);
         this.verticalLayoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this.titleText = new Text(this);
         setTimelineChildByName("titleText",this.titleText);
         this.bodyText = new Text(this);
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle("a:link",{
            "color":"#4A84B2",
            "textDecoration":"none"
         });
         _loc1_.setStyle("a:hover",{"textDecoration":"underline"});
         this.bodyText.setStyleSheet(_loc1_);
         this.bodyText.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("bodyText",this.bodyText);
         this.verticalLayoutContainer.addElement(this.bodyText);
         this.buttonsContainer = new LayoutContainer();
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         this.buttonsContainer.setLayoutAlgorithm(_loc2_);
         var _loc3_:SizeLayoutData = new SizeLayoutData();
         _loc3_.setWidthPercent(1);
         this.verticalLayoutContainer.addElement(this.buttonsContainer,_loc3_);
         this.affirmativeButton = new ResizableButton(this);
         this.affirmativeButton.addEventListener(MouseEvent.CLICK,this.affirmativeClickHandler);
         this.affirmativeButton.setVisible(false);
         setTimelineChildByName("affirmativeButton",this.affirmativeButton);
         this.buttonsContainer.addElement(this.affirmativeButton);
         this.negativeButton = new ResizableButton(this);
         this.negativeButton.addEventListener(MouseEvent.CLICK,this.negativeClickHandler);
         this.negativeButton.setVisible(false);
         setTimelineChildByName("negativeButton",this.negativeButton);
         this.buttonsContainer.addElement(this.negativeButton);
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
      }
      
      protected function affirmativeClickHandler(param1:MouseEvent) : void
      {
         if(this._alertAction == null)
         {
            return;
         }
         this._alertAction.affirmativeResponse = true;
         this._alertAction.complete();
      }
      
      protected function negativeClickHandler(param1:MouseEvent) : void
      {
         if(this._alertAction == null)
         {
            return;
         }
         this._alertAction.affirmativeResponse = false;
         this._alertAction.complete();
      }
      
      public function getAlertAction() : AlertAction
      {
         return this._alertAction;
      }
      
      public function setAlertAction(param1:AlertAction) : void
      {
         var value:AlertAction = param1;
         if(this._alertAction == value)
         {
            return;
         }
         if(this._alertAction != null && value == null)
         {
            this._alertAction.getBodyChanged().removeAll();
         }
         this._alertAction = value;
         if(this._alertAction != null)
         {
            this.affirmativeButton.setVisible(this._alertAction.showAffirmative);
            this.negativeButton.setVisible(this._alertAction.showNegative);
            this.affirmativeButton.setText(this._alertAction.affirmativeLabel);
            this.negativeButton.setText(this._alertAction.negativeLabel);
            this.titleText.setText(this._alertAction.title);
            this.updateBodyText();
            if(this._alertAction.affirmativeDefault)
            {
               RiotFocusManager.setFocus(this.affirmativeButton,false);
               this._alertAction.affirmativeResponse = true;
            }
            else
            {
               RiotFocusManager.setFocus(this.negativeButton,false);
               this._alertAction.affirmativeResponse = false;
            }
            setAlpha(0);
            TweenLite.to(getSetterProxy(),0.5,{
               "alpha":1,
               "ease":Sine.easeOut
            });
            this._alertAction.getBodyChanged().add(function():*
            {
               updateBodyText();
            });
         }
      }
      
      private function updateBodyText() : void
      {
         this.bodyText.setHtmlText("<font face=\'ApplicationFont2\'>" + this._alertAction.body + "</font>");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.verticalLayoutContainer.setExplicitSize(this.sizer.getWidth(),NaN);
         this.background.setExplicitSize(_loc3_.x,_loc3_.y);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.setAlertAction(null);
      }
   }
}

