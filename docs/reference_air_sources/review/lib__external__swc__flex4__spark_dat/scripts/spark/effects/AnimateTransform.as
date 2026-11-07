package spark.effects
{
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import mx.core.ILayoutElement;
   import mx.effects.CompositeEffect;
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import mx.effects.Parallel;
   import mx.effects.Sequence;
   import mx.events.EffectEvent;
   import mx.geom.TransformOffsets;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.easing.Linear;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   [Exclude(name="repeatDelay",kind="property")]
   [Exclude(name="repeatBehavior",kind="property")]
   [Exclude(name="repeatCount",kind="property")]
   public class AnimateTransform extends Animate
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["translationX","translationY","translationZ","rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ","postLayoutTranslationX","postLayoutTranslationY","postLayoutTranslationZ","postLayoutRotationX","postLayoutRotationY","postLayoutRotationZ","postLayoutScaleX","postLayoutScaleY","postLayoutScaleZ","left","right","top","bottom","horizontalCenter","verticalCenter","baseline","width","height"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","horizontalCenter","verticalCenter","baseline"];
      
      private static var linearEaser:Linear = new Linear();
      
      private static var appliedStartValuesPerTarget:Dictionary = new Dictionary(true);
      
      private static var appliedEndValuesPerTarget:Dictionary = new Dictionary(true);
      
      private static var sharedObjectDepot:SharedObjectDepot = new SharedObjectDepot();
      
      private static var scale:Vector3D = new Vector3D();
      
      private static var rotation:Vector3D = new Vector3D();
      
      private static var position:Vector3D = new Vector3D();
      
      private static var offsetRotation:Vector3D = new Vector3D();
      
      private static var offsetTranslation:Vector3D = new Vector3D();
      
      private static var offsetScale:Vector3D = new Vector3D();
      
      private static var xformPosition:Vector3D = new Vector3D();
      
      private static var postLayoutPosition:Vector3D = new Vector3D();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var transformEffectSubclass:Boolean = false;
      
      private var _applyChangesPostLayout:Boolean = false;
      
      [Inspectable(category="General",defaultValue="false")]
      public var autoCenterTransform:Boolean = false;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var transformX:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var transformY:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var transformZ:Number;
      
      public function AnimateTransform(target:Object = null)
      {
         super(target);
         instanceClass = AnimateTransformInstance;
      }
      
      [Inspectable(category="General",enumeration="true,false")]
      public function get applyChangesPostLayout() : Boolean
      {
         return this._applyChangesPostLayout;
      }
      
      public function set applyChangesPostLayout(value:Boolean) : void
      {
         this._applyChangesPostLayout = value;
      }
      
      private function getOwningParallelEffect() : Parallel
      {
         var prevParent:Parallel = null;
         var parent:Effect = parentCompositeEffect;
         while(Boolean(parent))
         {
            if(parent is Sequence)
            {
               break;
            }
            prevParent = Parallel(parent);
            parent = parent.parentCompositeEffect;
         }
         return prevParent;
      }
      
      override public function createInstance(target:Object = null) : IEffectInstance
      {
         var newInstance:IEffectInstance = null;
         if(!target)
         {
            target = this.target;
         }
         var parent:Effect = parentCompositeEffect;
         var sharedInstance:IEffectInstance = null;
         var topmostParallel:Parallel = this.getOwningParallelEffect();
         if(topmostParallel != null)
         {
            sharedInstance = IEffectInstance(sharedObjectDepot.getSharedObject(topmostParallel,target));
         }
         if(!sharedInstance)
         {
            newInstance = super.createInstance(target);
            if(Boolean(topmostParallel))
            {
               sharedObjectDepot.storeSharedObject(topmostParallel,target,newInstance);
            }
            return newInstance;
         }
         this.initInstance(sharedInstance);
         return null;
      }
      
      override protected function effectStartHandler(event:EffectEvent) : void
      {
         super.effectStartHandler(event);
         var topmostParallel:Parallel = this.getOwningParallelEffect();
         if(topmostParallel != null)
         {
            sharedObjectDepot.removeSharedObject(topmostParallel,event.effectInstance.target);
         }
         delete appliedStartValuesPerTarget[event.effectInstance.target];
         delete appliedEndValuesPerTarget[event.effectInstance.target];
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function captureValues(propChanges:Array, setStartValues:Boolean, targetsToCapture:Array = null) : Array
      {
         var valueMap:Object = null;
         var i:int = 0;
         var n:int = 0;
         var target:Object = null;
         var computedTransformCenter:Vector3D = null;
         var postLayoutTransformOffsets:TransformOffsets = null;
         propChanges = super.captureValues(propChanges,setStartValues,targetsToCapture);
         n = int(propChanges.length);
         for(i = 0; i < n; i++)
         {
            target = propChanges[i].target;
            if(targetsToCapture == null || targetsToCapture.length == 0 || targetsToCapture.indexOf(target) >= 0)
            {
               if(!(!(target is ILayoutElement) || !target.parent && setStartValues))
               {
                  valueMap = setStartValues ? propChanges[i].start : propChanges[i].end;
                  computedTransformCenter = this.computeTransformCenterForTarget(target,valueMap);
                  if(valueMap.translationX === undefined || valueMap.translationY === undefined || valueMap.translationZ === undefined)
                  {
                     propChanges[i].stripUnchangedValues = false;
                     target.transformPointToParent(computedTransformCenter,xformPosition,null);
                     valueMap.translationX = xformPosition.x;
                     valueMap.translationY = xformPosition.y;
                     valueMap.translationZ = xformPosition.z;
                  }
                  if((this.applyChangesPostLayout || this.postLayoutTransformPropertiesSet) && target.postLayoutTransformOffsets == null)
                  {
                     target.postLayoutTransformOffsets = new TransformOffsets();
                  }
                  if(target.postLayoutTransformOffsets != null)
                  {
                     postLayoutTransformOffsets = target.postLayoutTransformOffsets;
                     valueMap.postLayoutRotationX = postLayoutTransformOffsets.rotationX;
                     valueMap.postLayoutRotationY = postLayoutTransformOffsets.rotationY;
                     valueMap.postLayoutRotationZ = postLayoutTransformOffsets.rotationZ;
                     valueMap.postLayoutScaleX = postLayoutTransformOffsets.scaleX;
                     valueMap.postLayoutScaleY = postLayoutTransformOffsets.scaleY;
                     valueMap.postLayoutScaleZ = postLayoutTransformOffsets.scaleZ;
                     if(valueMap.postLayoutTranslationX === undefined || valueMap.postLayoutTranslationY === undefined || valueMap.postLayoutTranslationZ === undefined)
                     {
                        propChanges[i].stripUnchangedValues = false;
                        target.transformPointToParent(computedTransformCenter,null,postLayoutPosition);
                        valueMap.postLayoutTranslationX = postLayoutPosition.x;
                        valueMap.postLayoutTranslationY = postLayoutPosition.y;
                        valueMap.postLayoutTranslationZ = postLayoutPosition.z;
                     }
                  }
               }
            }
         }
         return propChanges;
      }
      
      private function computeTransformCenterForTarget(target:Object, valueMap:Object = null) : Vector3D
      {
         var computedTransformCenter:Vector3D = null;
         var w:Number = NaN;
         var h:Number = NaN;
         if(this.autoCenterTransform)
         {
            w = valueMap != null && valueMap["width"] !== undefined ? Number(valueMap["width"]) : Number(target.width);
            h = valueMap != null && valueMap["height"] !== undefined ? Number(valueMap["height"]) : Number(target.height);
            computedTransformCenter = new Vector3D(w / 2,h / 2,0);
         }
         else
         {
            computedTransformCenter = new Vector3D(target.transformX,target.transformY,target.transformZ);
            if(!isNaN(this.transformX))
            {
               computedTransformCenter.x = this.transformX;
            }
            if(!isNaN(this.transformY))
            {
               computedTransformCenter.y = this.transformY;
            }
            if(!isNaN(this.transformZ))
            {
               computedTransformCenter.z = this.transformZ;
            }
         }
         return computedTransformCenter;
      }
      
      private function applyValues(propChanges:Array, targets:Array, start:Boolean) : void
      {
         var m:int = 0;
         var j:int = 0;
         var target:Object = null;
         var apply:Boolean = false;
         var effectProps:Array = null;
         var valueMap:Object = null;
         var otherValueMap:Object = null;
         var transitionValues:Object = null;
         var xformCenter:Vector3D = null;
         var tmpScale:Vector3D = null;
         var tmpPosition:Vector3D = null;
         var tmpRotation:Vector3D = null;
         var tmpOffsetTranslation:Vector3D = null;
         var tmpOffsetRotation:Vector3D = null;
         var tmpOffsetScale:Vector3D = null;
         var currentXFormPositionComputed:Boolean = false;
         var propName:String = null;
         var appliedValuesPerTarget:Dictionary = start ? appliedStartValuesPerTarget : appliedEndValuesPerTarget;
         var n:int = int(propChanges.length);
         for(var i:int = 0; i < n; i++)
         {
            target = propChanges[i].target;
            apply = false;
            if(!Boolean(appliedValuesPerTarget[target]))
            {
               m = int(targets.length);
               for(j = 0; j < m; j++)
               {
                  if(targets[j] == target)
                  {
                     apply = Boolean(filterInstance(propChanges,target));
                     break;
                  }
               }
               if(apply)
               {
                  effectProps = AFFECTED_PROPERTIES;
                  valueMap = start ? propChanges[i].start : propChanges[i].end;
                  otherValueMap = start ? propChanges[i].end : propChanges[i].start;
                  transitionValues = {
                     "rotationX":NaN,
                     "rotationY":NaN,
                     "rotation":NaN,
                     "scaleX":NaN,
                     "scaleY":NaN,
                     "scaleZ":NaN,
                     "translationX":NaN,
                     "translationY":NaN,
                     "translationZ":NaN
                  };
                  m = int(effectProps.length);
                  for(j = 0; j < m; j++)
                  {
                     propName = effectProps[j];
                     if(propName in valueMap && (propName == "translationX" || propName == "translationY" || propName.indexOf("postLayout") == 0 || valueMap[propName] != otherValueMap[propName]))
                     {
                        transitionValues[propName] = valueMap[propName];
                     }
                  }
                  xformCenter = this.computeTransformCenterForTarget(target,valueMap);
                  tmpScale = null;
                  tmpPosition = null;
                  tmpRotation = null;
                  tmpOffsetTranslation = null;
                  tmpOffsetRotation = null;
                  tmpOffsetScale = null;
                  currentXFormPositionComputed = false;
                  if(!isNaN(transitionValues.scaleX) || !isNaN(transitionValues.scaleY) || !isNaN(transitionValues.scaleZ))
                  {
                     scale.x = !isNaN(transitionValues.scaleX) ? Number(transitionValues.scaleX) : Number(target["scaleX"]);
                     scale.y = !isNaN(transitionValues.scaleY) ? Number(transitionValues.scaleY) : Number(target["scaleY"]);
                     scale.z = !isNaN(transitionValues.scaleZ) ? Number(transitionValues.scaleZ) : Number(target["scaleZ"]);
                     tmpScale = scale;
                  }
                  if(!isNaN(transitionValues.rotationX) || !isNaN(transitionValues.rotationY) || !isNaN(transitionValues.rotationZ))
                  {
                     rotation.x = !isNaN(transitionValues.rotationX) ? Number(transitionValues.rotationX) : Number(target["rotationX"]);
                     rotation.y = !isNaN(transitionValues.rotationY) ? Number(transitionValues.rotationY) : Number(target["rotationY"]);
                     rotation.z = !isNaN(transitionValues.rotationZ) ? Number(transitionValues.rotationZ) : Number(target["rotationZ"]);
                     tmpRotation = rotation;
                  }
                  position.x = transitionValues.translationX;
                  position.y = transitionValues.translationY;
                  position.z = transitionValues.translationZ;
                  if(isNaN(position.x) || isNaN(position.y) || isNaN(position.z))
                  {
                     target.transformPointToParent(xformCenter,xformPosition,postLayoutPosition);
                     currentXFormPositionComputed = true;
                     if(isNaN(position.x))
                     {
                        position.x = xformPosition.x;
                     }
                     if(isNaN(position.y))
                     {
                        position.y = xformPosition.y;
                     }
                     if(isNaN(position.z))
                     {
                        position.z = xformPosition.z;
                     }
                  }
                  if(target.postLayoutTransformOffsets != null)
                  {
                     offsetRotation.x = !isNaN(transitionValues.postLayoutRotationX) ? Number(transitionValues.postLayoutRotationX) : 0;
                     offsetRotation.y = !isNaN(transitionValues.postLayoutRotationY) ? Number(transitionValues.postLayoutRotationY) : 0;
                     offsetRotation.z = !isNaN(transitionValues.postLayoutRotationZ) ? Number(transitionValues.postLayoutRotationZ) : 0;
                     tmpOffsetRotation = offsetRotation;
                     offsetScale.x = !isNaN(transitionValues.postLayoutScaleX) ? Number(transitionValues.postLayoutScaleX) : 1;
                     offsetScale.y = !isNaN(transitionValues.postLayoutScaleY) ? Number(transitionValues.postLayoutScaleY) : 1;
                     offsetScale.z = !isNaN(transitionValues.postLayoutScaleZ) ? Number(transitionValues.postLayoutScaleZ) : 1;
                     tmpOffsetScale = offsetScale;
                     offsetTranslation.x = transitionValues.postLayoutTranslationX;
                     offsetTranslation.y = transitionValues.postLayoutTranslationY;
                     offsetTranslation.z = transitionValues.postLayoutTranslationZ;
                     if(isNaN(offsetTranslation.x) || isNaN(offsetTranslation.y) || isNaN(offsetTranslation.z))
                     {
                        if(currentXFormPositionComputed == false)
                        {
                           target.transformPointToParent(xformCenter,xformPosition,postLayoutPosition);
                           currentXFormPositionComputed = true;
                        }
                        if(isNaN(offsetTranslation.x))
                        {
                           offsetTranslation.x = postLayoutPosition.x;
                        }
                        if(isNaN(offsetTranslation.y))
                        {
                           offsetTranslation.y = postLayoutPosition.y;
                        }
                        if(isNaN(offsetTranslation.z))
                        {
                           offsetTranslation.z = postLayoutPosition.z;
                        }
                     }
                     tmpOffsetTranslation = offsetTranslation;
                  }
                  target.transformAround(xformCenter,tmpScale,tmpRotation,position,tmpOffsetScale,tmpOffsetRotation,tmpOffsetTranslation);
                  appliedValuesPerTarget[target] = true;
               }
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyStartValues(propChanges:Array, targets:Array) : void
      {
         this.applyValues(propChanges,targets,true);
         super.applyStartValues(propChanges,targets);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyEndValues(propChanges:Array, targets:Array) : void
      {
         if(applyTransitionEndProperties)
         {
            this.applyValues(propChanges,targets,false);
            super.applyEndValues(propChanges,targets);
         }
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "translationX" || property == "translationY" || property == "translationZ" || property == "rotationX" || property == "rotationY" || property == "rotationZ" || property == "scaleX" || property == "scaleY" || property == "scaleZ" || property == "postLayoutTranslationX" || property == "postLayoutTranslationY" || property == "postLayoutTranslationZ" || property == "postLayoutRotationX" || property == "postLayoutRotationY" || property == "postLayoutRotationZ" || property == "postLayoutScaleX" || property == "postLayoutScaleY" || property == "postLayoutScaleZ" || property == "width" || property == "height")
         {
            return;
         }
         super.applyValueToTarget(target,property,value,props);
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      private function insertKeyframe(keyframes:Vector.<Keyframe>, newKF:Keyframe) : void
      {
         for(var i:int = 0; i < keyframes.length; i++)
         {
            if(keyframes[i].time > newKF.time)
            {
               keyframes.splice(i,0,newKF);
               return;
            }
         }
         keyframes.push(newKF);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addMotionPath(property:String, valueFrom:Number = NaN, valueTo:Number = NaN, valueBy:Number = NaN) : void
      {
         var n:int = 0;
         var i:int = 0;
         var prop:MotionPath = null;
         var j:int = 0;
         if(isNaN(valueFrom))
         {
            if(!isNaN(valueTo) && !isNaN(valueBy))
            {
               valueFrom = valueTo - valueBy;
            }
         }
         var mp:MotionPath = new MotionPath(property);
         mp.keyframes = new <Keyframe>[new Keyframe(0,valueFrom),new Keyframe(duration,valueTo,valueBy)];
         mp.keyframes[1].easer = easer;
         if(Boolean(motionPaths))
         {
            n = int(motionPaths.length);
            for(i = 0; i < n; i++)
            {
               prop = MotionPath(motionPaths[i]);
               if(prop.property == mp.property)
               {
                  for(j = 0; j < mp.keyframes.length; j++)
                  {
                     this.insertKeyframe(prop.keyframes,mp.keyframes[j]);
                  }
                  return;
               }
            }
         }
         else
         {
            motionPaths = new Vector.<MotionPath>();
         }
         motionPaths.push(mp);
      }
      
      private function isValidValue(value:Object) : Boolean
      {
         return value is Number && !isNaN(Number(value)) || !(value is Number) && value !== null;
      }
      
      private function get postLayoutTransformPropertiesSet() : Boolean
      {
         var i:int = 0;
         if(Boolean(motionPaths))
         {
            for(i = 0; i < motionPaths.length; i++)
            {
               if(motionPaths[i].property.indexOf("postLayout",0) == 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var i:int = 0;
         var s:String = null;
         var instanceAnimProps:Array = null;
         var globalStartTime:Number = NaN;
         var mp:MotionPath = null;
         var j:int = 0;
         var kf:Keyframe = null;
         var adjustedDuration:Number = Number(duration);
         var target:Object = instance.target;
         var transformInstance:AnimateTransformInstance = AnimateTransformInstance(instance);
         if(this.postLayoutTransformPropertiesSet)
         {
            if(target.postLayoutTransformOffsets == null)
            {
               target.postLayoutTransformOffsets = new TransformOffsets();
            }
         }
         if(Boolean(motionPaths))
         {
            instanceAnimProps = [];
            for(i = 0; i < motionPaths.length; i++)
            {
               instanceAnimProps[i] = motionPaths[i].clone();
               mp = MotionPath(instanceAnimProps[i]);
               if(Boolean(mp.keyframes))
               {
                  for(j = 0; j < mp.keyframes.length; j++)
                  {
                     kf = Keyframe(mp.keyframes[j]);
                     if(isNaN(kf.time))
                     {
                        kf.time = duration;
                     }
                     if(startDelay != 0)
                     {
                        kf.time += startDelay;
                     }
                  }
                  adjustedDuration = Math.max(adjustedDuration,mp.keyframes[mp.keyframes.length - 1].time);
               }
            }
            globalStartTime = this.getGlobalStartTime();
            for(i = 0; i < instanceAnimProps.length; i++)
            {
               transformInstance.addMotionPath(instanceAnimProps[i],globalStartTime);
            }
         }
         for each(s in this.getAffectedProperties())
         {
            if(this.relevantStyles.indexOf(s) < 0)
            {
               transformInstance.affectedProperties[s] = s;
            }
         }
         for each(s in this.relevantStyles)
         {
            transformInstance.layoutConstraints[s] = s;
         }
         if(transformInstance.initialized)
         {
            return;
         }
         transformInstance.initialized = true;
         if(!this.autoCenterTransform)
         {
            transformInstance.transformCenter = this.computeTransformCenterForTarget(instance.target);
         }
         transformInstance.autoCenterTransform = this.autoCenterTransform;
         var tmpStartDelay:Number = Number(startDelay);
         startDelay = 0;
         var tmpAnimProps:Vector.<MotionPath> = motionPaths;
         motionPaths = null;
         super.initInstance(instance);
         startDelay = tmpStartDelay;
         motionPaths = tmpAnimProps;
         transformInstance.duration = Math.max(duration,adjustedDuration);
         if(this.transformEffectSubclass)
         {
            transformInstance.easer = linearEaser;
         }
      }
      
      private function getGlobalStartTime() : Number
      {
         var sequence:Sequence = null;
         var i:int = 0;
         var child:Effect = null;
         var globalStartTime:Number = 0;
         var parent:Effect = parentCompositeEffect;
         while(Boolean(parent))
         {
            globalStartTime += parent.startDelay;
            if(parent is Sequence)
            {
               sequence = Sequence(parent);
               for(i = 0; i < sequence.children.length; i++)
               {
                  child = sequence.children[i];
                  if(child == this)
                  {
                     break;
                  }
                  if(child is CompositeEffect)
                  {
                     globalStartTime += CompositeEffect(child).compositeDuration;
                  }
                  else
                  {
                     globalStartTime += child.startDelay + child.duration * child.repeatCount + (child.repeatDelay + (child.repeatCount - 1));
                  }
               }
            }
            parent = parent.parentCompositeEffect;
         }
         return globalStartTime;
      }
   }
}

