package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.chrome.metrics.TickerUsageTracker;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ChromeTickerMessage extends StatefulView implements ISelectableRenderer
   {
      
      private static const RESOURCE_PREFIX:String = "alert_ticker_";
      
      public static const STATE_INFO:String = "info";
      
      public static const STATE_WARNING:String = "warning";
      
      public static const STATE_ERROR:String = "error";
      
      protected var _selectionRequested:Signal = new Signal();
      
      private var _txtTitle:Text;
      
      private var _txtBody:Text;
      
      private var _titleBG:StatefulView;
      
      private var _bg:SpriteProxy;
      
      private var _bgHighlight:SpriteProxy;
      
      private var _iconExpandContract:StatefulView;
      
      private var _button:ButtonX;
      
      private var _url:String;
      
      private var _index:uint;
      
      private var _data:BroadcastMessage;
      
      private var _isSelected:Boolean;
      
      private var _tracker:TickerUsageTracker = null;
      
      public function ChromeTickerMessage(param1:IContext, param2:TickerUsageTracker)
      {
         super(param1);
         setMouseChildren(true);
         this._tracker = param2;
      }
      
      override protected function createChildren() : void
      {
         setLinkage("ChromeTickerMessage");
         this._txtTitle = new Text(this);
         setTimelineChildByName("txtTitle",this._txtTitle);
         this._txtTitle.setMouseEnabled(false);
         this._txtTitle.setTruncateToFit(true);
         this._iconExpandContract = new StatefulView(this);
         setTimelineChildByName("iconExpandContract",this._iconExpandContract);
         this._iconExpandContract.setMouseEnabled(false);
         this._iconExpandContract.setMouseChildren(false);
         this._iconExpandContract.setCurrentState("minus");
         this._titleBG = new StatefulView(this);
         setTimelineChildByName("titleBG",this._titleBG);
         this._titleBG.setCurrentState("warning");
         this._titleBG.addEventListener(MouseEvent.CLICK,this.onClickTitle,false,0,true);
         this._titleBG.setUseHandCursor(true);
         this._titleBG.setButtonMode(true);
         this._txtBody = new Text(this);
         setTimelineChildByName("txtBody",this._txtBody);
         this._txtBody.setAutoSize(TextFieldAutoSize.LEFT);
         this._txtBody.getLayoutInvalidated().add(invalidateLayout);
         this._txtBody.setMouseWheelEnabled(false);
         this._txtBody.setMouseEnabled(false);
         this._bg = new SpriteProxy(this);
         setTimelineChildByName("bg",this._bg);
         this._bg.setTransformBehavior(new ScalingTransformBehavior());
         this._bg.setUseHandCursor(true);
         this._bg.setButtonMode(true);
         this._bgHighlight = new SpriteProxy(this);
         this._bg.setTimelineChildByName("highlight",this._bgHighlight);
         this._bgHighlight.setAlpha(0);
         this._button = new ButtonX(this);
         setTimelineChildByName("titleBG.button",this._button);
         this._button.setHitArea(this._titleBG);
         this.updateURL();
         super.createChildren();
         this.setSelected(true);
      }
      
      private function updateURL() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(RiotServiceConfig.SERVICE_STATUS_API_NAMESPACE,RiotServiceConfig.SERVICE_STATUS_API_ENABLED,false,this.updateURL);
         if(_loc1_.getBoolean())
         {
            _loc2_ = RiotServiceConfig.instance.status_url + "/";
            _loc3_ = _loc2_ + "?" + ClientConfig.instance.locale + "#" + ClientConfig.instance.regionTag;
            this.setURL(_loc3_);
         }
         else
         {
            this.setURL(ResourceManager.getInstance().getString("resources","tickerStatusURL"));
         }
      }
      
      private function onClickTitle(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this._isSelected = param1;
         this._txtBody.setVisible(this._isSelected);
         this._bg.setVisible(this._isSelected);
         this._iconExpandContract.setCurrentState(param1 ? "minus" : "plus");
         invalidateLayout();
      }
      
      public function getSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      public function setURL(param1:String) : void
      {
         if(param1 == "")
         {
            this._bg.removeEventListener(MouseEvent.CLICK,this.onClick,false);
            this._bg.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false);
            this._bg.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false);
            unassignToolTip(this._bg);
         }
         else
         {
            this._bg.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
            this._bg.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
            this._bg.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
            assignToolTip(this._bg,ResourceManager.getInstance().getString("resources","alert_ticker_more_info"));
         }
         this._url = param1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(this._url));
         this._tracker.onMessageClick();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         TweenLite.to(this._bgHighlight.getSetterProxy(),0.2,{
            "alpha":1,
            "ease":Sine.easeOut
         });
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         TweenLite.to(this._bgHighlight.getSetterProxy(),0.2,{
            "alpha":0,
            "ease":Sine.easeOut
         });
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function setData(param1:*) : void
      {
         if(!(param1 is BroadcastMessage))
         {
            this._data = null;
            return;
         }
         var _loc2_:BroadcastMessage = param1 as BroadcastMessage;
         var _loc3_:String = RESOURCE_PREFIX + _loc2_.messageKey;
         var _loc4_:String = ResourceManager.getInstance().getString("resources",_loc3_,[_loc2_.content]);
         if(_loc4_ == null || _loc4_ == "")
         {
            _loc4_ = _loc2_.content;
         }
         this._txtBody.setText(_loc4_);
         this._txtTitle.setText(_loc4_);
         switch(_loc2_.severity.toLowerCase())
         {
            case "error":
               this._titleBG.setCurrentState(STATE_ERROR);
               break;
            case "warn":
               this._titleBG.setCurrentState(STATE_WARNING);
               break;
            case "info":
            default:
               this._titleBG.setCurrentState(STATE_INFO);
         }
         this._data = param1;
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         if(this._isSelected)
         {
            _loc4_ = this._txtBody.setExplicitSize(NaN,NaN);
            _loc5_ = Math.round(_loc4_.y + this._txtBody.getY() + 8);
            _loc6_ = this._bg.setExplicitSize(NaN,_loc5_);
            _loc3_ = _loc6_.y;
         }
         else
         {
            _loc3_ = Number(this._titleBG.getHeight());
         }
         return new Rectangle(0,0,getWidth(),_loc3_);
      }
   }
}

