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
   import mx.core.FlexShape;
   import mx.core.IContainer;
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
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      protected var effectMask:Shape;
      
      protected var targetVisualBounds:Rectangle;
      
      private var effectMaskRefCount:Number = 0;
      
      private var invalidateBorder:Boolean = false;
      
      private var moveTween:Tween;
      
      private var origMask:DisplayObject;
      
      private var origScrollRect:Rectangle;
      
      private var scaleTween:Tween;
      
      private var tweenCount:int = 0;
      
      private var currentMoveTweenValue:Object;
      
      private var currentScaleTweenValue:Object;
      
      private var MASK_NAME:String = "_maskEffectMask";
      
      private var dispatchedStartEvent:Boolean = false;
      
      private var useSnapshotBounds:Boolean = true;
      
      private var stoppedEarly:Boolean = false;
      
      mx_internal var persistAfterEnd:Boolean = false;
      
      private var _createMaskFunction:Function;
      
      public var moveEasingFunction:Function;
      
      public var scaleEasingFunction:Function;
      
      public var scaleXFrom:Number;
      
      public var scaleXTo:Number;
      
      public var scaleYFrom:Number;
      
      public var scaleYTo:Number;
      
      [Inspectable(category="General",defaultValue="true")]
      private var _showTarget:Boolean = true;
      
      private var _showExplicitlySet:Boolean = false;
      
      public var targetArea:Rectangle;
      
      public var xFrom:Number;
      
      public var xTo:Number;
      
      public var yFrom:Number;
      
      public var yTo:Number;
      
      public function MaskEffectInstance(target:Object)
      {
         super(target);
      }
      
      public function get createMaskFunction() : Function
      {
         return this._createMaskFunction != null ? this._createMaskFunction : this.defaultCreateMask;
      }
      
      public function set createMaskFunction(value:Function) : void
      {
         this._createMaskFunction = value;
      }
      
      override public function get playheadTime() : Number
      {
         var value:Number = NaN;
         if(Boolean(this.moveTween))
         {
            value = this.moveTween.playheadTime;
         }
         else
         {
            if(!Boolean(this.scaleTween))
            {
               return 0;
            }
            value = this.scaleTween.playheadTime;
         }
         return value + super.playheadTime;
      }
      
      override mx_internal function set playReversed(value:Boolean) : void
      {
         if(Boolean(this.moveTween))
         {
            this.moveTween.playReversed = value;
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.playReversed = value;
         }
         super.mx_internal::playReversed = value;
      }
      
      public function get showTarget() : Boolean
      {
         return this._showTarget;
      }
      
      public function set showTarget(value:Boolean) : void
      {
         this._showTarget = value;
         this._showExplicitlySet = true;
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
               this.showTarget = true;
               break;
            case FlexEvent.HIDE:
            case Event.REMOVED:
            case "resizeStart":
               this.showTarget = false;
               break;
            case Event.RESIZE:
               this.useSnapshotBounds = false;
         }
      }
      
      override public function startEffect() : void
      {
         this.initMask();
         target.addEventListener(ResizeEvent.RESIZE,this.eventHandler);
         super.startEffect();
      }
      
      override public function play() : void
      {
         super.play();
         this.initMaskEffect();
         EffectManager.startVectorEffect(IUIComponent(target));
         if(!isNaN(this.xFrom) && !isNaN(this.yFrom) && !isNaN(this.xTo) && !isNaN(this.yTo))
         {
            ++this.tweenCount;
            this.moveTween = new Tween(this,[this.xFrom,this.yFrom],[this.xTo,this.yTo],duration,-1,this.onMoveTweenUpdate,this.onMoveTweenEnd);
            this.moveTween.playReversed = playReversed;
            if(this.moveEasingFunction != null)
            {
               this.moveTween.easingFunction = this.moveEasingFunction;
            }
         }
         if(!isNaN(this.scaleXFrom) && !isNaN(this.scaleYFrom) && !isNaN(this.scaleXTo) && !isNaN(this.scaleYTo))
         {
            ++this.tweenCount;
            this.scaleTween = new Tween(this,[this.scaleXFrom,this.scaleYFrom],[this.scaleXTo,this.scaleYTo],duration,-1,this.onScaleTweenUpdate,this.onScaleTweenEnd);
            this.scaleTween.playReversed = playReversed;
            if(this.scaleEasingFunction != null)
            {
               this.scaleTween.easingFunction = this.scaleEasingFunction;
            }
         }
         this.dispatchedStartEvent = false;
         if(Boolean(this.moveTween))
         {
            this.onMoveTweenUpdate(this.moveTween.getCurrentValue(0));
         }
         if(Boolean(this.scaleTween))
         {
            this.onScaleTweenUpdate(this.scaleTween.getCurrentValue(0));
         }
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(this.moveTween))
         {
            this.moveTween.pause();
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.pause();
         }
      }
      
      override public function stop() : void
      {
         EffectManager.endVectorEffect(IUIComponent(target));
         this.stoppedEarly = true;
         super.stop();
         if(Boolean(this.moveTween))
         {
            this.moveTween.stop();
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.stop();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(this.moveTween))
         {
            this.moveTween.resume();
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.resume();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         if(Boolean(this.moveTween))
         {
            this.moveTween.reverse();
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.reverse();
         }
         super.mx_internal::playReversed = !playReversed;
      }
      
      override public function end() : void
      {
         stopRepeat = true;
         if(Boolean(this.moveTween))
         {
            this.moveTween.endTween();
         }
         if(Boolean(this.scaleTween))
         {
            this.scaleTween.endTween();
         }
      }
      
      override public function finishEffect() : void
      {
         target.removeEventListener(ResizeEvent.RESIZE,this.eventHandler);
         if(!this.persistAfterEnd && !this.stoppedEarly)
         {
            this.removeMask();
         }
         super.finishEffect();
      }
      
      private function initMask() : void
      {
         if(!this.effectMask)
         {
            if(this.useSnapshotBounds)
            {
               this.targetVisualBounds = this.getVisibleBounds(DisplayObject(target));
            }
            else
            {
               this.targetVisualBounds = new Rectangle(0,0,target.width,target.height);
            }
            this.effectMask = this.createMaskFunction(target,this.targetVisualBounds);
            if(target is IContainer)
            {
               target.rawChildren.addChild(this.effectMask);
            }
            else
            {
               target.addChild(this.effectMask);
            }
            this.effectMask.name = this.MASK_NAME;
            this.effectMaskRefCount = 0;
         }
         this.effectMask.x = 0;
         this.effectMask.y = 0;
         this.effectMask.alpha = 0.3;
         this.effectMask.visible = false;
         if(this.effectMaskRefCount++ == 0)
         {
            if(Boolean(target.mask))
            {
               this.origMask = target.mask;
            }
            target.mask = this.effectMask;
            if(Boolean(target.scrollRect))
            {
               this.origScrollRect = target.scrollRect;
               target.scrollRect = null;
            }
         }
         this.invalidateBorder = target is IContainer && "border" in target && target["border"] != null && target["border"] is IInvalidating && DisplayObject(target["border"]).filters != null;
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
      
      protected function initMaskEffect() : void
      {
         if(Boolean(!this._showExplicitlySet) && Boolean(propertyChanges) && propertyChanges.start["visible"] !== undefined)
         {
            this._showTarget = !propertyChanges.start["visible"];
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
      
      protected function onMoveTweenUpdate(value:Object) : void
      {
         this.saveTweenValue(value,null);
         if(Boolean(this.effectMask))
         {
            this.effectMask.x = value[0];
            this.effectMask.y = value[1];
         }
         if(this.invalidateBorder)
         {
            IInvalidating(target["border"]).invalidateDisplayList();
         }
      }
      
      protected function onMoveTweenEnd(value:Object) : void
      {
         this.onMoveTweenUpdate(value);
         this.finishTween();
      }
      
      protected function onScaleTweenUpdate(value:Object) : void
      {
         this.saveTweenValue(null,value);
         if(Boolean(this.effectMask))
         {
            this.effectMask.scaleX = value[0];
            this.effectMask.scaleY = value[1];
         }
      }
      
      protected function onScaleTweenEnd(value:Object) : void
      {
         this.onScaleTweenUpdate(value);
         this.finishTween();
      }
      
      private function finishTween() : void
      {
         var values:Array = null;
         var value:Object = null;
         if(this.tweenCount == 0 || --this.tweenCount == 0)
         {
            EffectManager.endVectorEffect(IUIComponent(target));
            values = [];
            if(Boolean(this.moveTween))
            {
               value = this.moveTween.getCurrentValue(duration);
               values.push(value[0]);
               values.push(value[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(Boolean(this.scaleTween))
            {
               value = this.scaleTween.getCurrentValue(duration);
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
      
      private function removeMask() : void
      {
         if(--this.effectMaskRefCount == 0)
         {
            if(this.origMask == null || Boolean(this.origMask) && Boolean(this.origMask.name != this.MASK_NAME))
            {
               target.mask = this.origMask;
            }
            if(Boolean(this.origScrollRect))
            {
               target.scrollRect = this.origScrollRect;
            }
            if(target is IContainer)
            {
               target.rawChildren.removeChild(this.effectMask);
            }
            else
            {
               target.removeChild(this.effectMask);
            }
            this.effectMask = null;
         }
      }
      
      private function saveTweenValue(moveValue:Object, scaleValue:Object) : void
      {
         var values:Array = null;
         if(moveValue != null)
         {
            this.currentMoveTweenValue = moveValue;
         }
         else if(scaleValue != null)
         {
            this.currentScaleTweenValue = scaleValue;
         }
         if((this.moveTween == null || this.currentMoveTweenValue != null) && (this.scaleTween == null || this.currentScaleTweenValue != null))
         {
            values = [];
            if(Boolean(this.currentMoveTweenValue))
            {
               values.push(this.currentMoveTweenValue[0]);
               values.push(this.currentMoveTweenValue[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(Boolean(this.currentScaleTweenValue))
            {
               values.push(this.currentScaleTweenValue[0]);
               values.push(this.currentScaleTweenValue[1]);
            }
            else
            {
               values.push(null);
               values.push(null);
            }
            if(!this.dispatchedStartEvent)
            {
               dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
               this.dispatchedStartEvent = true;
            }
            dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE,false,false,values));
            this.currentMoveTweenValue = null;
            this.currentScaleTweenValue = null;
         }
      }
      
      override mx_internal function eventHandler(event:Event) : void
      {
         var tween:Tween = null;
         var elapsed:Number = NaN;
         super.mx_internal::eventHandler(event);
         if(event.type == ResizeEvent.RESIZE)
         {
            tween = this.moveTween;
            if(!tween && Boolean(this.scaleTween))
            {
               tween = this.scaleTween;
            }
            if(Boolean(tween))
            {
               elapsed = getTimer() - tween.startTime;
               if(Boolean(this.moveTween))
               {
                  Tween.removeTween(this.moveTween);
               }
               if(Boolean(this.scaleTween))
               {
                  Tween.removeTween(this.scaleTween);
               }
               this.tweenCount = 0;
               this.removeMask();
               this.initMask();
               this.play();
               if(Boolean(this.moveTween))
               {
                  this.moveTween.startTime -= elapsed;
                  this.moveTween.doInterval();
               }
               if(Boolean(this.scaleTween))
               {
                  this.scaleTween.startTime -= elapsed;
                  this.scaleTween.doInterval();
               }
            }
         }
      }
   }
}

