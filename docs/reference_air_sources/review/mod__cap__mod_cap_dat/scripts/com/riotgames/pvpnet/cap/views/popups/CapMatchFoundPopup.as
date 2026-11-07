package com.riotgames.pvpnet.cap.views.popups
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CapMatchFoundPopup extends SpriteProxy
   {
      
      private var _subTitleText:TextFieldProxy;
      
      private var _currentSeconds:int = 5;
      
      private var _titleText:TextFieldProxy;
      
      private var _countdownTimer:Timer;
      
      private var _timerText:TextFieldProxy;
      
      public function CapMatchFoundPopup(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("CapMatchFoundPopup");
         this.startCountdown();
      }
      
      private function removeTimer() : void
      {
         if(this._countdownTimer)
         {
            this._countdownTimer.stop();
            this._countdownTimer.removeEventListener(TimerEvent.TIMER,this.updateCountdown);
            this._countdownTimer = null;
         }
      }
      
      override public function destroy() : void
      {
         this.removeTimer();
         super.destroy();
      }
      
      private function startCountdown() : void
      {
         this._countdownTimer = new Timer(1000);
         this._countdownTimer.start();
         this._countdownTimer.addEventListener(TimerEvent.TIMER,this.updateCountdown);
      }
      
      private function updateCountdown(param1:TimerEvent) : void
      {
         --this._currentSeconds;
         this.updateCountdownText();
         if(this._currentSeconds <= 0)
         {
            this.removeTimer();
         }
      }
      
      override protected function createChildren() : void
      {
         this._titleText = new TextFieldProxy(this);
         setTimelineChildByName("titleText",this._titleText);
         this._titleText.setText(CapLocaleUtil.getResourceString("gf_matchFound_title","Match found!"));
         this._subTitleText = new TextFieldProxy(this);
         setTimelineChildByName("subTitleText",this._subTitleText);
         this._subTitleText.setText(CapLocaleUtil.getResourceString("gf_matchFound_subTitle","Game is about to start in..."));
         this._timerText = new TextFieldProxy(this);
         setTimelineChildByName("timerText",this._timerText);
         this.updateCountdownText();
         super.createChildren();
      }
      
      private function updateCountdownText() : void
      {
         this._timerText.setText(String(this._currentSeconds));
      }
   }
}

