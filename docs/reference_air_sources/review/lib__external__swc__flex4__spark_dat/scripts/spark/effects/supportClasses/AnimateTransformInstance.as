package spark.effects.supportClasses
{
   import flash.display.DisplayObject;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   import mx.core.UIComponent;
   import spark.components.Group;
   import spark.effects.animation.Animation;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Linear;
   
   public class AnimateTransformInstance extends AnimateInstance
   {
      
      private static var TRANSFORM_PROPERTIES:Array = ["translationX","translationY","translationZ","rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ","postLayoutTranslationX","postLayoutTranslationY","postLayoutTranslationZ","postLayoutRotationX","postLayoutRotationY","postLayoutRotationZ","postLayoutScaleX","postLayoutScaleY","postLayoutScaleZ"];
      
      private static var scale:Vector3D = new Vector3D();
      
      private static var rotation:Vector3D = new Vector3D();
      
      private static var position:Vector3D = new Vector3D();
      
      private static var offsetRotation:Vector3D = new Vector3D();
      
      private static var offsetTranslation:Vector3D = new Vector3D();
      
      private static var offsetScale:Vector3D = new Vector3D();
      
      public var applyLocalProjection:Boolean = false;
      
      public var autoCenterProjection:Boolean = false;
      
      public var removeLocalProjectionWhenComplete:Boolean = false;
      
      public var fieldOfView:Number;
      
      public var focalLength:Number;
      
      public var projectionX:Number = 0;
      
      public var projectionY:Number = 0;
      
      public var removeLocalPerspectiveOnEnd:Boolean = false;
      
      protected var originalProjection:PerspectiveProjection;
      
      private var started:Boolean = false;
      
      private var instanceStartTime:Number = 0;
      
      private var currentValues:Object = {
         "rotationX":NaN,
         "rotationY":NaN,
         "rotationZ":NaN,
         "scaleX":NaN,
         "scaleY":NaN,
         "scaleZ":NaN,
         "translationX":NaN,
         "translationY":NaN,
         "translationZ":NaN,
         "postLayoutRotationX":NaN,
         "postLayoutRotationY":NaN,
         "postLayoutRotationZ":NaN,
         "postLayoutScaleX":NaN,
         "postLayoutScaleY":NaN,
         "postLayoutScaleZ":NaN,
         "postLayoutTranslationX":NaN,
         "postLayoutTranslationY":NaN,
         "postLayoutTranslationZ":NaN
      };
      
      private var prevWidth:Number;
      
      private var prevHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var layoutConstraints:Object = new Object();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var affectedProperties:Object = new Object();
      
      public var initialized:Boolean = false;
      
      public var transformCenter:Vector3D;
      
      public var autoCenterTransform:Boolean;
      
      public function AnimateTransformInstance(target:Object)
      {
         super(target);
      }
      
      override public function startEffect() : void
      {
         if(!this.started)
         {
            this.started = true;
            super.startEffect();
         }
      }
      
      private function isValidValue(value:Object) : Boolean
      {
         return value is Number && !isNaN(Number(value)) || !(value is Number) && value !== null;
      }
      
      private function insertKeyframe(keyframes:Vector.<Keyframe>, newKF:Keyframe, startDelay:Number = 0, first:Boolean = false) : void
      {
         newKF.time += startDelay;
         for(var i:int = 0; i < keyframes.length; i++)
         {
            if(keyframes[i].time >= newKF.time)
            {
               if(keyframes[i].time == newKF.time)
               {
                  if(first)
                  {
                     newKF.time += 0.01;
                     keyframes.splice(i + 1,0,newKF);
                  }
                  else
                  {
                     newKF.time -= 0.01;
                     keyframes.splice(i,0,newKF);
                  }
               }
               else
               {
                  keyframes.splice(i,0,newKF);
               }
               return;
            }
         }
         keyframes.push(newKF);
      }
      
      public function addMotionPath(newMotionPath:MotionPath, newEffectStartTime:Number = 0) : void
      {
         var i:int = 0;
         var j:int = 0;
         var mp:MotionPath = null;
         var n:int = 0;
         var deltaStartTime:Number = NaN;
         var kf:Keyframe = null;
         var added:Boolean = false;
         if(Boolean(motionPaths))
         {
            n = int(motionPaths.length);
            if(newEffectStartTime < this.instanceStartTime)
            {
               deltaStartTime = this.instanceStartTime - newEffectStartTime;
               for(i = 0; i < n; i++)
               {
                  mp = MotionPath(motionPaths[i]);
                  for(j = 0; j < mp.keyframes.length; j++)
                  {
                     mp.keyframes[j].time += deltaStartTime;
                  }
               }
               this.instanceStartTime = newEffectStartTime;
            }
            for(i = 0; i < n; i++)
            {
               mp = MotionPath(motionPaths[i]);
               if(mp.property == newMotionPath.property)
               {
                  for(j = 0; j < newMotionPath.keyframes.length; j++)
                  {
                     this.insertKeyframe(mp.keyframes,newMotionPath.keyframes[j],newEffectStartTime - this.instanceStartTime,j == 0);
                  }
                  added = true;
                  break;
               }
            }
         }
         else
         {
            motionPaths = new Vector.<MotionPath>();
            this.instanceStartTime = newEffectStartTime;
         }
         if(!added)
         {
            if(newEffectStartTime > this.instanceStartTime)
            {
               for(j = 0; j < newMotionPath.keyframes.length; j++)
               {
                  newMotionPath.keyframes[j].time += newEffectStartTime - this.instanceStartTime;
               }
            }
            motionPaths.push(newMotionPath);
         }
         n = int(motionPaths.length);
         for(i = 0; i < n; i++)
         {
            mp = MotionPath(motionPaths[i]);
            kf = mp.keyframes[mp.keyframes.length - 1];
            if(!isNaN(kf.time))
            {
               duration = Math.max(duration,kf.time);
            }
         }
      }
      
      private function initProjection() : void
      {
         var parent:DisplayObject = null;
         var parentTransform:Transform = null;
         var p:PerspectiveProjection = null;
         var projectionPoint:Point = null;
         if(this.applyLocalProjection)
         {
            parent = target.parent;
            if(parent != null)
            {
               parentTransform = parent is UIComponent ? UIComponent(parent).$transform : parent.transform;
               this.originalProjection = parentTransform.perspectiveProjection;
               p = new PerspectiveProjection();
               if(!isNaN(this.fieldOfView))
               {
                  p.fieldOfView = this.fieldOfView;
               }
               if(!isNaN(this.focalLength))
               {
                  p.focalLength = this.focalLength;
               }
               if(this.autoCenterProjection)
               {
                  projectionPoint = new Point(target.getLayoutBoundsWidth(false) / 2,target.getLayoutBoundsHeight(false) / 2);
               }
               else
               {
                  projectionPoint = new Point(this.projectionX,this.projectionY);
               }
               projectionPoint = target.localToGlobal(projectionPoint);
               p.projectionCenter = parent.globalToLocal(projectionPoint);
               parentTransform.perspectiveProjection = p;
            }
         }
      }
      
      private function removeProjection() : void
      {
         var parent:DisplayObject = null;
         var parentTransform:Transform = null;
         if(this.applyLocalProjection && this.removeLocalProjectionWhenComplete)
         {
            parent = target.parent as DisplayObject;
            if(parent != null)
            {
               parentTransform = parent is UIComponent ? UIComponent(parent).$transform : parent.transform;
               parentTransform.perspectiveProjection = this.originalProjection;
            }
         }
      }
      
      override public function play() : void
      {
         var s:String = null;
         var has3DRotation:Boolean = false;
         var has2DMove:Boolean = false;
         var p:int = 0;
         var propName:String = null;
         var i:int = 0;
         var j:int = 0;
         var adjustXY:Boolean = false;
         var animProp:MotionPath = null;
         var kf:Keyframe = null;
         var autoPropsEaser:IEaser = null;
         var mp:MotionPath = null;
         var mpDone:Boolean = false;
         var preLayoutProp:String = null;
         var k:int = 0;
         var preLayoutMP:MotionPath = null;
         var m:int = 0;
         var autoProps:Object = new Object();
         if(Boolean(propertyChanges))
         {
            for(s in propertyChanges.end)
            {
               if(this.affectedProperties[s] !== undefined && propertyChanges.end[s] !== undefined && propertyChanges.start[s] !== undefined)
               {
                  if(s != "width" && s != "height" && (s == "postLayoutTranslationX" || s == "postLayoutTranslationY" || s == "postLayoutTranslationZ" || propertyChanges.start[s] != propertyChanges.end[s]))
                  {
                     autoProps[s] = s;
                  }
               }
            }
            if(autoProps["postLayoutTranslationZ"] === undefined && motionPaths != null)
            {
               has3DRotation = false;
               has2DMove = false;
               for(p = 0; p < motionPaths.length; p++)
               {
                  propName = motionPaths[p].property;
                  if(!has3DRotation && (propName == "postLayoutRotationX" || propName == "postLayoutRotationY"))
                  {
                     has3DRotation = true;
                     if(has2DMove)
                     {
                        break;
                     }
                  }
                  else if(!has2DMove && (propName == "translationX" || propName == "translationY"))
                  {
                     has2DMove = true;
                     if(has3DRotation)
                     {
                        break;
                     }
                  }
               }
               if(has3DRotation && has2DMove)
               {
                  autoProps["postLayoutTranslationZ"] = "postLayoutTranslationZ";
               }
            }
         }
         if(Boolean(motionPaths))
         {
            this.updateTransformCenter();
            adjustXY = this.transformCenter.x != 0 || this.transformCenter.y != 0;
            for(i = 0; i < motionPaths.length; i++)
            {
               animProp = motionPaths[i];
               delete autoProps[animProp.property];
               if(adjustXY && (animProp.property == "translationX" || animProp.property == "translationY" || animProp.property == "postLayoutTranslationX" || animProp.property == "postLayoutTranslationY"))
               {
                  for(j = 0; j < animProp.keyframes.length; j++)
                  {
                     kf = animProp.keyframes[j];
                     if(this.isValidValue(kf.value))
                     {
                        if(animProp.property == "translationX" || animProp.property == "postLayoutTranslationX")
                        {
                           kf.value += this.transformCenter.x;
                        }
                        else
                        {
                           kf.value += this.transformCenter.y;
                        }
                     }
                  }
               }
            }
         }
         for(s in autoProps)
         {
            if(!motionPaths)
            {
               motionPaths = new Vector.<MotionPath>();
            }
            if(!autoPropsEaser)
            {
               if(Boolean(motionPaths.length > 0 && motionPaths[0] && motionPaths[0].keyframes) && Boolean(motionPaths[0].keyframes.length > 0) && Boolean(motionPaths[0].keyframes[motionPaths[0].keyframes.length - 1]))
               {
                  autoPropsEaser = motionPaths[0].keyframes[motionPaths[0].keyframes.length - 1].easer;
               }
               else
               {
                  autoPropsEaser = new Linear();
               }
            }
            mp = new MotionPath(s);
            mpDone = false;
            if(s.indexOf("postLayoutTranslation") == 0)
            {
               preLayoutProp = s == "postLayoutTranslationX" ? "translationX" : (s == "postLayoutTranslationY" ? "translationY" : "translationZ");
               k = 0;
               while(true)
               {
                  if(k < motionPaths.length)
                  {
                     preLayoutMP = motionPaths[k];
                     if(preLayoutMP.property == preLayoutProp)
                     {
                        break;
                     }
                     k++;
                     continue;
                  }
               }
               mp.keyframes = new Vector.<Keyframe>(preLayoutMP.keyframes.length);
               for(m = 0; m < mp.keyframes.length; m++)
               {
                  mp.keyframes[m] = preLayoutMP.keyframes[m].clone();
               }
               mpDone = true;
            }
            if(!mpDone)
            {
               mp.keyframes = new <Keyframe>[new Keyframe(0,null),new Keyframe(duration,null)];
               mp.keyframes[1].easer = autoPropsEaser;
               mp.scaleKeyframes(duration);
            }
            motionPaths.push(mp);
         }
         if(Boolean(propertyChanges) && !disableLayout)
         {
            for(s in this.layoutConstraints)
            {
               setupConstraintAnimation(s);
            }
         }
         super.play();
      }
      
      override public function animationStart(animation:Animation) : void
      {
         this.initProjection();
         super.animationStart(animation);
      }
      
      override public function animationEnd(animation:Animation) : void
      {
         this.started = false;
         this.removeProjection();
         super.animationEnd(animation);
      }
      
      private function updateTransformCenter() : void
      {
         if(!this.transformCenter)
         {
            this.transformCenter = new Vector3D(target.transformX,target.transformY,target.transformZ);
         }
         if(this.autoCenterTransform)
         {
            this.transformCenter.x = target.width / 2;
            this.transformCenter.y = target.height / 2;
            this.transformCenter.z = 0;
         }
      }
      
      override protected function getCurrentValue(property:String) : *
      {
         var position:Vector3D = null;
         var postLayoutPosition:Vector3D = null;
         switch(property)
         {
            case "translationX":
            case "translationY":
            case "translationZ":
               position = new Vector3D();
               this.updateTransformCenter();
               target.transformPointToParent(this.transformCenter,position,null);
               if(property == "translationX")
               {
                  return position.x;
               }
               if(property == "translationY")
               {
                  return position.y;
               }
               if(property == "translationZ")
               {
                  return position.z;
               }
               break;
            case "postLayoutTranslationX":
            case "postLayoutTranslationY":
            case "postLayoutTranslationZ":
               postLayoutPosition = new Vector3D();
               this.updateTransformCenter();
               target.transformPointToParent(this.transformCenter,null,postLayoutPosition);
               if(property == "postLayoutTranslationX")
               {
                  return postLayoutPosition.x;
               }
               if(property == "postLayoutTranslationY")
               {
                  return postLayoutPosition.y;
               }
               if(property == "postLayoutTranslationZ")
               {
                  return postLayoutPosition.z;
               }
               break;
            case "postLayoutRotationX":
               return target.postLayoutTransformOffsets == null ? 0 : target.postLayoutTransformOffsets.rotationX;
            case "postLayoutRotationY":
               return target.postLayoutTransformOffsets == null ? 0 : target.postLayoutTransformOffsets.rotationY;
            case "postLayoutRotationZ":
               return target.postLayoutTransformOffsets == null ? 0 : target.postLayoutTransformOffsets.rotationZ;
            case "postLayoutScaleX":
               return target.postLayoutTransformOffsets == null ? 1 : target.postLayoutTransformOffsets.scaleX;
            case "postLayoutScaleY":
               return target.postLayoutTransformOffsets == null ? 1 : target.postLayoutTransformOffsets.scaleY;
            case "postLayoutScaleZ":
               return target.postLayoutTransformOffsets == null ? 1 : target.postLayoutTransformOffsets.scaleZ;
            default:
               return super.getCurrentValue(property);
         }
      }
      
      override protected function applyValues(anim:Animation) : void
      {
         var tmpScale:Vector3D = null;
         var tmpPosition:Vector3D = null;
         var tmpRotation:Vector3D = null;
         var tmpOffsetTranslation:Vector3D = null;
         var tmpOffsetRotation:Vector3D = null;
         var tmpOffsetScale:Vector3D = null;
         for(var i:int = 0; i < motionPaths.length; i++)
         {
            if(this.currentValues[motionPaths[i].property] !== undefined)
            {
               this.currentValues[motionPaths[i].property] = anim.currentValue[motionPaths[i].property];
            }
            else
            {
               setValue(motionPaths[i].property,anim.currentValue[motionPaths[i].property]);
            }
         }
         if(this.autoCenterTransform)
         {
            if(!disableLayout && target.parent is Group)
            {
               target.parent.validateNow();
            }
            if(target.width != this.prevWidth || target.height != this.prevHeight)
            {
               this.prevWidth = target.width;
               this.prevHeight = target.height;
               this.updateTransformCenter();
            }
         }
         if(!isNaN(this.currentValues.scaleX) || !isNaN(this.currentValues.scaleY) || !isNaN(this.currentValues.scaleZ))
         {
            scale.x = !isNaN(this.currentValues.scaleX) ? Number(this.currentValues.scaleX) : Number(target["scaleX"]);
            scale.y = !isNaN(this.currentValues.scaleY) ? Number(this.currentValues.scaleY) : Number(target["scaleY"]);
            scale.z = !isNaN(this.currentValues.scaleZ) ? Number(this.currentValues.scaleZ) : Number(target["scaleZ"]);
            tmpScale = scale;
         }
         if(!isNaN(this.currentValues.rotationX) || !isNaN(this.currentValues.rotationY) || !isNaN(this.currentValues.rotationZ))
         {
            rotation.x = !isNaN(this.currentValues.rotationX) ? Number(this.currentValues.rotationX) : Number(this.getCurrentValue("rotationX"));
            rotation.y = !isNaN(this.currentValues.rotationY) ? Number(this.currentValues.rotationY) : Number(this.getCurrentValue("rotationY"));
            rotation.z = !isNaN(this.currentValues.rotationZ) ? Number(this.currentValues.rotationZ) : Number(this.getCurrentValue("rotationZ"));
            tmpRotation = rotation;
         }
         position.x = !isNaN(this.currentValues.translationX) ? Number(this.currentValues.translationX) : Number(this.getCurrentValue("translationX"));
         position.y = !isNaN(this.currentValues.translationY) ? Number(this.currentValues.translationY) : Number(this.getCurrentValue("translationY"));
         position.z = !isNaN(this.currentValues.translationZ) ? Number(this.currentValues.translationZ) : Number(this.getCurrentValue("translationZ"));
         tmpPosition = position;
         if(target.postLayoutTransformOffsets != null)
         {
            if(!isNaN(this.currentValues.postLayoutRotationX) || !isNaN(this.currentValues.postLayoutRotationY) || !isNaN(this.currentValues.postLayoutRotationZ))
            {
               offsetRotation.x = !isNaN(this.currentValues.postLayoutRotationX) ? Number(this.currentValues.postLayoutRotationX) : Number(this.getCurrentValue("postLayoutRotationX"));
               offsetRotation.y = !isNaN(this.currentValues.postLayoutRotationY) ? Number(this.currentValues.postLayoutRotationY) : Number(this.getCurrentValue("postLayoutRotationY"));
               offsetRotation.z = !isNaN(this.currentValues.postLayoutRotationZ) ? Number(this.currentValues.postLayoutRotationZ) : Number(this.getCurrentValue("postLayoutRotationZ"));
               tmpOffsetRotation = offsetRotation;
            }
            if(!isNaN(this.currentValues.postLayoutScaleX) || !isNaN(this.currentValues.postLayoutScaleY) || !isNaN(this.currentValues.postLayoutScaleZ))
            {
               offsetScale.x = !isNaN(this.currentValues.postLayoutScaleX) ? Number(this.currentValues.postLayoutScaleX) : Number(this.getCurrentValue("postLayoutScaleX"));
               offsetScale.y = !isNaN(this.currentValues.postLayoutScaleY) ? Number(this.currentValues.postLayoutScaleY) : Number(this.getCurrentValue("postLayoutScaleY"));
               offsetScale.z = !isNaN(this.currentValues.postLayoutScaleZ) ? Number(this.currentValues.postLayoutScaleZ) : Number(this.getCurrentValue("postLayoutScaleZ"));
               tmpOffsetScale = offsetScale;
            }
            if(!isNaN(this.currentValues.postLayoutTranslationX) || !isNaN(this.currentValues.postLayoutTranslationY) || !isNaN(this.currentValues.postLayoutTranslationZ))
            {
               offsetTranslation.x = !isNaN(this.currentValues.postLayoutTranslationX) ? Number(this.currentValues.postLayoutTranslationX) : Number(this.getCurrentValue("postLayoutTranslationX"));
               offsetTranslation.y = !isNaN(this.currentValues.postLayoutTranslationY) ? Number(this.currentValues.postLayoutTranslationY) : Number(this.getCurrentValue("postLayoutTranslationY"));
               offsetTranslation.z = !isNaN(this.currentValues.postLayoutTranslationZ) ? Number(this.currentValues.postLayoutTranslationZ) : Number(this.getCurrentValue("postLayoutTranslationZ"));
               tmpOffsetTranslation = offsetTranslation;
            }
            else
            {
               tmpOffsetTranslation = tmpPosition;
            }
         }
         target.transformAround(this.transformCenter,tmpScale,tmpRotation,tmpPosition,tmpOffsetScale,tmpOffsetRotation,tmpOffsetTranslation);
      }
   }
}

