package mx.graphics
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.GraphicsGradientFill;
   import flash.display.GraphicsStroke;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RadialGradientStroke extends GradientStroke
   {
      
      private static var commonMatrix:Matrix = new Matrix();
      
      private var _focalPointRatio:Number = 0;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      public function RadialGradientStroke(weight:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "round", joints:String = "round", miterLimit:Number = 3)
      {
         super(weight,pixelHinting,scaleMode,caps,joints,miterLimit);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get focalPointRatio() : Number
      {
         return this._focalPointRatio;
      }
      
      public function set focalPointRatio(value:Number) : void
      {
         var oldValue:Number = this._focalPointRatio;
         if(value != oldValue)
         {
            this._focalPointRatio = value;
            dispatchGradientChangedEvent("focalPointRatio",oldValue,value);
         }
      }
      
      override public function set matrix(value:Matrix) : void
      {
         this.scaleX = NaN;
         this.scaleY = NaN;
         super.matrix = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get scaleX() : Number
      {
         return Boolean(compoundTransform) ? compoundTransform.scaleX : this._scaleX;
      }
      
      public function set scaleX(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.scaleX)
         {
            oldValue = this.scaleX;
            if(Boolean(compoundTransform))
            {
               if(!isNaN(value))
               {
                  compoundTransform.scaleX = value;
               }
            }
            else
            {
               this._scaleX = value;
            }
            dispatchGradientChangedEvent("scaleX",oldValue,value);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get scaleY() : Number
      {
         return Boolean(compoundTransform) ? compoundTransform.scaleY : this._scaleY;
      }
      
      public function set scaleY(value:Number) : void
      {
         var oldValue:Number = NaN;
         if(value != this.scaleY)
         {
            oldValue = this.scaleY;
            if(Boolean(compoundTransform))
            {
               if(!isNaN(value))
               {
                  compoundTransform.scaleY = value;
               }
            }
            else
            {
               this._scaleY = value;
            }
            dispatchGradientChangedEvent("scaleY",oldValue,value);
         }
      }
      
      override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         commonMatrix.identity();
         graphics.lineStyle(weight,0,1,pixelHinting,scaleMode,caps,joints,miterLimit);
         if(Boolean(targetBounds))
         {
            this.calculateTransformationMatrix(targetBounds,commonMatrix,targetOrigin);
         }
         graphics.lineGradientStyle(GradientType.RADIAL,colors,alphas,ratios,commonMatrix,spreadMethod,interpolationMethod,this.focalPointRatio);
      }
      
      override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point) : GraphicsStroke
      {
         var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds,targetOrigin);
         if(Boolean(graphicsStroke))
         {
            GraphicsGradientFill(graphicsStroke.fill).type = GradientType.RADIAL;
            this.calculateTransformationMatrix(targetBounds,commonMatrix,targetOrigin);
            GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix;
            GraphicsGradientFill(graphicsStroke.fill).focalPointRatio = this.focalPointRatio;
         }
         return graphicsStroke;
      }
      
      private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         var regX:Number = NaN;
         var regY:Number = NaN;
         matrix.identity();
         if(!compoundTransform)
         {
            w = !isNaN(this.scaleX) ? this.scaleX : targetBounds.width;
            h = !isNaN(this.scaleY) ? this.scaleY : targetBounds.height;
            regX = !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
            regY = !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
            matrix.scale(w / GRADIENT_DIMENSION,h / GRADIENT_DIMENSION);
            matrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
            matrix.translate(regX,regY);
         }
         else
         {
            matrix.scale(1 / GRADIENT_DIMENSION,1 / GRADIENT_DIMENSION);
            matrix.concat(compoundTransform.matrix);
            matrix.translate(targetOrigin.x,targetOrigin.y);
         }
      }
   }
}

