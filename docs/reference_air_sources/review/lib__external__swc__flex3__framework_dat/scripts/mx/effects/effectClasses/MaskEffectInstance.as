package mx.effects.effectClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import mx.controls.SWFLoader;
   import mx.core.Container;
   import mx.core.FlexShape;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.EffectManager;
   import mx.effects.Tween;
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   import mx.events.TweenEvent;
   
   use namespace mx_internal;
   
   public class MaskEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var useSnapshotBounds:Boolean = true;
      
      public var scaleEasingFunction:Function;
      
      public var xTo:Number;
      
      [Inspectable(category="General",defaultValue="true")]
      private var _showTarget:Boolean = true;
      
      private var stoppedEarly:Boolean = false;
      
      public var scaleXFrom:Number;
      
      public var scaleYFrom:Number;
      
      protected var effectMask:Shape;
      
      private var _createMaskFunction:Function;
      
      private var moveTween:Tween;
      
      public var scaleYTo:Number;
      
      private var scaleTween:Tween;
      
      public var xFrom:Number;
      
      public var yFrom:Number;
      
      public var targetArea:Rectangle;
      
      protected var targetVisualBounds:Rectangle;
      
      private var invalidateBorder:Boolean = false;
      
      private var origMask:DisplayObject;
      
      private var currentMoveTweenValue:Object;
      
      private var dispatchedStartEvent:Boolean = false;
      
      mx_internal var persistAfterEnd:Boolean = false;
      
      public var moveEasingFunction:Function;
      
      public var yTo:Number;
      
      private var _showExplicitlySet:Boolean = false;
      
      public var scaleXTo:Number;
      
      private var tweenCount:int = 0;
      
      private var origScrollRect:Rectangle;
      
      private var currentScaleTweenValue:Object;
      
      private var effectMaskRefCount:Number = 0;
      
      private var MASK_NAME:String = "_maskEffectMask";
      
      public function MaskEffectInstance(target:Object)
      {
         super(target);
      }
      
      override public function get playheadTime() : Number
      {
         var value:Number = NaN;
         if(Boolean(moveTween))
         {
            value = moveTween.playheadTime;
         }
         else
         {
            if(!Boolean(scaleTween))
            {
               return 0;
            }
            value = scaleTween.playheadTime;
         }
         return value + super.playheadTime;
      }
      
      public function set createMaskFunction(value:Function) : void
      {
         _createMaskFunction = value;
      }
      
      override public function stop() : void
      {
         stoppedEarly = true;
         super.stop();
         if(Boolean(moveTween))
         {
            moveTween.stop();
         }
         if(Boolean(scaleTween))
         {
            scaleTween.stop();
         }
      }
      
      override public function finishEffect() : void
      {
         target.removeEventListener(ResizeEvent.RESIZE,eventHandler);
         if(!persistAfterEnd && !stoppedEarly)
         {
            removeMask();
         }
         super.finishEffect();
      }
      
      private function removeMask() : void
      {
         if(--effectMaskRefCount == 0)
         {
            if(origMask == null || Boolean(origMask) && Boolean(origMask.name != MASK_NAME))
            {
               target.mask = origMask;
            }
            if(Boolean(origScrollRect))
            {
               target.scrollRect = origScrollRect;
            }
            if(target is Container)
            {
               target.rawChildren.removeChild(effectMask);
            }
            else
            {
               target.removeChild(effectMask);
            }
            effectMask = null;
         }
      }
      
      private function initMask() : void
      {
         if(!effectMask)
         {
            if(useSnapshotBounds)
            {
               targetVisualBounds = getVisibleBounds(DisplayObject(target));
            }
            else
            {
               targetVisualBounds = new Rectangle(0,0,target.width,target.height);
            }
            effectMask = createMaskFunction(target,targetVisualBounds);
            if(target is Container)
            {
               target.rawChildren.addChild(effectMask);
            }
            else
            {
               target.addChild(effectMask);
            }
            effectMask.name = MASK_NAME;
            effectMaskRefCount = 0;
         }
         effectMask.x = 0;
         effectMask.y = 0;
         effectMask.alpha = 0.3;
         effectMask.visible = false;
         if(effectMaskRefCount++ == 0)
         {
            if(Boolean(target.mask))
            {
               origMask = target.mask;
            }
            target.mask = effectMask;
            if(Boolean(target.scrollRect))
            {
               origScrollRect = target.scrollRect;
               target.scrollRect = null;
            }
         }
         invalidateBorder = target is Container && Container(target).border != null && Container(target).border is IInvalidating && DisplayObject(Container(target).border).filters != null;
      }
      
      protected function onMoveTweenUpdate(value:Object) : void
      {
         saveTweenValue(value,null);
         if(Boolean(effectMask))
         {
            effectMask.x = value[0];
            effectMask.y = value[1];
         }
         if(invalidateBorder)
         {
            IInvalidating(Container(target).border).invalidateDisplayList();
         }
      }
      
      private function finishTween() : void
      {
         var values:Array = null;
         var value:Object = null;
         if(tweenCount == 0 || --tweenCount == 0)
         {
            EffectManager.endVectorEffect(IUIComponent(target));
            values = [];
            if(Boolean(moveTween))
            {
               value = moveTween.getCurrentValue(duration);
               values.push(value[0]);
               values.push(value[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(Boolean(scaleTween))
            {
               value = scaleTween.getCurrentValue(duration);
               values.push(value[0]);
               values.push(value[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false,values));
            finishRepeat();
         }
      }
      
      override public function startEffect() : void
      {
         initMask();
         target.addEventListener(ResizeEvent.RESIZE,eventHandler);
         super.startEffect();
      }
      
      public function get createMaskFunction() : Function
      {
         return _createMaskFunction != null ? _createMaskFunction : defaultCreateMask;
      }
      
      protected function defaultCreateMask(targ:Object, bounds:Rectangle) : Shape
      {
         var angle:Number = NaN;
         var sin:Number = NaN;
         var cos:Number = NaN;
         var targetWidth:Number = bounds.width / Math.abs(targ.scaleX);
         var targetHeight:Number = bounds.height / Math.abs(targ.scaleY);
         if(targ is SWFLoader)
         {
            targ.validateDisplayList();
            if(Boolean(targ.content))
            {
               targetWidth = Number(targ.contentWidth);
               targetHeight = Number(targ.contentHeight);
            }
         }
         var newMask:Shape = new FlexShape();
         var g:Graphics = newMask.graphics;
         g.beginFill(16776960);
         g.drawRect(0,0,targetWidth,targetHeight);
         g.endFill();
         if(target.rotation == 0)
         {
            newMask.width = targetWidth;
            newMask.height = targetHeight;
         }
         else
         {
            angle = targ.rotation * Math.PI / 180;
            sin = Math.sin(angle);
            cos = Math.cos(angle);
            newMask.width = Math.abs(targetWidth * cos - targetHeight * sin);
            newMask.height = Math.abs(targetWidth * sin + targetHeight * cos);
         }
         return newMask;
      }
      
      private function saveTweenValue(moveValue:Object, scaleValue:Object) : void
      {
         var values:Array = null;
         if(moveValue != null)
         {
            currentMoveTweenValue = moveValue;
         }
         else if(scaleValue != null)
         {
            currentScaleTweenValue = scaleValue;
         }
         if((moveTween == null || currentMoveTweenValue != null) && (scaleTween == null || currentScaleTweenValue != null))
         {
            values = [];
            if(Boolean(currentMoveTweenValue))
            {
               values.push(currentMoveTweenValue[0]);
               values.push(currentMoveTweenValue[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(Boolean(currentScaleTweenValue))
            {
               values.push(currentScaleTweenValue[0]);
               values.push(currentScaleTweenValue[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(!dispatchedStartEvent)
            {
               dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
               dispatchedStartEvent = true;
            }
            dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE,false,false,values));
            currentMoveTweenValue = null;
            currentScaleTweenValue = null;
         }
      }
      
      override mx_internal function set playReversed(value:Boolean) : void
      {
         if(Boolean(moveTween))
         {
            moveTween.playReversed = value;
         }
         if(Boolean(scaleTween))
         {
            scaleTween.playReversed = value;
         }
         super.mx_internal::playReversed = value;
      }
      
      override public function play() : void
      {
         super.play();
         initMaskEffect();
         EffectManager.startVectorEffect(IUIComponent(target));
         if(!isNaN(xFrom) && !isNaN(yFrom) && !isNaN(xTo) && !isNaN(yTo))
         {
            ++tweenCount;
            moveTween = new Tween(this,[xFrom,yFrom],[xTo,yTo],duration,-1,onMoveTweenUpdate,onMoveTweenEnd);
            moveTween.playReversed = playReversed;
            if(moveEasingFunction != null)
            {
               moveTween.easingFunction = moveEasingFunction;
            }
         }
         if(!isNaN(scaleXFrom) && !isNaN(scaleYFrom) && !isNaN(scaleXTo) && !isNaN(scaleYTo))
         {
            ++tweenCount;
            scaleTween = new Tween(this,[scaleXFrom,scaleYFrom],[scaleXTo,scaleYTo],duration,-1,onScaleTweenUpdate,onScaleTweenEnd);
            scaleTween.playReversed = playReversed;
            if(scaleEasingFunction != null)
            {
               scaleTween.easingFunction = scaleEasingFunction;
            }
         }
         dispatchedStartEvent = false;
         if(Boolean(moveTween))
         {
            onMoveTweenUpdate(moveTween.getCurrentValue(0));
         }
         if(Boolean(scaleTween))
         {
            onScaleTweenUpdate(scaleTween.getCurrentValue(0));
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(moveTween))
         {
            moveTween.resume();
         }
         if(Boolean(scaleTween))
         {
            scaleTween.resume();
         }
      }
      
      private function getVisibleBounds(targ:DisplayObject) : Rectangle
      {
         var bitmap:BitmapData = new BitmapData(targ.width + 200,targ.height + 200,true,0);
         var m:Matrix = new Matrix();
         m.translate(100,100);
         bitmap.draw(targ,m);
         var actualBounds:Rectangle = bitmap.getColorBoundsRect(4278190080,0,false);
         actualBounds.x -= 100;
         actualBounds.y -= 100;
         bitmap.dispose();
         if(actualBounds.width < targ.width)
         {
            actualBounds.width = targ.width;
            actualBounds.x = 0;
         }
         if(actualBounds.height < targ.height)
         {
            actualBounds.height = targ.height;
            actualBounds.y = 0;
         }
         return actualBounds;
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
         switch(event.type)
         {
            case "childrenCreationComplete":
            case FlexEvent.CREATION_COMPLETE:
            case FlexEvent.SHOW:
            case Event.ADDED:
            case "resizeEnd":
               showTarget = true;
               break;
            case FlexEvent.HIDE:
            case Event.REMOVED:
            case "resizeStart":
               showTarget = false;
               break;
            case Event.RESIZE:
               useSnapshotBounds = false;
         }
      }
      
      public function set showTarget(value:Boolean) : void
      {
         _showTarget = value;
         _showExplicitlySet = true;
      }
      
      protected function onScaleTweenEnd(value:Object) : void
      {
         onScaleTweenUpdate(value);
         finishTween();
      }
      
      override mx_internal function eventHandler(event:Event) : void
      {
         var tween:Tween = null;
         var elapsed:Number = NaN;
         super.mx_internal::eventHandler(event);
         if(event.type == ResizeEvent.RESIZE)
         {
            tween = moveTween;
            if(!tween && Boolean(scaleTween))
            {
               tween = scaleTween;
            }
            if(Boolean(tween))
            {
               elapsed = getTimer() - tween.startTime;
               if(Boolean(moveTween))
               {
                  Tween.removeTween(moveTween);
               }
               if(Boolean(scaleTween))
               {
                  Tween.removeTween(scaleTween);
               }
               tweenCount = 0;
               removeMask();
               initMask();
               play();
               if(Boolean(moveTween))
               {
                  moveTween.startTime -= elapsed;
                  moveTween.doInterval();
               }
               if(Boolean(scaleTween))
               {
                  scaleTween.startTime -= elapsed;
                  scaleTween.doInterval();
               }
            }
         }
      }
      
      protected function onMoveTweenEnd(value:Object) : void
      {
         onMoveTweenUpdate(value);
         finishTween();
      }
      
      override public function reverse() : void
      {
         super.reverse();
         if(Boolean(moveTween))
         {
            moveTween.reverse();
         }
         if(Boolean(scaleTween))
         {
            scaleTween.reverse();
         }
         super.mx_internal::playReversed = !playReversed;
      }
      
      override public function end() : void
      {
         stopRepeat = true;
         if(Boolean(moveTween))
         {
            moveTween.endTween();
         }
         if(Boolean(scaleTween))
         {
            scaleTween.endTween();
         }
      }
      
      protected function initMaskEffect() : void
      {
         if(Boolean(!_showExplicitlySet) && Boolean(propertyChanges) && propertyChanges.start["visible"] !== undefined)
         {
            _showTarget = !propertyChanges.start["visible"];
         }
      }
      
      protected function onScaleTweenUpdate(value:Object) : void
      {
         saveTweenValue(null,value);
         if(Boolean(effectMask))
         {
            effectMask.scaleX = value[0];
            effectMask.scaleY = value[1];
         }
      }
      
      public function get showTarget() : Boolean
      {
         return _showTarget;
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(moveTween))
         {
            moveTween.pause();
         }
         if(Boolean(scaleTween))
         {
            scaleTween.pause();
         }
      }
   }
}

