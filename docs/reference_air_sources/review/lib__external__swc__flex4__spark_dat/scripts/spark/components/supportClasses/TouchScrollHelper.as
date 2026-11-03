package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.events.TouchEvent;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import mx.events.TouchInteractionReason;
   import mx.managers.ISystemManager;
   import mx.utils.GetTimerUtil;
   
   [ExcludeClass]
   public class TouchScrollHelper
   {
      
      private static const EVENT_HISTORY_LENGTH:int = 5;
      
      private static const MIN_START_VELOCITY_IPS:Number = 0.8;
      
      private static const MAX_THROW_VELOCITY_IPS:Number = 10;
      
      private static const VELOCITY_WEIGHTS:Vector.<Number> = Vector.<Number>([1,1.33,1.66,2]);
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragFunction:Function = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var throwFunction:Function = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var target:UIComponent;
      
      private var scrollSlop:Number;
      
      private var mouseDownedPoint:Point;
      
      private var mouseDownedDisplayObject:DisplayObject;
      
      private var scrollGestureAnchorPoint:Point;
      
      private var mostRecentDragDeltaX:Number;
      
      private var mostRecentDragDeltaY:Number;
      
      private var mostRecentDragTime:Number;
      
      private var dragTimer:Timer = null;
      
      private var dragScrollPending:Boolean = false;
      
      private var startTime:Number;
      
      private var mouseEventCoordinatesHistory:Vector.<Point>;
      
      private var mouseEventLength:Number = 0;
      
      private var mouseEventTimeHistory:Vector.<int>;
      
      private var isScrolling:Boolean;
      
      private var isIOS:Boolean = false;
      
      private var maxScrollRate:Number = NaN;
      
      private var canScrollHorizontally:Boolean;
      
      private var canScrollVertically:Boolean;
      
      private var mouseListenersInstalled:Boolean = false;
      
      public function TouchScrollHelper()
      {
         super();
         this.isIOS = Capabilities.version.indexOf("IOS") == 0;
         this.mouseEventCoordinatesHistory = new Vector.<Point>(EVENT_HISTORY_LENGTH);
         this.mouseEventTimeHistory = new Vector.<int>(EVENT_HISTORY_LENGTH);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function startScrollWatch(event:Event, canScrollHorizontally:Boolean = true, canScrollVertically:Boolean = true, slop:Number = 0, maxScrollRate:Number = NaN) : void
      {
         var mouseEvent:MouseEvent = null;
         this.startTime = GetTimerUtil.getTimer();
         this.scrollSlop = slop;
         this.maxScrollRate = maxScrollRate;
         this.canScrollHorizontally = canScrollHorizontally;
         this.canScrollVertically = canScrollVertically;
         if(event is MouseEvent && event.type == MouseEvent.MOUSE_DOWN)
         {
            mouseEvent = event as MouseEvent;
            if(!this.isScrolling)
            {
               this.mouseDownedDisplayObject = mouseEvent.target as DisplayObject;
               this.mouseDownedPoint = new Point(mouseEvent.stageX,mouseEvent.stageY);
            }
            this.installMouseListeners();
            if(this.isScrolling)
            {
               this.scrollGestureAnchorPoint = new Point(mouseEvent.stageX,mouseEvent.stageY);
               this.mouseDownedPoint = new Point(mouseEvent.stageX,mouseEvent.stageY);
            }
            this.mouseEventLength = 0;
            this.addMouseEventHistory(mouseEvent.stageX,mouseEvent.stageY,GetTimerUtil.getTimer());
         }
         else if(event is TouchEvent && event.type == TouchEvent.TOUCH_BEGIN)
         {
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stopScrollWatch() : void
      {
         this.uninstallMouseListeners();
      }
      
      private function addMouseEventHistory(stageX:Number, stageY:Number, time:Number) : Point
      {
         var currentPoint:Point = null;
         var dx:Number = stageX - this.mouseDownedPoint.x;
         var dy:Number = stageY - this.mouseDownedPoint.y;
         var currentIndex:int = this.mouseEventLength % EVENT_HISTORY_LENGTH;
         if(Boolean(this.mouseEventCoordinatesHistory[currentIndex]))
         {
            currentPoint = this.mouseEventCoordinatesHistory[currentIndex];
            currentPoint.x = dx;
            currentPoint.y = dy;
         }
         else
         {
            currentPoint = new Point(dx,dy);
            this.mouseEventCoordinatesHistory[currentIndex] = currentPoint;
         }
         this.mouseEventTimeHistory[currentIndex] = this.isIOS ? int(time - this.startTime) : int(GetTimerUtil.getTimer() - this.startTime);
         ++this.mouseEventLength;
         return currentPoint;
      }
      
      private function installMouseListeners() : void
      {
         var sm:ISystemManager = null;
         sm = this.target.systemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.sbRoot_mouseMoveHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.sbRoot_mouseUpHandler,true);
         if(Boolean(sm.stage) && Boolean(sm.isTopLevelRoot()))
         {
            sm.stage.addEventListener(MouseEvent.MOUSE_UP,this.sbRoot_mouseUpHandler);
         }
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.sbRoot_mouseUpHandler);
         this.target.systemManager.deployMouseShields(true);
         this.mouseListenersInstalled = true;
      }
      
      private function uninstallMouseListeners() : void
      {
         var sm:ISystemManager = null;
         sm = this.target.systemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.sbRoot_mouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.sbRoot_mouseUpHandler,true);
         if(Boolean(sm.stage) && Boolean(sm.isTopLevelRoot()))
         {
            sm.stage.removeEventListener(MouseEvent.MOUSE_UP,this.sbRoot_mouseUpHandler);
         }
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.sbRoot_mouseUpHandler);
         this.target.systemManager.deployMouseShields(false);
         this.mouseListenersInstalled = false;
      }
      
      private function sbRoot_mouseMoveHandler(event:MouseEvent) : void
      {
         var shouldBeScrolling:Boolean = false;
         var scrollStartingEvent:TouchInteractionEvent = null;
         var eventAccepted:Boolean = false;
         var scrollStartEvent:TouchInteractionEvent = null;
         var maxAxisDistance:Number = NaN;
         var scrollAnchorDiffX:int = 0;
         var scrollAnchorDiffY:int = 0;
         var normalizedDiff:Point = null;
         var lineLength:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var rate:Number = NaN;
         var mouseDownedDifference:Point = new Point(event.stageX - this.mouseDownedPoint.x,event.stageY - this.mouseDownedPoint.y);
         if(!this.isScrolling)
         {
            shouldBeScrolling = false;
            if(this.canScrollHorizontally && Math.abs(mouseDownedDifference.x) >= this.scrollSlop)
            {
               shouldBeScrolling = true;
            }
            if(this.canScrollVertically && Math.abs(mouseDownedDifference.y) >= this.scrollSlop)
            {
               shouldBeScrolling = true;
            }
            if(shouldBeScrolling)
            {
               scrollStartingEvent = new TouchInteractionEvent(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,true,true);
               scrollStartingEvent.relatedObject = this.target;
               scrollStartingEvent.reason = TouchInteractionReason.SCROLL;
               eventAccepted = this.dispatchBubblingEventOnMouseDownedDisplayObject(scrollStartingEvent);
               if(!eventAccepted)
               {
                  event.updateAfterEvent();
                  this.stopScrollWatch();
                  return;
               }
               scrollStartEvent = new TouchInteractionEvent(TouchInteractionEvent.TOUCH_INTERACTION_START,true,true);
               scrollStartEvent.relatedObject = this.target;
               scrollStartEvent.reason = TouchInteractionReason.SCROLL;
               this.dispatchBubblingEventOnMouseDownedDisplayObject(scrollStartEvent);
               this.isScrolling = true;
               if(this.canScrollHorizontally && this.canScrollVertically)
               {
                  maxAxisDistance = Math.max(Math.abs(mouseDownedDifference.x),Math.abs(mouseDownedDifference.y));
                  if(maxAxisDistance >= this.scrollSlop)
                  {
                     normalizedDiff = mouseDownedDifference.clone();
                     lineLength = this.scrollSlop / maxAxisDistance * mouseDownedDifference.length;
                     normalizedDiff.normalize(lineLength);
                     scrollAnchorDiffX = Math.round(normalizedDiff.x);
                     scrollAnchorDiffY = Math.round(normalizedDiff.y);
                     this.scrollGestureAnchorPoint = new Point(this.mouseDownedPoint.x + scrollAnchorDiffX,this.mouseDownedPoint.y + scrollAnchorDiffY);
                  }
               }
               else if(this.canScrollHorizontally)
               {
                  if(mouseDownedDifference.x >= this.scrollSlop)
                  {
                     this.scrollGestureAnchorPoint = new Point(this.mouseDownedPoint.x + this.scrollSlop,this.mouseDownedPoint.y);
                  }
                  else
                  {
                     this.scrollGestureAnchorPoint = new Point(this.mouseDownedPoint.x - this.scrollSlop,this.mouseDownedPoint.y);
                  }
               }
               else if(this.canScrollVertically)
               {
                  if(mouseDownedDifference.y >= this.scrollSlop)
                  {
                     this.scrollGestureAnchorPoint = new Point(this.mouseDownedPoint.x,this.mouseDownedPoint.y + this.scrollSlop);
                  }
                  else
                  {
                     this.scrollGestureAnchorPoint = new Point(this.mouseDownedPoint.x,this.mouseDownedPoint.y - this.scrollSlop);
                  }
               }
            }
         }
         if(this.isScrolling)
         {
            dx = event.stageX - this.scrollGestureAnchorPoint.x;
            dy = event.stageY - this.scrollGestureAnchorPoint.y;
            if(!this.dragTimer)
            {
               rate = isNaN(this.maxScrollRate) ? 30 : this.maxScrollRate;
               this.dragTimer = new Timer(1000 / rate,0);
               this.dragTimer.addEventListener(TimerEvent.TIMER,this.dragTimerHandler);
            }
            if(!this.dragTimer.running)
            {
               this.addMouseEventHistory(event.stageX,event.stageY,GetTimerUtil.getTimer());
               if(this.dragFunction != null)
               {
                  this.dragFunction(dx,dy);
               }
               event.updateAfterEvent();
               if(!isNaN(this.maxScrollRate))
               {
                  this.dragTimer.start();
                  this.dragScrollPending = false;
               }
            }
            else
            {
               this.mostRecentDragDeltaX = dx;
               this.mostRecentDragDeltaY = dy;
               this.mostRecentDragTime = GetTimerUtil.getTimer();
               this.dragScrollPending = true;
            }
         }
      }
      
      private function dragTimerHandler(event:TimerEvent) : void
      {
         if(this.dragScrollPending)
         {
            this.addMouseEventHistory(this.mostRecentDragDeltaX + this.scrollGestureAnchorPoint.x,this.mostRecentDragDeltaY + this.scrollGestureAnchorPoint.y,this.mostRecentDragTime);
            if(this.dragFunction != null)
            {
               this.dragFunction(this.mostRecentDragDeltaX,this.mostRecentDragDeltaY);
            }
            event.updateAfterEvent();
            this.dragScrollPending = false;
         }
         else
         {
            this.dragTimer.stop();
         }
      }
      
      private function sbRoot_mouseUpHandler(event:Event) : void
      {
         var nextIndex:int = 0;
         if(!this.mouseListenersInstalled)
         {
            return;
         }
         this.uninstallMouseListeners();
         if(!this.isScrolling)
         {
            return;
         }
         if(Boolean(this.dragTimer))
         {
            if(this.dragScrollPending)
            {
               this.addMouseEventHistory(this.mostRecentDragDeltaX + this.scrollGestureAnchorPoint.x,this.mostRecentDragDeltaY + this.scrollGestureAnchorPoint.y,this.mostRecentDragTime);
               if(this.dragFunction != null)
               {
                  this.dragFunction(this.mostRecentDragDeltaX,this.mostRecentDragDeltaY);
               }
               if(event is MouseEvent)
               {
                  MouseEvent(event).updateAfterEvent();
               }
            }
            this.dragTimer.stop();
            this.dragTimer.removeEventListener(TimerEvent.TIMER,this.dragTimerHandler);
            this.dragTimer = null;
         }
         var currentTime:Number = Number(GetTimerUtil.getTimer());
         var averageDt:Number = 0;
         var len:int = this.mouseEventLength > EVENT_HISTORY_LENGTH ? EVENT_HISTORY_LENGTH : int(this.mouseEventLength);
         var startIndex:int = (this.mouseEventLength - len) % EVENT_HISTORY_LENGTH;
         var endIndex:int = (this.mouseEventLength - 1) % EVENT_HISTORY_LENGTH;
         var currentIndex:int = startIndex;
         while(currentIndex != endIndex)
         {
            nextIndex = (currentIndex + 1) % EVENT_HISTORY_LENGTH;
            averageDt += this.mouseEventTimeHistory[nextIndex] - this.mouseEventTimeHistory[currentIndex];
            currentIndex = nextIndex;
         }
         averageDt /= len - 1;
         var minVelocityPixels:Number = MIN_START_VELOCITY_IPS * Capabilities.screenDPI / 1000;
         var throwVelocity:Point = this.calculateThrowVelocity();
         var finalDragVel:Point = this.calculateFinalDragVelocity(100);
         if(this.isIOS)
         {
            throwVelocity = finalDragVel;
         }
         if(throwVelocity.length <= minVelocityPixels)
         {
            throwVelocity.x = 0;
            throwVelocity.y = 0;
         }
         if(finalDragVel.length <= minVelocityPixels)
         {
            throwVelocity.x = 0;
            throwVelocity.y = 0;
         }
         if(this.throwFunction != null)
         {
            this.throwFunction(throwVelocity.x,throwVelocity.y);
         }
      }
      
      private function calculateThrowVelocity() : Point
      {
         var nextIndex:int = 0;
         var dt:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var len:int = this.mouseEventLength > EVENT_HISTORY_LENGTH ? EVENT_HISTORY_LENGTH : int(this.mouseEventLength);
         var startIndex:int = (this.mouseEventLength - len) % EVENT_HISTORY_LENGTH;
         var endIndex:int = (this.mouseEventLength - 1) % EVENT_HISTORY_LENGTH;
         var weightedSumX:Number = 0;
         var weightedSumY:Number = 0;
         var totalWeight:Number = 0;
         var currentIndex:int = startIndex;
         var i:int = 0;
         while(currentIndex != endIndex)
         {
            nextIndex = (currentIndex + 1) % EVENT_HISTORY_LENGTH;
            dt = this.mouseEventTimeHistory[nextIndex] - this.mouseEventTimeHistory[currentIndex];
            dx = this.mouseEventCoordinatesHistory[nextIndex].x - this.mouseEventCoordinatesHistory[currentIndex].x;
            dy = this.mouseEventCoordinatesHistory[nextIndex].y - this.mouseEventCoordinatesHistory[currentIndex].y;
            if(dt != 0)
            {
               weightedSumX += dx / dt * VELOCITY_WEIGHTS[i];
               weightedSumY += dy / dt * VELOCITY_WEIGHTS[i];
               totalWeight += VELOCITY_WEIGHTS[i];
            }
            currentIndex = nextIndex;
            i++;
         }
         if(totalWeight == 0)
         {
            return new Point(0,0);
         }
         var maxPixelsPerMS:Number = MAX_THROW_VELOCITY_IPS * Capabilities.screenDPI / 1000;
         var velX:Number = Math.min(maxPixelsPerMS,Math.max(-maxPixelsPerMS,weightedSumX / totalWeight));
         var velY:Number = Math.min(maxPixelsPerMS,Math.max(-maxPixelsPerMS,weightedSumY / totalWeight));
         return new Point(velX,velY);
      }
      
      private function calculateFinalDragVelocity(time:Number) : Point
      {
         var previousIndex:int = 0;
         var _dt:Number = NaN;
         var _dx:Number = NaN;
         var _dy:Number = NaN;
         var interpFraction:Number = NaN;
         var maxPixelsPerMS:Number = NaN;
         var velX:Number = NaN;
         var velY:Number = NaN;
         var len:int = this.mouseEventLength > EVENT_HISTORY_LENGTH ? EVENT_HISTORY_LENGTH : int(this.mouseEventLength);
         var startIndex:int = (this.mouseEventLength - len) % EVENT_HISTORY_LENGTH;
         var endIndex:int = (this.mouseEventLength - 1) % EVENT_HISTORY_LENGTH;
         var currentIndex:int = endIndex;
         var dt:Number = 0;
         var dx:Number = 0;
         var dy:Number = 0;
         while(time > 0 && currentIndex != startIndex)
         {
            previousIndex = currentIndex - 1;
            if(previousIndex < 0)
            {
               previousIndex += EVENT_HISTORY_LENGTH;
            }
            _dt = this.mouseEventTimeHistory[currentIndex] - this.mouseEventTimeHistory[previousIndex];
            _dx = this.mouseEventCoordinatesHistory[currentIndex].x - this.mouseEventCoordinatesHistory[previousIndex].x;
            _dy = this.mouseEventCoordinatesHistory[currentIndex].y - this.mouseEventCoordinatesHistory[previousIndex].y;
            if(_dt > time)
            {
               interpFraction = time / _dt;
               _dx *= interpFraction;
               _dy *= interpFraction;
               _dt = time;
            }
            time -= _dt;
            dt += _dt;
            dx += _dx;
            dy += _dy;
            currentIndex = previousIndex;
         }
         if(dt == 0)
         {
            return new Point(0,0);
         }
         if(this.isIOS)
         {
            maxPixelsPerMS = MAX_THROW_VELOCITY_IPS * Capabilities.screenDPI / 1000;
            velX = Math.min(maxPixelsPerMS,Math.max(-maxPixelsPerMS,dx / dt));
            velY = Math.min(maxPixelsPerMS,Math.max(-maxPixelsPerMS,dy / dt));
            return new Point(velX,velY);
         }
         return new Point(dx / dt,dy / dt);
      }
      
      private function dispatchBubblingEventOnMouseDownedDisplayObject(event:Event) : Boolean
      {
         var eventAccepted:Boolean = true;
         if(Boolean(this.mouseDownedDisplayObject))
         {
            eventAccepted &&= this.mouseDownedDisplayObject.dispatchEvent(event);
            if(!this.mouseDownedDisplayObject.stage)
            {
               if(Boolean(this.target) && !this.target.contains(this.mouseDownedDisplayObject))
               {
                  eventAccepted &&= Boolean(this.target.dispatchEvent(event));
               }
            }
         }
         else
         {
            eventAccepted &&= Boolean(this.target.dispatchEvent(event));
         }
         return eventAccepted;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function endTouchScroll() : void
      {
         var scrollEndEvent:TouchInteractionEvent = null;
         if(this.isScrolling)
         {
            this.isScrolling = false;
            scrollEndEvent = new TouchInteractionEvent(TouchInteractionEvent.TOUCH_INTERACTION_END,true);
            scrollEndEvent.relatedObject = this.target;
            scrollEndEvent.reason = TouchInteractionReason.SCROLL;
            this.dispatchBubblingEventOnMouseDownedDisplayObject(scrollEndEvent);
         }
      }
   }
}

