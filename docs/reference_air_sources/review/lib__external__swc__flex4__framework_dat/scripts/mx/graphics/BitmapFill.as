package mx.graphics
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.geom.CompoundTransform;
   import mx.utils.MatrixUtil;
   
   use namespace mx_internal;
   
   public class BitmapFill extends EventDispatcher implements IFill
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
      
      private static var transformMatrix:Matrix = new Matrix();
      
      private var nonRepeatAlphaSource:BitmapData;
      
      private var _bitmapData:BitmapData;
      
      private var regenerateNonRepeatSource:Boolean = true;
      
      private var lastBoundsWidth:Number = 0;
      
      private var lastBoundsHeight:Number = 0;
      
      private var applyAlphaMultiplier:Boolean = false;
      
      private var nonRepeatSourceCreated:Boolean = false;
      
      private var bitmapDataCreated:Boolean = false;
      
      private var _alpha:Number = 1;
      
      protected var compoundTransform:CompoundTransform;
      
      private var _originX:Number = 0;
      
      private var _originY:Number = 0;
      
      protected var _fillMode:String = "scale";
      
      private var _rotation:Number = 0;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _source:Object;
      
      private var _smooth:Boolean = false;
      
      private var _transformX:Number = 0;
      
      private var _transformY:Number = 0;
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function BitmapFill()
      {
         super();
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         var s:Object = null;
         if(this._alpha == value)
         {
            return;
         }
         var oldValue:Number = this._alpha;
         this._alpha = value;
         this.applyAlphaMultiplier = true;
         if(Boolean(this._bitmapData && !this._bitmapData.transparent) && Boolean(this._alpha < 1) && oldValue == 1)
         {
            s = this._source;
            this._source = null;
            this.source = s;
         }
         this.dispatchFillChangedEvent("alpha",oldValue,value);
      }
      
      [Inspectable(category="General")]
      public function get matrix() : Matrix
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.matrix : null;
      }
      
      public function set matrix(value:Matrix) : void
      {
         var oldValue:Matrix = this.matrix;
         var oldX:Number = this.x;
         var oldY:Number = this.y;
         var oldRotation:Number = this.rotation;
         var oldScaleX:Number = this.scaleX;
         var oldScaleY:Number = this.scaleY;
         if(value == null)
         {
            this.compoundTransform = null;
         }
         else
         {
            if(this.compoundTransform == null)
            {
               this.compoundTransform = new CompoundTransform();
            }
            this.compoundTransform.matrix = value;
            this.dispatchFillChangedEvent("x",oldX,this.compoundTransform.x);
            this.dispatchFillChangedEvent("y",oldY,this.compoundTransform.y);
            this.dispatchFillChangedEvent("scaleX",oldScaleX,this.compoundTransform.scaleX);
            this.dispatchFillChangedEvent("scaleY",oldScaleY,this.compoundTransform.scaleY);
            this.dispatchFillChangedEvent("rotation",oldRotation,this.compoundTransform.rotationZ);
         }
      }
      
      [Deprecated(replacement="transformX",since="4.0")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get originX() : Number
      {
         return this.transformX;
      }
      
      public function set originX(value:Number) : void
      {
         this.transformX = value;
      }
      
      [Deprecated(replacement="transformY",since="4.0")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get originY() : Number
      {
         return this.transformY;
      }
      
      public function set originY(value:Number) : void
      {
         this.transformY = value;
      }
      
      [Deprecated(replacement="x",since="4.0")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get offsetX() : Number
      {
         return isNaN(this.x) ? 0 : this.x;
      }
      
      public function set offsetX(value:Number) : void
      {
         var oldValue:Number = isNaN(this.x) ? 0 : this.x;
         this.x = value;
         this.dispatchFillChangedEvent("offsetX",oldValue,value);
      }
      
      [Deprecated(replacement="y",since="4.0")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get offsetY() : Number
      {
         return isNaN(this.y) ? 0 : this.y;
      }
      
      public function set offsetY(value:Number) : void
      {
         var oldValue:Number = isNaN(this.y) ? 0 : this.y;
         this.y = value;
         this.dispatchFillChangedEvent("offsetY",oldValue,value);
      }
      
      [Deprecated(replacement="fillMode",since="4.0")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get repeat() : Boolean
      {
         return this._fillMode == BitmapFillMode.REPEAT;
      }
      
      public function set repeat(value:Boolean) : void
      {
         var oldValue:Boolean = this._fillMode == BitmapFillMode.REPEAT;
         if(value != oldValue)
         {
            this.fillMode = value ? BitmapFillMode.REPEAT : BitmapFillMode.SCALE;
            this.dispatchFillChangedEvent("repeat",oldValue,value);
         }
      }
      
      [Inspectable(category="General",enumeration="clip,repeat,scale",defaultValue="scale")]
      public function get fillMode() : String
      {
         return this._fillMode;
      }
      
      public function set fillMode(value:String) : void
      {
         var oldValue:String = this._fillMode;
         if(value != this._fillMode)
         {
            this._fillMode = value;
            this.dispatchFillChangedEvent("fillMode",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rotation() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.rotationZ : this._rotation;
      }
      
      public function set rotation(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.rotation)
         {
            oldValue = this.rotation;
            if(Boolean(this.compoundTransform))
            {
               this.compoundTransform.rotationZ = value;
            }
            else
            {
               this._rotation = value;
            }
            this.dispatchFillChangedEvent("rotation",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get scaleX() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.scaleX : this._scaleX;
      }
      
      public function set scaleX(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.scaleX)
         {
            oldValue = this.scaleX;
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.scaleX = value;
               }
            }
            else
            {
               this._scaleX = value;
            }
            this.dispatchFillChangedEvent("scaleX",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get scaleY() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.scaleY : this._scaleY;
      }
      
      public function set scaleY(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.scaleY)
         {
            oldValue = this.scaleY;
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.scaleY = value;
               }
            }
            else
            {
               this._scaleY = value;
            }
            this.dispatchFillChangedEvent("scaleY",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         var tmpSprite:DisplayObject = null;
         var oldValue:Object = null;
         var bitmapData:BitmapData = null;
         var bitmapCreated:Boolean = false;
         var cls:Class = null;
         var transparentBitmap:BitmapData = null;
         if(value != this._source)
         {
            oldValue = this._source;
            this._source = value;
            bitmapCreated = false;
            if(value is Class)
            {
               cls = Class(value);
               value = new cls();
               bitmapCreated = true;
            }
            if(value is BitmapData)
            {
               bitmapData = BitmapData(value);
            }
            else if(value is Bitmap)
            {
               bitmapData = value.bitmapData;
            }
            else if(value is DisplayObject)
            {
               tmpSprite = value as DisplayObject;
            }
            else if(value != null)
            {
               return;
            }
            if(!bitmapData && Boolean(tmpSprite))
            {
               bitmapData = new BitmapData(tmpSprite.width,tmpSprite.height,true,0);
               bitmapData.draw(tmpSprite,new Matrix());
               bitmapCreated = true;
            }
            if(Boolean(bitmapData) && Boolean(!bitmapData.transparent) && this.alpha != 1)
            {
               transparentBitmap = new BitmapData(bitmapData.width,bitmapData.height,true);
               transparentBitmap.draw(bitmapData);
               bitmapCreated = true;
               bitmapData = transparentBitmap;
            }
            this.setBitmapData(bitmapData,bitmapCreated);
            this.dispatchFillChangedEvent("source",oldValue,value);
         }
      }
      
      [Bindable("propertyChange")]
      [Inspectable(category="General")]
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(value:Boolean) : void
      {
         var oldValue:Boolean = this._smooth;
         if(value != oldValue)
         {
            this._smooth = value;
            this.dispatchFillChangedEvent("smooth",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      public function get transformX() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.transformX : this._transformX;
      }
      
      public function set transformX(value:Number) : void
      {
         if(this.transformX == value)
         {
            return;
         }
         var oldValue:Number = this.transformX;
         if(Boolean(this.compoundTransform))
         {
            this.compoundTransform.transformX = value;
         }
         else
         {
            this._transformX = value;
         }
         this.dispatchFillChangedEvent("transformX",oldValue,value);
      }
      
      [Inspectable(category="General")]
      public function get transformY() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.transformY : this._transformY;
      }
      
      public function set transformY(value:Number) : void
      {
         if(this.transformY == value)
         {
            return;
         }
         var oldValue:Number = this.transformY;
         if(Boolean(this.compoundTransform))
         {
            this.compoundTransform.transformY = value;
         }
         else
         {
            this._transformY = value;
         }
         this.dispatchFillChangedEvent("transformY",oldValue,value);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get x() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.x : this._x;
      }
      
      public function set x(value:Number) : void
      {
         var oldValue:Number = this.x;
         if(value != oldValue)
         {
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.x = value;
               }
            }
            else
            {
               this._x = value;
            }
            this.dispatchFillChangedEvent("x",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get y() : Number
      {
         return Boolean(this.compoundTransform) ? this.compoundTransform.y : this._y;
      }
      
      public function set y(value:Number) : void
      {
         var oldValue:Number = this.y;
         if(value != oldValue)
         {
            if(Boolean(this.compoundTransform))
            {
               if(!isNaN(value))
               {
                  this.compoundTransform.y = value;
               }
            }
            else
            {
               this._y = value;
            }
            this.dispatchFillChangedEvent("y",oldValue,value);
         }
      }
      
      public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         var defaultScaleX:Number = NaN;
         var defaultScaleY:Number = NaN;
         var regX:Number = NaN;
         var regY:Number = NaN;
         var bitmapTopLeft:Point = null;
         var tx:Number = NaN;
         var ty:Number = NaN;
         var bitmapSize:Point = null;
         var newW:Number = NaN;
         var newY:Number = NaN;
         var ct:ColorTransform = null;
         var sourceAsBitmapData:BitmapData = this._bitmapData;
         if(!sourceAsBitmapData)
         {
            return;
         }
         var repeatFill:Boolean = this.fillMode == BitmapFillMode.REPEAT;
         if(Boolean(this.nonRepeatAlphaSource) && this.applyAlphaMultiplier)
         {
            this.nonRepeatAlphaSource.dispose();
            this.nonRepeatAlphaSource = null;
         }
         if(Boolean(this.compoundTransform))
         {
            transformMatrix = this.compoundTransform.matrix;
            transformMatrix.translate(targetOrigin.x,targetOrigin.y);
         }
         else
         {
            defaultScaleX = this.scaleX;
            defaultScaleY = this.scaleY;
            if(this.fillMode == BitmapFillMode.SCALE)
            {
               if(isNaN(this.scaleX) && sourceAsBitmapData.width > 0)
               {
                  defaultScaleX = targetBounds.width / sourceAsBitmapData.width;
               }
               if(isNaN(this.scaleY) && sourceAsBitmapData.height > 0)
               {
                  defaultScaleY = targetBounds.height / sourceAsBitmapData.height;
               }
            }
            if(isNaN(defaultScaleX))
            {
               defaultScaleX = 1;
            }
            if(isNaN(defaultScaleY))
            {
               defaultScaleY = 1;
            }
            regX = !isNaN(this.x) ? this.x + targetOrigin.x : targetBounds.left;
            regY = !isNaN(this.y) ? this.y + targetOrigin.y : targetBounds.top;
            transformMatrix.identity();
            transformMatrix.translate(-this.transformX,-this.transformY);
            transformMatrix.scale(defaultScaleX,defaultScaleY);
            transformMatrix.rotate(this.rotation * RADIANS_PER_DEGREES);
            transformMatrix.translate(regX + this.transformX,regY + this.transformY);
         }
         if(repeatFill || MatrixUtil.isDeltaIdentity(transformMatrix) && transformMatrix.tx == targetBounds.left && transformMatrix.ty == targetBounds.top && targetBounds.width <= sourceAsBitmapData.width && targetBounds.height <= sourceAsBitmapData.height)
         {
            if(Boolean(this.nonRepeatAlphaSource) && this.nonRepeatSourceCreated)
            {
               this.nonRepeatAlphaSource.dispose();
               this.nonRepeatAlphaSource = null;
               this.applyAlphaMultiplier = this.alpha != 1;
            }
            this.nonRepeatSourceCreated = false;
         }
         else if(this.fillMode == BitmapFillMode.CLIP)
         {
            if(this.regenerateNonRepeatSource || this.lastBoundsWidth != targetBounds.width || this.lastBoundsHeight != targetBounds.height)
            {
               if(Boolean(this.nonRepeatAlphaSource))
               {
                  this.nonRepeatAlphaSource.dispose();
               }
               bitmapTopLeft = new Point();
               tx = transformMatrix.tx;
               ty = transformMatrix.ty;
               transformMatrix.tx = 0;
               transformMatrix.ty = 0;
               bitmapSize = MatrixUtil.transformBounds(sourceAsBitmapData.width,sourceAsBitmapData.height,transformMatrix,bitmapTopLeft);
               newW = Math.ceil(bitmapSize.x) + 2;
               newY = Math.ceil(bitmapSize.y) + 2;
               transformMatrix.translate(1 - bitmapTopLeft.x,1 - bitmapTopLeft.y);
               this.nonRepeatAlphaSource = new BitmapData(newW,newY,true,16777215);
               this.nonRepeatAlphaSource.draw(sourceAsBitmapData,transformMatrix,null,null,null,this.smooth);
               transformMatrix.identity();
               transformMatrix.translate(tx + bitmapTopLeft.x - 1,ty + bitmapTopLeft.y - 1);
               this.lastBoundsWidth = targetBounds.width;
               this.lastBoundsHeight = targetBounds.height;
               this.nonRepeatSourceCreated = true;
               this.applyAlphaMultiplier = this.alpha != 1;
            }
         }
         if(this.applyAlphaMultiplier)
         {
            if(!this.nonRepeatAlphaSource)
            {
               this.nonRepeatAlphaSource = sourceAsBitmapData.clone();
            }
            ct = new ColorTransform();
            ct.alphaMultiplier = this.alpha;
            this.nonRepeatAlphaSource.colorTransform(new Rectangle(0,0,this.nonRepeatAlphaSource.width,this.nonRepeatAlphaSource.height),ct);
            this.applyAlphaMultiplier = false;
         }
         if(Boolean(this.nonRepeatAlphaSource))
         {
            sourceAsBitmapData = this.nonRepeatAlphaSource;
         }
         target.beginBitmapFill(sourceAsBitmapData,transformMatrix,repeatFill,this.smooth);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
      
      private function dispatchFillChangedEvent(prop:String, oldValue:*, value:*) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
         this.regenerateNonRepeatSource = true;
      }
      
      private function setBitmapData(bitmapData:BitmapData, internallyCreated:Boolean = false) : void
      {
         if(Boolean(this._bitmapData))
         {
            if(this.bitmapDataCreated)
            {
               this._bitmapData.dispose();
            }
            this._bitmapData = null;
         }
         this.bitmapDataCreated = internallyCreated;
         this.applyAlphaMultiplier = this.alpha != 1;
         this._bitmapData = bitmapData;
         this.dispatchFillChangedEvent("bitmapData",null,null);
      }
   }
}

