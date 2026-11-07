package blix.components.list
{
   import blix.IDestructible;
   import blix.components.scroll.ScrollBarBase;
   import blix.effects.easing.IEaser;
   import blix.effects.easing.Sine;
   import blix.frame.getEnterFrame;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class SnappingBehavior implements IDestructible
   {
      
      public var snapInterval:Number = 0;
      
      public var positionTweenDuration:Number = 0.2;
      
      public var positionTweenEase:IEaser = new Sine();
      
      protected var positionTweenFrom:Number;
      
      protected var positionTweenTo:Number;
      
      protected var positionTweenProgress:Number = 0;
      
      protected var positionTweenStartTime:int;
      
      protected var snapAfterMouseWheelIntervalId:int;
      
      private var dataGroup:DataGroup;
      
      public function SnappingBehavior(param1:DataGroup)
      {
         super();
         this.dataGroup = param1;
      }
      
      public function tossStartHandler() : void
      {
         this.stopTween();
      }
      
      public function tossEndHandler() : void
      {
         this.snapToNearestInterval();
      }
      
      public function mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         this.stopTween();
         if(Boolean(this.snapAfterMouseWheelIntervalId))
         {
            clearTimeout(this.snapAfterMouseWheelIntervalId);
            this.snapAfterMouseWheelIntervalId = 0;
         }
         if(this.snapInterval > 0)
         {
            if(param1.delta < 0)
            {
               _loc2_ = 2;
            }
            else if(param1.delta > 0)
            {
               _loc2_ = 0;
            }
            else
            {
               _loc2_ = 1;
            }
            this.snapAfterMouseWheelIntervalId = setTimeout(this.snapToNearestInterval,400,_loc2_);
         }
      }
      
      public function scrollDraggingChangedHandler(param1:ScrollBarBase, param2:Boolean) : void
      {
         if(param2)
         {
            this.stopTween();
         }
         else
         {
            this.snapToNearestInterval();
         }
      }
      
      public function snapToNearestInterval(param1:uint = 1) : void
      {
         var _loc2_:Number = NaN;
         if(this.snapInterval == 0)
         {
            return;
         }
         if(this.dataGroup.getVisibleBottomPosition() < this.dataGroup.getDataProvider().getLength() - 1 - 0.01)
         {
            _loc2_ = this.dataGroup.getPosition() / this.snapInterval;
            if(param1 == 0)
            {
               _loc2_ = Math.floor(_loc2_);
            }
            else if(param1 == 1)
            {
               _loc2_ = Math.round(_loc2_);
            }
            else if(param1 == 2)
            {
               _loc2_ = Math.ceil(_loc2_);
            }
            _loc2_ *= this.snapInterval;
            this.tweenToPosition(_loc2_);
         }
      }
      
      public function tweenToPosition(param1:Number) : void
      {
         this.positionTweenProgress = 0;
         this.positionTweenStartTime = getTimer();
         this.positionTweenFrom = this.dataGroup.getPosition();
         this.positionTweenTo = param1;
         getEnterFrame().add(this.targetPositionTweenHandler);
         this.targetPositionTweenHandler();
      }
      
      public function stopTween() : void
      {
         this.positionTweenProgress = 0;
         getEnterFrame().remove(this.targetPositionTweenHandler);
      }
      
      protected function targetPositionTweenHandler() : void
      {
         var _loc4_:Number = NaN;
         var _loc1_:Number = getTimer() - this.positionTweenStartTime;
         this.positionTweenProgress = _loc1_ / this.positionTweenDuration / 1000;
         if(this.positionTweenProgress > 1)
         {
            this.positionTweenProgress = 1;
         }
         var _loc2_:Number = this.positionTweenTo - this.positionTweenFrom;
         var _loc3_:Number = this.positionTweenEase.ease(this.positionTweenProgress);
         if(this.positionTweenProgress >= 1)
         {
            this.dataGroup.setPosition(this.positionTweenTo);
            this.stopTween();
         }
         else
         {
            _loc4_ = this.positionTweenFrom + _loc2_ * _loc3_;
            this.dataGroup.setPosition(_loc4_);
         }
      }
      
      public function destroy() : void
      {
         this.stopTween();
      }
   }
}

