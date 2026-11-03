package com.riotgames.platform.gameclient.tooltips
{
   import flash.display.NativeWindowSystemChrome;
   import flash.display.NativeWindowType;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SummonerTooltipManager extends EventDispatcher
   {
      
      private static const DISPLAY_DELAY:int = 500;
      
      private static const REMOVE_DELAY:int = 50;
      
      private var removeTimer:Timer;
      
      private var currentSummonerId:String;
      
      private var displayTimer:Timer;
      
      private var yPos:Number;
      
      private var xPos:Number;
      
      private var infoWindow:SummonerToolTip;
      
      public function SummonerTooltipManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.displayTimer = new Timer(DISPLAY_DELAY,1);
         this.displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDisplayTimerComplete,false,0,true);
         this.removeTimer = new Timer(REMOVE_DELAY,1);
         this.removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRemoveTimerComplete,false,0,true);
      }
      
      private function onDisplayTimerComplete(param1:TimerEvent) : void
      {
         this.infoWindow = new SummonerToolTip();
         this.infoWindow.info = this.currentSummonerId;
         this.infoWindow.systemChrome = NativeWindowSystemChrome.NONE;
         this.infoWindow.type = NativeWindowType.LIGHTWEIGHT;
         this.infoWindow.transparent = true;
         this.infoWindow.open(true);
         this.infoWindow.move(this.xPos,this.yPos);
      }
      
      public function showToolTip(param1:String, param2:Number, param3:Number) : void
      {
         if(param1 != this.currentSummonerId)
         {
            if(this.displayTimer.running)
            {
               this.displayTimer.stop();
            }
            this.currentSummonerId = param1;
            if(this.infoWindow)
            {
               this.infoWindow.close();
               this.infoWindow = null;
            }
            this.xPos = param2;
            this.yPos = param3;
            this.displayTimer.start();
         }
      }
      
      private function onRemoveTimerComplete(param1:TimerEvent) : void
      {
         if(Boolean(this.infoWindow) && !this.infoWindow.hovered)
         {
            this.infoWindow.close();
            this.infoWindow = null;
         }
      }
      
      public function removeToolTip() : void
      {
         if(this.displayTimer.running)
         {
            this.displayTimer.stop();
         }
         if(this.infoWindow)
         {
            if(this.removeTimer.running)
            {
               this.removeTimer.stop();
            }
            this.removeTimer.start();
         }
         this.currentSummonerId = null;
      }
   }
}

