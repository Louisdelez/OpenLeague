package com.greensock.motionPaths
{
   import flash.display.Shape;
   import flash.events.Event;
   
   public class MotionPath extends Shape
   {
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected static const _DEG2RAD:Number = Math.PI / 180;
      
      protected var _progress:Number;
      
      protected var _scaleMode:String;
      
      protected var _redrawLine:Boolean;
      
      protected var _rawProgress:Number;
      
      protected var _caps:String;
      
      protected var _lineAlpha:Number;
      
      protected var _joints:String;
      
      protected var _miterLimit:Number;
      
      protected var _color:uint;
      
      protected var _pixelHinting:Boolean;
      
      protected var _thickness:Number;
      
      protected var _rootFollower:PathFollower;
      
      public function MotionPath()
      {
         super();
         _progress = _rawProgress = 0;
         lineStyle(1,6710886,1,false,"none",null,null,3,true);
         this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage,false,0,true);
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         update();
      }
      
      public function get targets() : Array
      {
         var a:Array = [];
         var cnt:uint = 0;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            a[cnt++] = f.target;
            f = f.cachedNext;
         }
         return a;
      }
      
      public function get rawProgress() : Number
      {
         return _rawProgress;
      }
      
      public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         update();
      }
      
      public function getFollower(target:Object) : PathFollower
      {
         if(target is PathFollower)
         {
            return target as PathFollower;
         }
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            if(f.target == target)
            {
               return f;
            }
            f = f.cachedNext;
         }
         return null;
      }
      
      protected function _normalize(num:Number) : Number
      {
         if(num > 1)
         {
            num -= int(num);
         }
         else if(num < 0)
         {
            num -= int(num) - 1;
         }
         return num;
      }
      
      public function lineStyle(thickness:Number = 1, color:uint = 6710886, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "none", caps:String = null, joints:String = null, miterLimit:Number = 3, skipRedraw:Boolean = false) : void
      {
         _thickness = thickness;
         _color = color;
         _lineAlpha = alpha;
         _pixelHinting = pixelHinting;
         _scaleMode = scaleMode;
         _caps = caps;
         _joints = joints;
         _miterLimit = miterLimit;
         _redrawLine = true;
         if(!skipRedraw)
         {
            update();
         }
      }
      
      override public function set scaleY(value:Number) : void
      {
         super.scaleY = value;
         update();
      }
      
      public function removeAllFollowers() : void
      {
         var next:PathFollower = null;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            next = f.cachedNext;
            f.cachedNext = f.cachedPrev = null;
            f.path = null;
            f = next;
         }
         _rootFollower = null;
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         update();
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
         update();
      }
      
      public function get followers() : Array
      {
         var a:Array = [];
         var cnt:uint = 0;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            a[cnt++] = f;
            f = f.cachedNext;
         }
         return a;
      }
      
      override public function get height() : Number
      {
         return super.height;
      }
      
      public function get progress() : Number
      {
         return _progress;
      }
      
      public function removeFollower(target:*) : void
      {
         var f:PathFollower = getFollower(target);
         if(f == null)
         {
            return;
         }
         if(Boolean(f.cachedNext))
         {
            f.cachedNext.cachedPrev = f.cachedPrev;
         }
         if(Boolean(f.cachedPrev))
         {
            f.cachedPrev.cachedNext = f.cachedNext;
         }
         else if(_rootFollower == f)
         {
            _rootFollower = f.cachedNext;
         }
         f.cachedNext = f.cachedPrev = null;
         f.path = null;
      }
      
      override public function get width() : Number
      {
         return super.width;
      }
      
      public function update(event:Event = null) : void
      {
      }
      
      override public function get scaleX() : Number
      {
         return super.scaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.scaleY;
      }
      
      public function set progress(value:Number) : void
      {
         if(value > 1)
         {
            _rawProgress = value;
            value -= int(value);
            if(value == 0)
            {
               value = 1;
            }
         }
         else if(value < 0)
         {
            _rawProgress = value;
            value -= int(value) - 1;
         }
         else
         {
            _rawProgress = int(_rawProgress) + value;
         }
         var dif:Number = value - _progress;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            f.cachedProgress += dif;
            f.cachedRawProgress += dif;
            if(f.cachedProgress > 1)
            {
               f.cachedProgress -= int(f.cachedProgress);
               if(f.cachedProgress == 0)
               {
                  f.cachedProgress = 1;
               }
            }
            else if(f.cachedProgress < 0)
            {
               f.cachedProgress -= int(f.cachedProgress) - 1;
            }
            f = f.cachedNext;
         }
         _progress = value;
         update();
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         update();
      }
      
      public function addFollower(target:*, progress:Number = 0, autoRotate:Boolean = false, rotationOffset:Number = 0) : PathFollower
      {
         var f:PathFollower = getFollower(target);
         if(f == null)
         {
            f = new PathFollower(target);
         }
         f.autoRotate = autoRotate;
         f.rotationOffset = rotationOffset;
         if(f.path != this)
         {
            if(Boolean(_rootFollower))
            {
               _rootFollower.cachedPrev = f;
            }
            f.cachedNext = _rootFollower;
            _rootFollower = f;
            f.path = this;
            f.progress = progress;
         }
         return f;
      }
      
      public function distribute(targets:Array = null, min:Number = 0, max:Number = 1, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
         var f:PathFollower = null;
         if(targets == null)
         {
            targets = this.followers;
         }
         min = _normalize(min);
         max = _normalize(max);
         var i:int = int(targets.length);
         var space:Number = i > 1 ? (max - min) / (i - 1) : 1;
         while(--i > -1)
         {
            f = getFollower(targets[i]);
            if(f == null)
            {
               f = this.addFollower(targets[i],0,autoRotate,rotationOffset);
            }
            f.cachedProgress = f.cachedRawProgress = min + space * i;
            this.renderObjectAt(f.target,f.cachedProgress,autoRotate,rotationOffset);
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         _redrawLine = true;
         update();
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         update();
      }
      
      public function set rawProgress(value:Number) : void
      {
         this.progress = value;
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      override public function set rotation(value:Number) : void
      {
         super.rotation = value;
         update();
      }
      
      override public function get rotation() : Number
      {
         return super.rotation;
      }
   }
}

