package blix.signals
{
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class SteadyFrameSignal extends Signal
   {
      
      private var maxTime:uint;
      
      private var resume:ListenerListItem;
      
      public function SteadyFrameSignal(param1:uint = 20)
      {
         super();
         this.maxTime = param1;
      }
      
      override public function dispatch(... rest) : void
      {
         var _loc3_:ListenerListItem = null;
         var _loc4_:int = 0;
         var _loc2_:ListenerListItem = this.resume || listeners.getHead();
         this.resume = null;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc5_:ListenerListItem = listeners.getTail();
         var _loc6_:int = getTimer();
         var _loc7_:uint = uint(rest.length);
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            if(_loc2_.isOnce)
            {
               delete listenerDict[_loc2_.func];
               listeners.removeItem(_loc2_);
            }
            if(_loc7_ == 0 || !_loc2_.forceParams && _loc2_.func.length == 0)
            {
               _loc2_.func();
            }
            else if(_loc7_ == 1)
            {
               _loc2_.func(rest[0]);
            }
            else if(_loc7_ == 2)
            {
               _loc2_.func(rest[0],rest[1]);
            }
            else
            {
               _loc2_.func.apply(null,rest);
            }
            if(_loc2_ == _loc5_)
            {
               _loc3_ = null;
               break;
            }
            _loc2_ = _loc3_;
            _loc4_ = getTimer() - _loc6_;
            if(_loc4_ >= this.maxTime)
            {
               setTimeout(this.resumeDispatch,10,_loc3_,rest);
               break;
            }
         }
      }
      
      private function resumeDispatch(param1:ListenerListItem, param2:Array) : void
      {
         this.resume = param1;
         this.dispatch.apply(null,param2);
      }
   }
}

