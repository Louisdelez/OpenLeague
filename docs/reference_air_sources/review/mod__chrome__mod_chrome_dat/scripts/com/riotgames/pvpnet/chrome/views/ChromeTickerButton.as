package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.chrome.metrics.TickerUsageTracker;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class ChromeTickerButton extends StatefulView
   {
      
      public static const STATE_INFO:String = "info";
      
      public static const STATE_WARNING:String = "warning";
      
      public static const STATE_ERROR:String = "error";
      
      public static const STATE_DEFAULT:String = "default";
      
      private var serverStatusController:IServerStatusProvider = ServerStatusProviderProxy.instance;
      
      private var _button:ButtonX;
      
      private var _ticker:ChromeTicker;
      
      private var _highlight:MovieClipProxy;
      
      private var _tracker:TickerUsageTracker = null;
      
      private var _alreadySeen:Object = new Object();
      
      private var _timerNeeded:Boolean = true;
      
      public function ChromeTickerButton(param1:IContext, param2:ChromeTicker, param3:TickerUsageTracker)
      {
         this._ticker = param2;
         this._ticker.visibilityChanged.add(this.onTickerVisibilityChanged);
         this._tracker = param3;
         super(param1);
         this.serverStatusController.getAllMessagesChanged().add(this.updateAlertMessageArray);
         this.updateAlertMessageArray();
      }
      
      private function updateAlertMessageArray() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BroadcastMessage = null;
         var _loc6_:String = null;
         var _loc1_:ArrayCollection = this.serverStatusController.getAllMessages();
         if(_loc1_ == null)
         {
            setCurrentState(STATE_DEFAULT);
            this._ticker.setVisible(false);
            return;
         }
         this._ticker.setMessages(_loc1_);
         if(this._timerNeeded)
         {
            this._timerNeeded = false;
            setTimeout(this.reapRemovedMessages,150);
         }
         if(_loc1_.length > 0)
         {
            _loc2_ = {};
            _loc2_["error"] = 2;
            _loc2_["warn"] = 1;
            _loc2_["info"] = 0;
            _loc3_ = 0;
            _loc4_ = -1;
            for each(_loc5_ in _loc1_)
            {
               _loc6_ = _loc5_.severity.toLowerCase();
               if(_loc2_.hasOwnProperty(_loc6_))
               {
                  _loc3_ = Math.max(_loc3_,_loc2_[_loc6_]);
                  if(this._alreadySeen[_loc5_.id + _loc5_.messageKey] == null)
                  {
                     this._alreadySeen[_loc5_.id + _loc5_.messageKey] = new ChromeTickerMessageState();
                  }
                  if(!(this._alreadySeen[_loc5_.id + _loc5_.messageKey] as ChromeTickerMessageState).been_read)
                  {
                     _loc4_ = Math.max(_loc4_,_loc2_[_loc6_]);
                  }
               }
            }
            switch(_loc3_)
            {
               case 0:
                  setCurrentState(STATE_INFO);
                  break;
               case 1:
                  setCurrentState(STATE_WARNING);
                  break;
               case 2:
                  setCurrentState(STATE_ERROR);
            }
            if(_loc4_ > -1)
            {
               this._highlight.setVisible(true);
               this._highlight.gotoAndPlay(1);
            }
            if(_loc4_ == 2)
            {
               this._ticker.setVisible(true);
            }
         }
         else
         {
            setCurrentState(STATE_DEFAULT);
            this._ticker.setVisible(this._ticker.getVisible());
            this._highlight.setVisible(false);
         }
      }
      
      private function reapRemovedMessages() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:BroadcastMessage = null;
         for each(_loc1_ in this._ticker.getMessages())
         {
            _loc6_ = _loc1_ as BroadcastMessage;
            (this._alreadySeen[_loc6_.id + _loc6_.messageKey] as ChromeTickerMessageState).keep();
         }
         _loc2_ = new Array();
         for(_loc3_ in this._alreadySeen)
         {
            if((this._alreadySeen[_loc3_] as ChromeTickerMessageState).needs_reaping)
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc4_ in _loc2_)
         {
            delete this._alreadySeen[_loc4_];
         }
         for(_loc5_ in this._alreadySeen)
         {
            (this._alreadySeen[_loc5_] as ChromeTickerMessageState).reap();
         }
         if(this._ticker.getMessages().length == 0)
         {
            this._ticker.setVisible(false);
         }
         this._timerNeeded = true;
      }
      
      override protected function createChildren() : void
      {
         this._button = new ButtonX(this);
         setTimelineChildByName("button",this._button);
         this._button.addEventListener(MouseEvent.CLICK,this.handleButtonClick,false,0,true);
         this._highlight = new MovieClipProxy(this);
         setTimelineChildByName("highlight",this._highlight);
         this._highlight.setVisible(false);
         this._highlight.setMouseEnabled(false);
         this._highlight.setMouseChildren(false);
         assignToolTip(this,ResourceManager.getInstance().getString("resources","alert_ticker_tooltip"));
      }
      
      private function handleButtonClick(param1:MouseEvent) : void
      {
         if(this._ticker.getVisible())
         {
            this._tracker.onHideClick();
         }
         else
         {
            this._tracker.onShowClick();
         }
         this._ticker.setVisible(!this._ticker.getVisible());
      }
      
      private function onTickerVisibilityChanged() : void
      {
         var _loc1_:String = null;
         if(this._ticker.getVisible())
         {
            this._highlight.setVisible(false);
            for(_loc1_ in this._alreadySeen)
            {
               (this._alreadySeen[_loc1_] as ChromeTickerMessageState).read();
            }
         }
      }
   }
}

