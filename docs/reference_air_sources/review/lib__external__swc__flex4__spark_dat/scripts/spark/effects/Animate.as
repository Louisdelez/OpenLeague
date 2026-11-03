package spark.effects
{
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import mx.events.EffectEvent;
   import spark.effects.animation.MotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Sine;
   import spark.effects.interpolation.IInterpolator;
   import spark.effects.supportClasses.AnimateInstance;
   
   [Event(name="effectRepeat",type="mx.events.EffectEvent")]
   [Event(name="effectUpdate",type="mx.events.EffectEvent")]
   [DefaultProperty("motionPaths")]
   [Exclude(name="suspendBackgroundProcessing",kind="property")]
   public class Animate extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var defaultEaser:IEaser = new Sine(0.5);
      
      private var affectedProperties:Array = null;
      
      private var _relevantStyles:Array = null;
      
      private var numUpdateListeners:int = 0;
      
      private var _motionPaths:Vector.<MotionPath>;
      
      private var _easer:IEaser = defaultEaser;
      
      private var _interpolator:IInterpolator = null;
      
      private var _repeatBehavior:String = "loop";
      
      private var _disableLayout:Boolean = false;
      
      public function Animate(target:Object = null)
      {
         super(target);
         instanceClass = AnimateInstance;
      }
      
      public function get motionPaths() : Vector.<MotionPath>
      {
         return this._motionPaths;
      }
      
      public function set motionPaths(value:Vector.<MotionPath>) : void
      {
         this._motionPaths = value;
      }
      
      public function get easer() : IEaser
      {
         return this._easer;
      }
      
      public function set easer(value:IEaser) : void
      {
         this._easer = value;
      }
      
      public function get interpolator() : IInterpolator
      {
         return this._interpolator;
      }
      
      public function set interpolator(value:IInterpolator) : void
      {
         this._interpolator = value;
      }
      
      [Inspectable(category="General",enumeration="loop,reverse",defaultValue="loop")]
      public function get repeatBehavior() : String
      {
         return this._repeatBehavior;
      }
      
      public function set repeatBehavior(value:String) : void
      {
         this._repeatBehavior = value;
      }
      
      public function get disableLayout() : Boolean
      {
         return this._disableLayout;
      }
      
      public function set disableLayout(value:Boolean) : void
      {
         this._disableLayout = value;
      }
      
      override public function getAffectedProperties() : Array
      {
         var horizontalMove:Boolean = false;
         var verticalMove:Boolean = false;
         var i:int = 0;
         var effectHolder:MotionPath = null;
         if(!this.affectedProperties)
         {
            if(Boolean(this.motionPaths))
            {
               this.affectedProperties = new Array();
               for(i = 0; i < this.motionPaths.length; i++)
               {
                  effectHolder = MotionPath(this.motionPaths[i]);
                  this.affectedProperties.push(effectHolder.property);
                  switch(effectHolder.property)
                  {
                     case "left":
                     case "right":
                     case "horizontalCenter":
                        horizontalMove = true;
                        break;
                     case "top":
                     case "bottom":
                     case "verticalCenter":
                        verticalMove = true;
                        break;
                     case "width":
                        if(this.affectedProperties.indexOf("explicitWidth") < 0)
                        {
                           this.affectedProperties.push("explicitWidth");
                        }
                        if(this.affectedProperties.indexOf("percentWidth") < 0)
                        {
                           this.affectedProperties.push("percentWidth");
                        }
                        break;
                     case "height":
                        if(this.affectedProperties.indexOf("explicitHeight") < 0)
                        {
                           this.affectedProperties.push("explicitHeight");
                        }
                        if(this.affectedProperties.indexOf("percentHeight") < 0)
                        {
                           this.affectedProperties.push("percentHeight");
                        }
                  }
               }
               if(horizontalMove)
               {
                  if(this.affectedProperties.indexOf("x") < 0)
                  {
                     this.affectedProperties.push("x");
                  }
                  if(this.affectedProperties.indexOf("width") < 0)
                  {
                     this.affectedProperties.push("width");
                  }
                  if(this.affectedProperties.indexOf("explicitWidth") < 0)
                  {
                     this.affectedProperties.push("explicitWidth");
                  }
               }
               if(verticalMove)
               {
                  if(this.affectedProperties.indexOf("y") < 0)
                  {
                     this.affectedProperties.push("y");
                  }
                  if(this.affectedProperties.indexOf("height") < 0)
                  {
                     this.affectedProperties.push("height");
                  }
                  if(this.affectedProperties.indexOf("explicitHeight") < 0)
                  {
                     this.affectedProperties.push("explicitHeight");
                  }
               }
            }
            else
            {
               this.affectedProperties = [];
            }
         }
         return this.affectedProperties;
      }
      
      override public function get relevantStyles() : Array
      {
         var i:int = 0;
         var effectHolder:MotionPath = null;
         if(!this._relevantStyles)
         {
            if(Boolean(this.motionPaths))
            {
               this._relevantStyles = new Array(this.motionPaths.length);
               for(i = 0; i < this.motionPaths.length; i++)
               {
                  effectHolder = MotionPath(this.motionPaths[i]);
                  this._relevantStyles[i] = effectHolder.property;
               }
            }
            else
            {
               this._relevantStyles = [];
            }
         }
         return this._relevantStyles;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var i:int = 0;
         super.initInstance(instance);
         var animateInstance:AnimateInstance = AnimateInstance(instance);
         animateInstance.addEventListener(EffectEvent.EFFECT_REPEAT,this.animationEventHandler);
         if(this.numUpdateListeners > 0)
         {
            animateInstance.addEventListener(EffectEvent.EFFECT_UPDATE,this.animationEventHandler);
         }
         if(Boolean(this.easer))
         {
            animateInstance.easer = this.easer;
         }
         if(Boolean(this.interpolator))
         {
            animateInstance.interpolator = this.interpolator;
         }
         if(isNaN(repeatCount))
         {
            animateInstance.repeatCount = repeatCount;
         }
         animateInstance.repeatBehavior = this.repeatBehavior;
         animateInstance.disableLayout = this.disableLayout;
         if(Boolean(this.motionPaths))
         {
            animateInstance.motionPaths = new Vector.<MotionPath>();
            for(i = 0; i < this.motionPaths.length; i++)
            {
               animateInstance.motionPaths[i] = this.motionPaths[i].clone();
            }
         }
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property in target)
         {
            try
            {
               target[property] = value;
            }
            catch(e:Error)
            {
            }
         }
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
      
      private function animationEventHandler(event:EffectEvent) : void
      {
         dispatchEvent(event);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function captureValues(propChanges:Array, setStartValues:Boolean, targetsToCapture:Array = null) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var propertyChanges:Array = super.captureValues(propChanges,setStartValues,targetsToCapture);
         var explicitValuesCaptured:Boolean = this.getAffectedProperties().indexOf("explicitWidth") >= 0 || this.getAffectedProperties().indexOf("explicitHeight") >= 0;
         if(explicitValuesCaptured && setStartValues)
         {
            n = int(propertyChanges.length);
            for(i = 0; i < n; i++)
            {
               if(targetsToCapture == null || targetsToCapture.length == 0 || targetsToCapture.indexOf(propertyChanges[i].target) >= 0)
               {
                  propertyChanges[i].stripUnchangedValues = false;
               }
            }
         }
         return propertyChanges;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyStartValues(propChanges:Array, targets:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var target:Object = null;
         super.applyStartValues(propChanges,targets);
         if(Boolean(propChanges))
         {
            n = int(propChanges.length);
            for(i = 0; i < n; i++)
            {
               target = propChanges[i].target;
               if(propChanges[i].start["percentWidth"] !== undefined && "percentWidth" in target)
               {
                  target.percentWidth = propChanges[i].start["percentWidth"];
               }
               if(propChanges[i].start["percentHeight"] !== undefined && "percentHeight" in target)
               {
                  target.percentHeight = propChanges[i].start["percentHeight"];
               }
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyEndValues(propChanges:Array, targets:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var target:Object = null;
         super.applyEndValues(propChanges,targets);
         if(Boolean(propChanges))
         {
            n = int(propChanges.length);
            for(i = 0; i < n; i++)
            {
               target = propChanges[i].target;
               if(propChanges[i].end["explicitWidth"] !== undefined)
               {
                  if(isNaN(propChanges[i].end["explicitWidth"]) && "explicitWidth" in target)
                  {
                     target.explicitWidth = NaN;
                     if(propChanges[i].end["percentWidth"] !== undefined && "percentWidth" in target)
                     {
                        target.percentWidth = propChanges[i].end["percentWidth"];
                     }
                  }
               }
               if(propChanges[i].end["explicitHeight"] !== undefined)
               {
                  if(isNaN(propChanges[i].end["explicitHeight"]) && "explicitHeight" in target)
                  {
                     target.explicitHeight = NaN;
                     if(propChanges[i].end["percentHeight"] !== undefined && "percentHeight" in target)
                     {
                        target.percentHeight = propChanges[i].end["percentHeight"];
                     }
                  }
               }
            }
         }
      }
   }
}

