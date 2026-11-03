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
   
   public class LinearGradientStroke extends GradientStroke
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var commonMatrix:Matrix = new Matrix();
      
      private var _scaleX:Number;
      
      public function LinearGradientStroke(weight:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "round", joints:String = "round", miterLimit:Number = 3)
      {
         super(weight,pixelHinting,scaleMode,caps,joints,miterLimit);
      }
      
      override public function set matrix(value:Matrix) : void
      {
         this.scaleX = NaN;
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
      
      override public function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         commonMatrix.identity();
         graphics.lineStyle(weight,0,1,pixelHinting,scaleMode,caps,joints,miterLimit);
         if(Boolean(targetBounds))
         {
            this.calculateTransformationMatrix(targetBounds,commonMatrix,targetOrigin);
         }
         graphics.lineGradientStyle(GradientType.LINEAR,colors,alphas,ratios,commonMatrix,spreadMethod,interpolationMethod);
      }
      
      override public function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point) : GraphicsStroke
      {
         var graphicsStroke:GraphicsStroke = super.createGraphicsStroke(targetBounds,targetOrigin);
         if(Boolean(graphicsStroke))
         {
            GraphicsGradientFill(graphicsStroke.fill).type = GradientType.LINEAR;
            this.calculateTransformationMatrix(targetBounds,commonMatrix,targetOrigin);
            GraphicsGradientFill(graphicsStroke.fill).matrix = commonMatrix;
         }
         return graphicsStroke;
      }
      
      private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point) : void
      {
         var tx:Number = NaN;
         var ty:Number = NaN;
         var length:Number = NaN;
         var normalizedAngle:Number = NaN;
         var side:Number = NaN;
         var hypotenuse:Number = NaN;
         var hypotenuseAngle:Number = NaN;
         matrix.identity();
         if(!compoundTransform)
         {
            tx = x;
            ty = y;
            length = this.scaleX;
            if(isNaN(length))
            {
               if(rotation % 90 != 0)
               {
                  normalizedAngle = rotation % 360;
                  if(normalizedAngle < 0)
                  {
                     normalizedAngle += 360;
                  }
                  normalizedAngle %= 180;
                  if(normalizedAngle > 90)
                  {
                     normalizedAngle = 180 - normalizedAngle;
                  }
                  side = targetBounds.width;
                  hypotenuse = Math.sqrt(targetBounds.width * targetBounds.width + targetBounds.height * targetBounds.height);
                  hypotenuseAngle = Math.acos(targetBounds.width / hypotenuse) * 180 / Math.PI;
                  if(normalizedAngle > hypotenuseAngle)
                  {
                     normalizedAngle = 90 - normalizedAngle;
                     side = targetBounds.height;
                  }
                  length = side / Math.cos(normalizedAngle / 180 * Math.PI);
               }
               else
               {
                  length = rotation % 180 == 0 ? targetBounds.width : targetBounds.height;
               }
            }
            if(!isNaN(tx) && isNaN(ty))
            {
               ty = 0;
            }
            else if(isNaN(tx) && !isNaN(ty))
            {
               tx = 0;
            }
            if(!isNaN(tx) && !isNaN(ty))
            {
               matrix.translate(GRADIENT_DIMENSION / 2,GRADIENT_DIMENSION / 2);
            }
            if(length >= 0 && length < 2)
            {
               length = 2;
            }
            else if(length < 0 && length > -2)
            {
               length = -2;
            }
            matrix.scale(length / GRADIENT_DIMENSION,1 / GRADIENT_DIMENSION);
            matrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
            if(isNaN(tx))
            {
               tx = targetBounds.left + targetBounds.width / 2;
            }
            else
            {
               tx += targetOrigin.x;
            }
            if(isNaN(ty))
            {
               ty = targetBounds.top + targetBounds.height / 2;
            }
            else
            {
               ty += targetOrigin.y;
            }
            matrix.translate(tx,ty);
         }
         else
         {
            matrix.translate(GRADIENT_DIMENSION / 2,GRADIENT_DIMENSION / 2);
            matrix.scale(1 / GRADIENT_DIMENSION,1 / GRADIENT_DIMENSION);
            matrix.concat(compoundTransform.matrix);
            matrix.translate(targetOrigin.x,targetOrigin.y);
         }
      }
   }
}

