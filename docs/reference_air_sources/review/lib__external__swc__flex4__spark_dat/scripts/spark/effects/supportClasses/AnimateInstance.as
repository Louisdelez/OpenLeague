package spark.effects.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.effects.Effect;
   import mx.effects.EffectInstance;
   import mx.events.EffectEvent;
   import mx.managers.SystemManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.IStyleClient;
   import spark.effects.animation.Animation;
   import spark.effects.animation.IAnimationTarget;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.interpolation.IInterpolator;
   import spark.primitives.supportClasses.GraphicElement;
   
   [ResourceBundle("sparkEffects")]
   public class AnimateInstance extends EffectInstance implements IAnimationTarget
   {
      
      public var animation:Animation;
      
      private var isStyleMap:Object = new Object();
      
      private var _seekTime:Number = 0;
      
      private var reverseAnimation:Boolean;
      
      private var needsRemoval:Boolean;
      
      private var numUpdateListeners:int = 0;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var oldWidth:Number;
      
      private var oldHeight:Number;
      
      private var disabledConstraintsMap:Object;
      
      private var _motionPaths:Vector.<MotionPath>;
      
      protected var autoRemoveTarget:Boolean = false;
      
      public var disableLayout:Boolean;
      
      private var _easer:IEaser;
      
      private var _interpolator:IInterpolator;
      
      private var _repeatBehavior:String;
      
      private var constraintsHolder:Object;
      
      public function AnimateInstance(target:Object)
      {
         super(target);
      }
      
      override public function set suspendBackgroundProcessing(value:Boolean) : void
      {
      }
      
      public function get motionPaths() : Vector.<MotionPath>
      {
         return this._motionPaths;
      }
      
      public function set motionPaths(value:Vector.<MotionPath>) : void
      {
         if(!this._motionPaths)
         {
            this._motionPaths = value;
         }
      }
      
      public function set easer(value:IEaser) : void
      {
         this._easer = value;
      }
      
      public function get easer() : IEaser
      {
         return this._easer;
      }
      
      public function set interpolator(value:IInterpolator) : void
      {
         this._interpolator = value;
      }
      
      public function get interpolator() : IInterpolator
      {
         return this._interpolator;
      }
      
      public function set repeatBehavior(value:String) : void
      {
         this._repeatBehavior = value;
      }
      
      public function get repeatBehavior() : String
      {
         return this._repeatBehavior;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set playReversed(value:Boolean) : void
      {
         super.playReversed = value;
         if(value && Boolean(this.animation))
         {
            this.animation.reverse();
         }
         this.reverseAnimation = value;
      }
      
      override public function get playheadTime() : Number
      {
         return Boolean(this.animation) ? this.animation.playheadTime : this._seekTime;
      }
      
      override public function set playheadTime(value:Number) : void
      {
         if(Boolean(this.animation))
         {
            this.animation.playheadTime = value;
         }
         this._seekTime = value;
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(this.animation))
         {
            this.animation.pause();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(this.animation))
         {
            this.animation.stop();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(this.animation))
         {
            this.animation.resume();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         if(Boolean(this.animation))
         {
            this.animation.reverse();
         }
         this.reverseAnimation = !this.reverseAnimation;
      }
      
      override public function end() : void
      {
         if(Boolean(this.animation))
         {
            this.animation.end();
            this.animation = null;
         }
         super.end();
      }
      
      override public function startEffect() : void
      {
         if(target is UIComponent)
         {
            UIComponent(target).effectStarted(this);
         }
         if(this.autoRemoveTarget)
         {
            this.addDisappearingTarget();
         }
         this.play();
      }
      
      override public function play() : void
      {
         var addWidthMP:Boolean = false;
         var addHeightMP:Boolean = false;
         var i:int = 0;
         var j:int = 0;
         var timer:Timer = null;
         var mp:MotionPath = null;
         var keyframes:Vector.<Keyframe> = null;
         super.play();
         if(!this.motionPaths || this.motionPaths.length == 0)
         {
            timer = new Timer(duration,1);
            timer.addEventListener(TimerEvent.TIMER,this.noopAnimationHandler);
            timer.start();
            return;
         }
         this.isStyleMap = new Array(this.motionPaths.length);
         for(i = 0; i < this.motionPaths.length; i++)
         {
            mp = MotionPath(this.motionPaths[i]);
            keyframes = mp.keyframes;
            if(keyframes)
            {
               if(propertyChanges != null && (mp.property == "left" || mp.property == "right" || mp.property == "top" || mp.property == "bottom" || mp.property == "percentWidth" || mp.property == "percentHeight" || mp.property == "horizontalCenter" || mp.property == "verticalCenter"))
               {
                  if(!this.isValidValue(propertyChanges.start[mp.property]) || !this.isValidValue(propertyChanges.end[mp.property]) && keyframes.length == 2 && !this.isValidValue(keyframes[0].value) && !this.isValidValue(keyframes[1].value))
                  {
                     if(mp.property == "percentWidth")
                     {
                        mp.property = "width";
                     }
                     else if(mp.property == "percentHeight")
                     {
                        mp.property = "height";
                     }
                     else if(mp.property == "left" || mp.property == "right" || mp.property == "horizontalCenter")
                     {
                        if(!this.disabledConstraintsMap)
                        {
                           this.disabledConstraintsMap = new Object();
                        }
                        this.disabledConstraintsMap[mp.property] = true;
                        mp.property = "x";
                        if(this.isValidValue(propertyChanges.start["width"]) && this.isValidValue(propertyChanges.end["width"]) && propertyChanges.start["width"] != propertyChanges.end["width"])
                        {
                           addWidthMP = true;
                        }
                     }
                     else
                     {
                        if(!this.disabledConstraintsMap)
                        {
                           this.disabledConstraintsMap = new Object();
                        }
                        this.disabledConstraintsMap[mp.property] = true;
                        mp.property = "y";
                        if(this.isValidValue(propertyChanges.start["height"]) && this.isValidValue(propertyChanges.end["height"]) && propertyChanges.start["height"] != propertyChanges.end["height"])
                        {
                           addHeightMP = true;
                        }
                     }
                  }
               }
               if(Boolean(this.interpolator))
               {
                  mp.interpolator = this.interpolator;
               }
               if(duration > 0)
               {
                  for(j = 0; j < keyframes.length; j++)
                  {
                     if(!isNaN(keyframes[j].time))
                     {
                        duration = Math.max(duration,keyframes[j].time);
                     }
                  }
               }
            }
         }
         if(addWidthMP)
         {
            this.motionPaths.push(new SimpleMotionPath("width"));
         }
         if(addHeightMP)
         {
            this.motionPaths.push(new SimpleMotionPath("height"));
         }
         this.animation = new Animation(duration);
         this.animation.animationTarget = this;
         this.animation.motionPaths = this.motionPaths;
         if(this.reverseAnimation)
         {
            this.animation.playReversed = true;
         }
         this.animation.interpolator = this.interpolator;
         this.animation.repeatCount = repeatCount;
         this.animation.repeatDelay = repeatDelay;
         this.animation.repeatBehavior = this.repeatBehavior;
         this.animation.easer = this.easer;
         this.animation.startDelay = startDelay;
         this.animation.play();
         if(this._seekTime > 0)
         {
            this.animation.playheadTime = this._seekTime;
         }
      }
      
      protected function applyValues(anim:Animation) : void
      {
         var prop:String = null;
         for(var i:int = 0; i < this.motionPaths.length; i++)
         {
            prop = this.motionPaths[i].property;
            this.setValue(prop,anim.currentValue[prop]);
         }
      }
      
      private function isValidValue(value:Object) : Boolean
      {
         return value is Number && !isNaN(Number(value)) || !(value is Number) && value !== null;
      }
      
      private function finalizeValues() : Boolean
      {
         var j:int = 0;
         var prevValue:Object = null;
         var motionPath:MotionPath = null;
         var keyframes:Vector.<Keyframe> = null;
         var kf:Keyframe = null;
         var changedValues:Boolean = false;
         for(var i:int = 0; i < this.motionPaths.length; i++)
         {
            motionPath = MotionPath(this.motionPaths[i]);
            keyframes = motionPath.keyframes;
            if(!(!keyframes || keyframes.length == 0))
            {
               if(!this.isValidValue(keyframes[0].value))
               {
                  if(keyframes.length > 0 && this.isValidValue(keyframes[1].valueBy) && this.isValidValue(keyframes[1].value))
                  {
                     keyframes[0].value = motionPath.interpolator.decrement(keyframes[1].value,keyframes[1].valueBy);
                  }
                  else if((Boolean(playReversed || Effect(effect).transitionInterruption)) && Boolean(propertyChanges) && propertyChanges.start[motionPath.property] !== undefined)
                  {
                     keyframes[0].value = propertyChanges.start[motionPath.property];
                  }
                  else
                  {
                     keyframes[0].value = this.getCurrentValue(motionPath.property);
                  }
               }
               prevValue = keyframes[0].value;
               for(j = 1; j < keyframes.length; j++)
               {
                  kf = Keyframe(keyframes[j]);
                  if(!this.isValidValue(kf.value))
                  {
                     if(this.isValidValue(kf.valueBy))
                     {
                        kf.value = motionPath.interpolator.increment(prevValue,kf.valueBy);
                     }
                     else if(j <= keyframes.length - 2 && this.isValidValue(keyframes[j + 1].value) && this.isValidValue(keyframes[j + 1].valueBy))
                     {
                        kf.value = motionPath.interpolator.decrement(keyframes[j + 1].value,keyframes[j + 1].valueBy);
                     }
                     else if(Boolean(j == keyframes.length - 1) && Boolean(propertyChanges) && propertyChanges.end[motionPath.property] !== undefined)
                     {
                        kf.value = propertyChanges.end[motionPath.property];
                     }
                     else
                     {
                        kf.value = prevValue;
                     }
                  }
                  prevValue = kf.value;
               }
            }
         }
         return changedValues;
      }
      
      protected function setupConstraintAnimation(constraintName:String) : void
      {
         var startVal:* = propertyChanges.start[constraintName];
         var endVal:* = propertyChanges.end[constraintName];
         if(startVal !== undefined && endVal !== undefined && startVal !== null && endVal !== null && !isNaN(startVal) && !isNaN(endVal) && startVal != endVal)
         {
            this.motionPaths.push(new SimpleMotionPath(constraintName,startVal,endVal));
         }
      }
      
      public function animationStart(animation:Animation) : void
      {
         var constraint:String = null;
         if(this.disableLayout)
         {
            this.setupParentLayout(false);
            this.cacheConstraints();
         }
         else if(Boolean(this.disabledConstraintsMap))
         {
            for(constraint in this.disabledConstraintsMap)
            {
               this.cacheConstraint(constraint);
            }
            this.disabledConstraintsMap = null;
         }
         this.finalizeValues();
      }
      
      public function animationUpdate(animation:Animation) : void
      {
         var event:EffectEvent = null;
         this.applyValues(animation);
         if(this.numUpdateListeners > 0)
         {
            event = new EffectEvent(EffectEvent.EFFECT_UPDATE);
            event.effectInstance = this;
            dispatchEvent(event);
         }
      }
      
      public function animationRepeat(animation:Animation) : void
      {
         var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_REPEAT);
         event.effectInstance = this;
         dispatchEvent(event);
      }
      
      private function animationCleanup() : void
      {
         if(this.disableLayout)
         {
            this.reenableConstraints();
            if(this.disableLayout)
            {
               this.setupParentLayout(true);
            }
         }
      }
      
      public function animationEnd(animation:Animation) : void
      {
         this.animationCleanup();
         this.finishEffect();
      }
      
      public function animationStop(animation:Animation) : void
      {
         this.animationCleanup();
      }
      
      private function noopAnimationHandler(event:TimerEvent) : void
      {
         this.finishEffect();
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         if(type == EffectEvent.EFFECT_UPDATE)
         {
            ++this.numUpdateListeners;
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(type == EffectEvent.EFFECT_UPDATE)
         {
            --this.numUpdateListeners;
         }
      }
      
      override public function finishEffect() : void
      {
         if(this.autoRemoveTarget)
         {
            this.removeDisappearingTarget();
         }
         super.finishEffect();
      }
      
      private function addDisappearingTarget() : void
      {
         var parentStart:* = undefined;
         var parentEnd:* = undefined;
         var tmp:* = undefined;
         var startIndex:* = undefined;
         var startContainer:IVisualElementContainer = null;
         var startMgr:SystemManager = null;
         this.needsRemoval = false;
         if(Boolean(propertyChanges))
         {
            if("parent" in target && !target.parent)
            {
               parentStart = propertyChanges.start["parent"];
               parentEnd = propertyChanges.end["parent"];
               if(playReversed)
               {
                  tmp = parentStart;
                  parentStart = parentEnd;
                  parentEnd = tmp;
               }
               if(Boolean(parentStart) && Boolean(!parentEnd) && (parentStart is IVisualElementContainer || parentStart is SystemManager))
               {
                  startIndex = !playReversed ? propertyChanges.start["index"] : propertyChanges.end["index"];
                  if(parentStart is IVisualElementContainer)
                  {
                     startContainer = IVisualElementContainer(parentStart);
                     if(startIndex !== undefined && startIndex <= startContainer.numElements)
                     {
                        startContainer.addElementAt(target as IVisualElement,int(startIndex));
                     }
                     else
                     {
                        startContainer.addElement(target as IVisualElement);
                     }
                  }
                  else
                  {
                     startMgr = parentStart as SystemManager;
                     if(startIndex !== undefined && startIndex <= startMgr.numChildren)
                     {
                        startMgr.addChildAt(target as DisplayObject,int(startIndex));
                     }
                     else
                     {
                        startMgr.addChild(target as DisplayObject);
                     }
                  }
                  if(target is GraphicElement)
                  {
                     GraphicElement(target).validateNow();
                  }
                  this.needsRemoval = true;
               }
            }
         }
      }
      
      private function removeDisappearingTarget() : void
      {
         var parentStart:* = undefined;
         var parentEnd:* = undefined;
         var tmp:* = undefined;
         if(this.needsRemoval && Boolean(propertyChanges))
         {
            if("parent" in target && Boolean(target.parent))
            {
               parentStart = propertyChanges.start["parent"];
               parentEnd = propertyChanges.end["parent"];
               if(playReversed)
               {
                  tmp = parentStart;
                  parentStart = parentEnd;
                  parentEnd = tmp;
               }
               if(Boolean(parentStart) && !parentEnd)
               {
                  if(parentStart is IVisualElementContainer)
                  {
                     IVisualElementContainer(parentStart).removeElement(target as IVisualElement);
                  }
                  else
                  {
                     parentStart.removeChild(target);
                  }
               }
            }
         }
      }
      
      private function reenableConstraint(name:String) : void
      {
         var value:* = this.constraintsHolder[name];
         if(value !== undefined)
         {
            if(name in target)
            {
               target[name] = value;
            }
            else
            {
               target.setStyle(name,value);
            }
            delete this.constraintsHolder[name];
         }
      }
      
      private function reenableConstraints() : void
      {
         var left:* = undefined;
         var right:* = undefined;
         var top:* = undefined;
         var bottom:* = undefined;
         if(Boolean(this.constraintsHolder))
         {
            left = this.reenableConstraint("left");
            right = this.reenableConstraint("right");
            top = this.reenableConstraint("top");
            bottom = this.reenableConstraint("bottom");
            this.reenableConstraint("horizontalCenter");
            this.reenableConstraint("verticalCenter");
            this.reenableConstraint("baseline");
            this.constraintsHolder = null;
            if(left != undefined && right != undefined && "explicitWidth" in target)
            {
               target.explicitWidth = this.oldWidth;
            }
            if(top != undefined && bottom != undefined && "explicitHeight" in target)
            {
               target.explicitHeight = this.oldHeight;
            }
         }
      }
      
      private function cacheConstraint(name:String) : *
      {
         var value:* = undefined;
         var isProperty:Boolean = name in target;
         if(isProperty)
         {
            value = target[name];
         }
         else
         {
            value = target.getStyle(name);
         }
         if(!isNaN(value) && value != null)
         {
            if(!this.constraintsHolder)
            {
               this.constraintsHolder = new Object();
            }
            this.constraintsHolder[name] = value;
            if(isProperty)
            {
               target[name] = NaN;
            }
            else if(target is IStyleClient)
            {
               target.setStyle(name,undefined);
            }
         }
         return value;
      }
      
      private function cacheConstraints() : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         var left:* = this.cacheConstraint("left");
         var right:* = this.cacheConstraint("right");
         var top:* = this.cacheConstraint("top");
         var bottom:* = this.cacheConstraint("bottom");
         this.cacheConstraint("verticalCenter");
         this.cacheConstraint("horizontalCenter");
         this.cacheConstraint("baseline");
         if(left != undefined && right != undefined && "explicitWidth" in target)
         {
            w = Number(target.width);
            this.oldWidth = target.explicitWidth;
            target.width = w;
         }
         if(top != undefined && bottom != undefined && "explicitHeight" in target)
         {
            h = Number(target.height);
            this.oldHeight = target.explicitHeight;
            target.height = h;
         }
      }
      
      protected function setupStyleMapEntry(property:String) : void
      {
         if(this.isStyleMap[property] == undefined)
         {
            if(property in target)
            {
               this.isStyleMap[property] = false;
            }
            else
            {
               try
               {
                  target.getStyle(property);
                  this.isStyleMap[property] = true;
               }
               catch(err:Error)
               {
                  throw new Error(resourceManager.getString("sparkEffects","propNotPropOrStyle",[property,target,err]));
               }
            }
         }
      }
      
      protected function setValue(property:String, value:Object) : void
      {
         this.setupStyleMapEntry(property);
         if(!this.isStyleMap[property])
         {
            target[property] = value;
         }
         else
         {
            target.setStyle(property,value);
         }
      }
      
      protected function getCurrentValue(property:String) : *
      {
         this.setupStyleMapEntry(property);
         if(!this.isStyleMap[property])
         {
            return target[property];
         }
         return target.getStyle(property);
      }
      
      private function setupParentLayout(enable:Boolean) : void
      {
         var parent:* = null;
         if("parent" in target && Boolean(target.parent))
         {
            parent = target.parent;
         }
         if(Boolean(parent) && "autoLayout" in parent)
         {
            parent.autoLayout = enable;
         }
      }
   }
}

