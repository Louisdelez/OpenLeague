package mx.graphics
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RadialGradient extends GradientBase implements IFill
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var commonMatrix:Matrix = new Matrix();
      
      private var _focalPointRatio:Number = 0;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      public function RadialGradient()
      {
         super();
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
      
      public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point) : void
      {
         var w:Number = !isNaN(this.scaleX) ? this.scaleX : targetBounds.width;
         var h:Number = !isNaN(this.scaleY) ? this.scaleY : targetBounds.height;
         var regX:Number = !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
         var regY:Number = !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
         commonMatrix.identity();
         if(!compoundTransform)
         {
            commonMatrix.scale(w / GRADIENT_DIMENSION,h / GRADIENT_DIMENSION);
            commonMatrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
            commonMatrix.translate(regX,regY);
         }
         else
         {
            commonMatrix.scale(1 / GRADIENT_DIMENSION,1 / GRADIENT_DIMENSION);
            commonMatrix.concat(compoundTransform.matrix);
            commonMatrix.translate(targetOrigin.x,targetOrigin.y);
         }
         target.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,commonMatrix,spreadMethod,interpolationMethod,this.focalPointRatio);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
   }
}

