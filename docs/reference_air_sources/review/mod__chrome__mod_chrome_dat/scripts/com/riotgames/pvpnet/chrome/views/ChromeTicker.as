package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.chrome.metrics.TickerUsageTracker;
   import com.riotgames.rust.data.ListAdapter;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class ChromeTicker extends StatefulView
   {
      
      private var _buttonClose:ButtonX;
      
      private var _messageListScroller:DataScroller;
      
      private var _messageList:ListAdapter;
      
      private var _bg:SpriteProxy;
      
      private var _sizer:SpriteProxy;
      
      private var _visibilityChanged:Signal = new Signal();
      
      private var _tracker:TickerUsageTracker = null;
      
      public function ChromeTicker(param1:IContext, param2:TickerUsageTracker)
      {
         this._tracker = param2;
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._bg = new SpriteProxy(this);
         setTimelineChildByName("bg",this._bg);
         this._bg.setTransformBehavior(new ScalingTransformBehavior());
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this._sizer.setVisible(false);
         this._buttonClose = new ButtonX(this);
         setTimelineChildByName("buttonClose",this._buttonClose);
         this._buttonClose.addEventListener(MouseEvent.CLICK,this.onButtonCloseClick,false,0,true);
         var _loc1_:RendererFactory = new RendererFactory(ChromeTickerMessage,[this,this._tracker]);
         this._messageListScroller = new DataScroller(this);
         this._messageListScroller.setScrollPolicy(ScrollPolicy.AUTO);
         this._messageListScroller.getSelectionBehavior().autoMultipleSelection = true;
         this._messageListScroller.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("messageList",this._messageListScroller);
         this._messageListScroller.setRendererFactory(_loc1_);
         this._messageList = new ListAdapter();
         var _loc2_:ListView = new ListView(this._messageList);
         _loc2_.sortWithCompare(this.sortBySeverity);
         this._messageListScroller.setDataProvider(_loc2_);
         this._messageListScroller.getSelectionBehavior().selectAll();
         this._messageList.getItemsAdded().add(this.messageListItemsAddedHandler);
      }
      
      private function messageListItemsAddedHandler(param1:IListX, param2:Array) : void
      {
         this._messageListScroller.getSelectionBehavior().setItemsSelected(Vector.<Object>(param2),true);
      }
      
      public function setMessages(param1:ArrayCollection) : void
      {
         this._messageList.setList(param1);
         if(param1.length <= 0)
         {
            this.setVisible(getVisible());
         }
      }
      
      public function getMessages() : IList
      {
         return this._messageList.getList();
      }
      
      public function sortBySeverity(param1:*, param2:*) : Number
      {
         var _loc3_:String = (param1 as BroadcastMessage).severity.toLowerCase();
         var _loc4_:String = (param2 as BroadcastMessage).severity.toLowerCase();
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         if(_loc3_ == "error" || _loc3_ == "warn" && _loc4_ == "info")
         {
            return -1;
         }
         return 1;
      }
      
      private function onButtonCloseClick(param1:MouseEvent) : void
      {
         this._tracker.onCloseClick();
         this.setVisible(false);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._messageListScroller.setExplicitSize(this._sizer.getWidth(),NaN);
         var _loc3_:Rectangle = this._messageListScroller.getDataGroup().getMeasuredBounds();
         if(_loc3_ == null)
         {
            return super.updateLayout(param1,param2);
         }
         var _loc4_:Rectangle = new Rectangle(this._sizer.getX(),this._sizer.getY(),this._sizer.getWidth(),Math.min(this._sizer.getHeight(),_loc3_.bottom));
         this._messageListScroller.setExplicitSize(_loc4_.width,_loc4_.height);
         this._bg.setExplicitSize(NaN,_loc4_.bottom + 8);
         return super.updateLayout(param1,param2);
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         super.setVisible(param1);
         this._visibilityChanged.dispatch();
      }
      
      public function get visibilityChanged() : ISignal
      {
         return this._visibilityChanged;
      }
   }
}

