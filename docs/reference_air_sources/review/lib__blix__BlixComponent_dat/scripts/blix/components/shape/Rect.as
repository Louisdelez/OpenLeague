package blix.components.shape
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.components.shape.fill.BitmapFill;
   import blix.components.shape.fill.GradientFill;
   import blix.components.shape.fill.ShaderFill;
   import blix.context.IContext;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   
   public class Rect extends DisplayObjectProxy
   {
      
      protected var _topLeftRadius:Number = 0;
      
      protected var _topRightRadius:Number = 0;
      
      protected var _bottomLeftRadius:Number = 0;
      
      protected var _bottomRightRadius:Number = 0;
      
      protected var _ellipseWidth:Number = 0;
      
      protected var _ellipseHeight:Number = 0;
      
      protected var _gradientFill:GradientFill;
      
      protected var _bitmapFill:BitmapFill;
      
      protected var _shaderFill:ShaderFill;
      
      protected var _shape:Shape;
      
      protected var _alpha:Number = 1;
      
      protected var _color:uint;
      
      public function Rect(param1:IContext)
      {
         super(param1);
         if(this._shape == null)
         {
            this._shape = new Shape();
         }
         setAsset(this._shape);
      }
      
      public function getShape() : Shape
      {
         return this._shape;
      }
      
      override public function setAvailableSize(param1:Number, param2:Number) : SizeConstraints
      {
         return new SizeConstraints(new MinMax(1,10000),new MinMax(1,10000));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = param1;
         if(isNaN(_loc3_) || _loc3_ < 0.01 && _loc3_ > -0.01)
         {
            _loc3_ = 0.01;
         }
         var _loc4_:Number = param2;
         if(isNaN(_loc4_) || _loc4_ < 0.01 && _loc4_ > -0.01)
         {
            _loc4_ = 0.01;
         }
         var _loc5_:Graphics = this._shape.graphics;
         _loc5_.clear();
         if(this._gradientFill != null)
         {
            _loc5_.beginGradientFill(this._gradientFill.type,this._gradientFill.colors,this._gradientFill.alphas,this._gradientFill.ratios,this._gradientFill.matrix,this._gradientFill.spreadMethod,this._gradientFill.interpolationMethod,this._gradientFill.focalPointRatio);
         }
         else if(this._bitmapFill != null)
         {
            _loc5_.beginBitmapFill(this._bitmapFill.bitmap,this._bitmapFill.matrix,this._bitmapFill.repeat,this._bitmapFill.smooth);
         }
         else if(this._shaderFill != null)
         {
            _loc5_.beginShaderFill(this._shaderFill.shader,this._shaderFill.matrix);
         }
         else
         {
            _loc5_.beginFill(this._color,this._alpha);
         }
         if(Boolean(this._topLeftRadius) || Boolean(this._topRightRadius) || Boolean(this._bottomLeftRadius) || Boolean(this._bottomRightRadius))
         {
            _loc5_.drawRoundRectComplex(0,0,_loc3_,_loc4_,this._topLeftRadius,this._topRightRadius,this._bottomLeftRadius,this._bottomRightRadius);
         }
         else if(Boolean(this._ellipseWidth) || Boolean(this._ellipseHeight))
         {
            _loc5_.drawRoundRect(0,0,_loc3_,_loc4_,this._ellipseWidth,this._ellipseHeight);
         }
         else
         {
            _loc5_.drawRect(0,0,_loc3_,_loc4_);
         }
         _loc5_.endFill();
         return this._shape.getBounds(null);
      }
      
      public function getEllipseWidth() : Number
      {
         return this._ellipseWidth;
      }
      
      public function setEllipseWidth(param1:Number) : void
      {
         if(this._ellipseWidth == param1)
         {
            return;
         }
         this._ellipseWidth = param1;
         invalidateLayout();
      }
      
      public function getEllipseHeight() : Number
      {
         return this._ellipseHeight;
      }
      
      public function setEllipseHeight(param1:Number) : void
      {
         if(this._ellipseHeight == param1)
         {
            return;
         }
         this._ellipseHeight = param1;
         invalidateLayout();
      }
      
      public function getTopLeftRadius() : Number
      {
         return this._topLeftRadius;
      }
      
      public function setTopLeftRadius(param1:Number) : void
      {
         if(this._topLeftRadius == param1)
         {
            return;
         }
         this._topLeftRadius = param1;
         invalidateLayout();
      }
      
      public function getTopRightRadius() : Number
      {
         return this._topRightRadius;
      }
      
      public function setTopRightRadius(param1:Number) : void
      {
         if(this._topRightRadius == param1)
         {
            return;
         }
         this._topRightRadius = param1;
         invalidateLayout();
      }
      
      public function getBottomLeftRadius() : Number
      {
         return this._bottomLeftRadius;
      }
      
      public function setBottomLeftRadius(param1:Number) : void
      {
         if(this._bottomLeftRadius == param1)
         {
            return;
         }
         this._bottomLeftRadius = param1;
         invalidateLayout();
      }
      
      public function getBottomRightRadius() : Number
      {
         return this._bottomRightRadius;
      }
      
      public function setBottomRightRadius(param1:Number) : void
      {
         if(this._bottomRightRadius == param1)
         {
            return;
         }
         this._bottomRightRadius = param1;
         invalidateLayout();
      }
      
      public function getGradientFill() : GradientFill
      {
         return this._gradientFill;
      }
      
      public function setGradientFill(param1:GradientFill) : void
      {
         this._gradientFill = param1;
         this._bitmapFill = null;
         this._shaderFill = null;
         invalidateLayout();
      }
      
      public function getBitmapFill() : BitmapFill
      {
         return this._bitmapFill;
      }
      
      public function setBitmapFill(param1:BitmapFill) : void
      {
         this._bitmapFill = param1;
         this._gradientFill = null;
         this._shaderFill = null;
         invalidateLayout();
      }
      
      public function getShaderFill() : ShaderFill
      {
         return this._shaderFill;
      }
      
      public function setShaderFill(param1:ShaderFill) : void
      {
         this._shaderFill = param1;
         this._bitmapFill = null;
         this._gradientFill = null;
         this._shaderFill = null;
         invalidateLayout();
      }
      
      public function getColor() : uint
      {
         return this._color;
      }
      
      public function setColor(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         invalidateLayout();
      }
      
      override public function getAlpha() : Number
      {
         return this._alpha;
      }
      
      override public function setAlpha(param1:Number) : void
      {
         if(this._alpha == param1)
         {
            return;
         }
         this._alpha = param1;
         invalidateLayout();
      }
   }
}

