package spark.effects.supportClasses
{
   import flash.display.BitmapData;
   import flash.display.Shader;
   import flash.filters.ShaderFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import mx.core.IUIComponent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.effects.animation.Animation;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.primitives.supportClasses.GraphicElement;
   import spark.utils.BitmapUtil;
   
   public class AnimateTransitionShaderInstance extends AnimateInstance
   {
      
      private static var _resourceManager:IResourceManager;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var disposeFrom:Boolean;
      
      private var disposeTo:Boolean;
      
      public var bitmapFrom:BitmapData;
      
      public var bitmapTo:BitmapData;
      
      public var shaderByteCode:ByteArray;
      
      public var shaderProperties:Object;
      
      protected var shader:Shader;
      
      private var hasBitmaps:Boolean = true;
      
      protected var shaderFilter:ShaderFilter;
      
      public function AnimateTransitionShaderInstance(target:Object)
      {
         super(target);
         autoRemoveTarget = true;
      }
      
      private static function get resourceManager() : IResourceManager
      {
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
         }
         return _resourceManager;
      }
      
      override public function play() : void
      {
         var boundsFrom:Rectangle = null;
         var boundsTo:Rectangle = null;
         var bmHolder:Object = null;
         var newX:Number = NaN;
         var newY:Number = NaN;
         var newW:Number = NaN;
         var newH:Number = NaN;
         var newBitmapFrom:BitmapData = null;
         var prop:String = null;
         var value:Object = null;
         this.disposeFrom = this.bitmapFrom == null;
         this.disposeTo = this.bitmapTo == null;
         if(Boolean(!this.bitmapFrom) && Boolean(propertyChanges) && propertyChanges.start["bitmapInfo"] !== undefined)
         {
            bmHolder = propertyChanges.start["bitmapInfo"];
            if(Boolean(bmHolder))
            {
               this.bitmapFrom = bmHolder["bitmap"];
               boundsFrom = bmHolder["bounds"];
            }
         }
         if(Boolean(!this.bitmapTo) && Boolean(propertyChanges) && propertyChanges.end["bitmapInfo"] !== undefined)
         {
            bmHolder = propertyChanges.end["bitmapInfo"];
            if(Boolean(bmHolder))
            {
               this.bitmapTo = bmHolder["bitmap"];
               boundsTo = bmHolder["bounds"];
            }
         }
         if(!this.bitmapFrom)
         {
            if(Boolean(propertyChanges) && (propertyChanges.start["visible"] == false || propertyChanges.start["parent"] == null))
            {
               if(Boolean(this.bitmapTo))
               {
                  this.bitmapFrom = new BitmapData(this.bitmapTo.width,this.bitmapTo.height,true,0);
               }
            }
         }
         if(!this.bitmapTo)
         {
            if(Boolean(propertyChanges) && (propertyChanges.end["visible"] == false || propertyChanges.end["parent"] == null))
            {
               if(Boolean(this.bitmapFrom))
               {
                  this.bitmapTo = new BitmapData(this.bitmapFrom.width,this.bitmapFrom.height,true,0);
               }
            }
         }
         if(!this.bitmapFrom)
         {
            this.bitmapFrom = this.getSnapshot(target);
         }
         if(!this.bitmapTo)
         {
            this.bitmapTo = this.getSnapshot(target);
         }
         if(!this.bitmapFrom || !this.bitmapTo)
         {
            this.hasBitmaps = false;
            if(Boolean(this.bitmapFrom))
            {
               this.bitmapFrom.dispose();
            }
            else if(Boolean(this.bitmapTo))
            {
               this.bitmapTo.dispose();
            }
         }
         else
         {
            this.hasBitmaps = true;
         }
         if(Boolean(propertyChanges) && Boolean(!propertyChanges.start["visible"]) && Boolean(propertyChanges.end["visible"]))
         {
            target.visible = true;
         }
         if(this.hasBitmaps)
         {
            this.shader = new Shader(this.shaderByteCode);
            if(Boolean(this.shader.data))
            {
               if(Boolean(boundsFrom) && Boolean(boundsTo) && (boundsFrom.x != boundsTo.x || boundsFrom.y != boundsTo.y))
               {
                  newX = boundsTo.x - boundsFrom.x;
                  newY = boundsTo.y - boundsFrom.y;
                  newW = boundsFrom.width - newX;
                  newH = boundsFrom.height - newY;
                  newBitmapFrom = new BitmapData(newW,newH,true,0);
                  newBitmapFrom.copyPixels(this.bitmapFrom,new Rectangle(newX,newY,newW,newH),new Point(0,0));
                  if(this.disposeFrom)
                  {
                     this.bitmapFrom.dispose();
                  }
                  this.bitmapFrom = newBitmapFrom;
               }
               this.shader.data.from.input = this.bitmapFrom;
               this.shader.data.to.input = this.bitmapTo;
               motionPaths = new <MotionPath>[new MotionPath("progress")];
               motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,0),new Keyframe(duration,1)];
               if("width" in this.shader.data)
               {
                  this.shader.data.width.value = [Math.max(this.bitmapFrom.width,this.bitmapTo.width)];
               }
               if("height" in this.shader.data)
               {
                  this.shader.data.height.value = [Math.max(this.bitmapFrom.height,this.bitmapTo.height)];
               }
               if(Boolean(this.shaderProperties))
               {
                  for(prop in this.shaderProperties)
                  {
                     value = this.shaderProperties[prop];
                     this.shader.data[prop].value = value is Array ? value : [value];
                  }
               }
               this.shaderFilter = new ShaderFilter(this.shader);
            }
         }
         super.play();
      }
      
      private function getSnapshot(target:Object) : BitmapData
      {
         var bmData:BitmapData = null;
         if(!(target is GraphicElement || target is IUIComponent))
         {
            throw new Error(resourceManager.getString("sparkEffects","cannotOperateOn"));
         }
         var tempFilters:Array = target.filters;
         target.filters = [];
         try
         {
            if(target is GraphicElement)
            {
               bmData = GraphicElement(target).captureBitmapData(true,0,false);
            }
            else
            {
               bmData = BitmapUtil.getSnapshot(IUIComponent(target),null,true);
            }
         }
         catch(e:SecurityError)
         {
         }
         target.filters = tempFilters;
         return bmData;
      }
      
      override protected function setValue(property:String, value:Object) : void
      {
         if(!this.hasBitmaps)
         {
            return;
         }
         this.shader.data.progress.value = [value];
         target.filters = [this.shaderFilter].concat(this.acquireFilters());
      }
      
      override public function animationStart(animation:Animation) : void
      {
         super.animationStart(animation);
         if(!this.hasBitmaps)
         {
            return;
         }
         target.filters = [this.shaderFilter].concat(target.filters);
      }
      
      private function cleanup() : void
      {
         if(!this.hasBitmaps)
         {
            return;
         }
         target.filters = this.acquireFilters();
         if(this.disposeFrom)
         {
            this.bitmapFrom.dispose();
         }
         if(this.disposeTo)
         {
            this.bitmapTo.dispose();
         }
      }
      
      private function acquireFilters() : Array
      {
         var filters:Array = target.filters;
         for(var i:int = 0; i < filters.length; i++)
         {
            if(filters[i] == this.shaderFilter)
            {
               filters.splice(i,1);
               break;
            }
         }
         return filters;
      }
      
      override public function animationEnd(animation:Animation) : void
      {
         this.cleanup();
         super.animationEnd(animation);
      }
      
      override public function animationStop(animation:Animation) : void
      {
         this.cleanup();
         super.animationStop(animation);
      }
      
      override protected function getCurrentValue(property:String) : *
      {
         if(!this.hasBitmaps)
         {
            return null;
         }
         return this.shader[property];
      }
      
      override protected function setupStyleMapEntry(property:String) : void
      {
      }
   }
}

