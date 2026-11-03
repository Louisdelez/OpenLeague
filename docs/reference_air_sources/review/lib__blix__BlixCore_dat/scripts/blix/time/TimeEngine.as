package blix.time
{
   import blix.ds.LinkedList;
   import blix.frame.getEnterFrame;
   import flash.utils.getTimer;
   
   public final class TimeEngine
   {
      
      private static const GC_INTERVAL:int = 60;
      
      protected var list:LinkedList = new LinkedList();
      
      public var timeScale:Number = 1;
      
      private var _paused:Boolean = true;
      
      private var lastUpdateTime:int;
      
      private var gcCount:int = 60;
      
      private var pausedTime:int;
      
      private var totalPausedTime:int;
      
      private var isRunning:Boolean;
      
      public function TimeEngine()
      {
         super();
         this.lastUpdateTime = getTimer();
         this.setPaused(false);
      }
      
      public function registerItem(param1:TimeListItem) : void
      {
         this.list.addItem(param1);
         this.resetTimeNode(param1);
         this.refreshEnterFrameRequired();
      }
      
      public function unregisterItem(param1:TimeListItem) : void
      {
         this.list.removeItem(param1);
         this.refreshEnterFrameRequired();
      }
      
      protected function resetTimeNode(param1:TimeListItem) : void
      {
         if(this._paused)
         {
            param1.registrationTime = this.pausedTime;
         }
         else
         {
            param1.registrationTime = getTimer();
         }
      }
      
      private function refreshEnterFrameRequired() : void
      {
         if(this._paused || this.list.getIsEmpty())
         {
            if(this.isRunning)
            {
               this.isRunning = false;
               getEnterFrame().remove(this.enterFrameHandler);
            }
         }
         else if(!this.isRunning)
         {
            this.isRunning = true;
            getEnterFrame().add(this.enterFrameHandler);
         }
      }
      
      public function getPaused() : Boolean
      {
         return this._paused;
      }
      
      public function setPaused(param1:Boolean) : void
      {
         if(this._paused == param1)
         {
            return;
         }
         this._paused = param1;
         if(param1)
         {
            this.pausedTime = getTimer();
         }
         else if(this.pausedTime > 0)
         {
            this.totalPausedTime += getTimer() - this.pausedTime;
         }
         this.refreshEnterFrameRequired();
      }
      
      private function enterFrameHandler() : void
      {
         var _loc4_:TimeListItem = null;
         --this.gcCount;
         var _loc1_:int = getTimer();
         this.lastUpdateTime += (_loc1_ - this.lastUpdateTime) * this.timeScale;
         if(this.totalPausedTime > 0)
         {
            this.lastUpdateTime -= this.totalPausedTime * this.timeScale;
            this.totalPausedTime = 0;
         }
         var _loc2_:TimeListItem = this.list.getHead();
         var _loc3_:TimeListItem = this.list.getTail();
         while(_loc2_ != null)
         {
            if(_loc2_.remove)
            {
               _loc2_ = _loc2_.next;
            }
            else
            {
               _loc4_ = _loc2_.next;
               _loc2_.target.setCurrentTime(this.lastUpdateTime - _loc2_.registrationTime,_loc2_);
               if(_loc2_ == _loc3_)
               {
                  break;
               }
               _loc2_ = _loc4_;
            }
         }
         if(this.gcCount <= 0)
         {
            this.gcCount = GC_INTERVAL;
            _loc2_ = this.list.getHead();
            while(_loc2_ != null)
            {
               if(_loc2_.remove)
               {
                  this.unregisterItem(_loc2_);
               }
               _loc2_ = _loc2_.next;
            }
         }
      }
      
      public function removeAll() : void
      {
         this.list.removeAll();
      }
   }
}

