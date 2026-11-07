package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ChromeContextAlertView extends StatefulView
   {
      
      private static const STATE_CLOSED:String = "closed";
      
      private static const STATE_OPENED:String = "opened";
      
      private static const SHEENSTATE_NO_SHEEN:String = "noSheen";
      
      private static const SHEENSTATE_POST_SHEEN:String = "postSheen";
      
      private var _contentContainer:StatefulView;
      
      private var _closeButton:ButtonX;
      
      private var _background:StatefulView;
      
      private var _messageBodyContainer:LayoutContainerView;
      
      private var _rule:SpriteProxy;
      
      private var _titleText:TextFieldProxy;
      
      private var _bodyText:TextFieldProxy;
      
      private var _arrowSizer:SpriteProxy;
      
      private var _sheener:StatefulView;
      
      private var _model:AlertParameters;
      
      private var _closeButtonClicked:Signal = new Signal();
      
      public function ChromeContextAlertView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this._contentContainer = new StatefulView(this);
         setTimelineChildByName("contextAlertContainer",this._contentContainer);
         this._messageBodyContainer = new LayoutContainerView(this);
         this._messageBodyContainer.setLayoutAlgorithm(new VerticalLayout());
         this._messageBodyContainer.getLayoutInvalidated().add(invalidateLayout);
         this._contentContainer.setTimelineChildByName("messageBodyContainer",this._messageBodyContainer);
         this._titleText = new TextFieldProxy(this);
         this._titleText.setAutoSize(TextFieldAutoSize.LEFT);
         this._titleText.setMouseWheelEnabled(false);
         this._titleText.setText("");
         this._messageBodyContainer.setTimelineChildByName("titleText",this._titleText);
         this._messageBodyContainer.addElement(this._titleText);
         this._rule = new SpriteProxy(this);
         this._messageBodyContainer.setTimelineChildByName("rule",this._rule);
         this._messageBodyContainer.addElement(this._rule);
         this._bodyText = new TextFieldProxy(this);
         this._bodyText.setAutoSize(TextFieldAutoSize.LEFT);
         this._bodyText.setMouseWheelEnabled(false);
         this._bodyText.setText("");
         this._bodyText.addEventListener(TextEvent.LINK,this.onBodyLinkClicked);
         this._messageBodyContainer.setTimelineChildByName("bodyText",this._bodyText);
         this._messageBodyContainer.addElement(this._bodyText);
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".rightalign",{"textAlign":"right"});
         _loc1_.setStyle("a:link",{
            "color":"#4A84B2",
            "textDecoration":"none"
         });
         _loc1_.setStyle("a:hover",{"textDecoration":"underline"});
         this._bodyText.setStyleSheet(_loc1_);
         this._background = new StatefulView(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         this._contentContainer.setTimelineChildByName("background",this._background);
         this._sheener = new StatefulView(this);
         this._sheener.setTransformBehavior(new ScalingTransformBehavior());
         this._sheener.setMouseEnabled(false);
         this._contentContainer.setTimelineChildByName("sheen",this._sheener);
         this._closeButton = new ButtonX(this);
         this._contentContainer.setTimelineChildByName("closeButton",this._closeButton);
         this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         this._arrowSizer = new SpriteProxy(this);
         this._contentContainer.setTimelineChildByName("arrowBounds",this._arrowSizer);
         this.setArrowState(AlertParameters.ARROW_STATE_TOP_MIDDLE);
         super.createChildren();
      }
      
      private function onBodyLinkClicked(param1:TextEvent) : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         var _loc2_:ILobbyViewController = getDependency(ILobbyViewController);
         if(Boolean(_loc2_) && param1.text.substr(0,9).toLowerCase() === "storenav:")
         {
            _loc2_.navigateToHome();
            _loc3_ = Vector.<String>(param1.text.substr(9).split("?"));
            _loc4_ = _loc3_.length > 1 ? _loc3_[1] : "";
            _loc2_.showStoreView(_loc3_[0],_loc4_);
         }
         else
         {
            navigateToURL(new URLRequest(param1.text));
         }
         this.handleCloseButtonClicked(null);
      }
      
      private function handleCloseButtonClicked(param1:MouseEvent = null) : void
      {
         this._closeButtonClicked.dispatch(this._model);
      }
      
      public function setModel(param1:AlertParameters) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._model = param1;
         if(this._model)
         {
            _loc2_ = ResourceManager.getInstance().getString("resources",this._model.title);
            _loc3_ = ResourceManager.getInstance().getString("resources",this._model.message);
            if(_loc2_ == null && this._model.title != null)
            {
               this._titleText.setHtmlText("<font face=\'ApplicationFont2\'>" + this._model.title + "</font>");
            }
            else if(_loc2_ != null)
            {
               this._titleText.setHtmlText("<font face=\'ApplicationFont2\'>" + _loc2_ + "</font>");
            }
            if(_loc3_ == null && this._model.message != null)
            {
               this._bodyText.setHtmlText("<font face=\'ApplicationFont2\'>" + this._model.message + "</font>");
            }
            else if(_loc3_ != null)
            {
               this._bodyText.setHtmlText("<font face=\'ApplicationFont2\'>" + _loc3_ + "</font>");
            }
            setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
            this._sheener.setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
            this.setCurrentState(STATE_CLOSED);
            this.setCurrentState(STATE_OPENED);
            this._sheener.setCurrentState(SHEENSTATE_NO_SHEEN);
            this._sheener.setCurrentState(SHEENSTATE_POST_SHEEN);
         }
         else
         {
            this.setCurrentState(STATE_CLOSED);
            this._titleText.setText("");
            this._bodyText.setText("");
         }
      }
      
      public function setArrowState(param1:String) : void
      {
         this._contentContainer.setCurrentState(param1);
         invalidateLayout();
      }
      
      private function getArrowState() : String
      {
         return this._contentContainer.getCurrentState();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         invalidateLayout();
      }
      
      public function getCloseButtonClicked() : ISignal
      {
         return this._closeButtonClicked;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._messageBodyContainer.setExplicitSize(NaN,NaN);
         var _loc4_:Number = isNaN(this._arrowSizer.getHeight()) ? 0 : Number(this._arrowSizer.getHeight());
         var _loc5_:Number = 0;
         if(this.getArrowState() == AlertParameters.ARROW_STATE_LEFT_TOP || this.getArrowState() == AlertParameters.ARROW_STATE_RIGHT_TOP)
         {
            _loc5_ = isNaN(this._arrowSizer.getWidth()) ? 0 : Number(this._arrowSizer.getWidth());
         }
         this._background.setExplicitSize(NaN,Math.max(_loc3_.y + _loc4_ + 15,165));
         this._sheener.setExplicitSize(this._background.getWidth() - _loc5_,this._background.getHeight() - _loc4_);
         return _asset.getBounds(null);
      }
   }
}

