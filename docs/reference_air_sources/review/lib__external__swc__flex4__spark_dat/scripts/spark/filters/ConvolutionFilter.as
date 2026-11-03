package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.ConvolutionFilter;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   
   public class ConvolutionFilter extends BaseFilter implements IBitmapFilter
   {
      
      private var _alpha:Number = 1;
      
      private var _bias:Number = 0;
      
      private var _clamp:Boolean = true;
      
      private var _color:uint = 16711680;
      
      private var _divisor:Number = 1;
      
      private var _matrix:Array = [];
      
      private var _matrixX:Number = 0;
      
      private var _matrixY:Number = 0;
      
      private var _preserveAlpha:Boolean = true;
      
      public function ConvolutionFilter(matrixX:Number = 0, matrixY:Number = 0, matrix:Array = null, divisor:Number = 1, bias:Number = 0, preserveAlpha:Boolean = true, clamp:Boolean = true, color:uint = 0, alpha:Number = 0)
      {
         super();
         this.matrixX = matrixX;
         this.matrixY = matrixY;
         this.matrix = matrix;
         this.divisor = divisor;
         this.bias = bias;
         this.preserveAlpha = preserveAlpha;
         this.clamp = clamp;
         this.color = color;
         this.alpha = alpha;
      }
      
      [Inspectable(minValue="0.0",maxValue="1.0")]
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         if(value != this._alpha)
         {
            this._alpha = value;
            notifyFilterChanged();
         }
      }
      
      public function get bias() : Number
      {
         return this._bias;
      }
      
      public function set bias(value:Number) : void
      {
         if(value != this._bias)
         {
            this._bias = value;
            notifyFilterChanged();
         }
      }
      
      public function get clamp() : Boolean
      {
         return this._clamp;
      }
      
      public function set clamp(value:Boolean) : void
      {
         if(value != this._clamp)
         {
            this._clamp = value;
            notifyFilterChanged();
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(value:uint) : void
      {
         if(value != this._color)
         {
            this._color = value;
            notifyFilterChanged();
         }
      }
      
      public function get divisor() : Number
      {
         return this._divisor;
      }
      
      public function set divisor(value:Number) : void
      {
         if(value != this._divisor)
         {
            this._divisor = value;
            notifyFilterChanged();
         }
      }
      
      public function get matrix() : Array
      {
         return this._matrix;
      }
      
      public function set matrix(value:Array) : void
      {
         if(value != this._matrix)
         {
            this._matrix = value;
            notifyFilterChanged();
         }
      }
      
      public function get matrixX() : Number
      {
         return this._matrixX;
      }
      
      public function set matrixX(value:Number) : void
      {
         if(value != this._matrixX)
         {
            this._matrixX = value;
            notifyFilterChanged();
         }
      }
      
      public function get matrixY() : Number
      {
         return this._matrixY;
      }
      
      public function set matrixY(value:Number) : void
      {
         if(value != this._matrixY)
         {
            this._matrixY = value;
            notifyFilterChanged();
         }
      }
      
      public function get preserveAlpha() : Boolean
      {
         return this._preserveAlpha;
      }
      
      public function set preserveAlpha(value:Boolean) : void
      {
         if(value != this._preserveAlpha)
         {
            this._preserveAlpha = value;
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.ConvolutionFilter(this.matrixX,this.matrixY,this.matrix,this.divisor,this.bias,this.preserveAlpha,this.clamp,this.color,this.alpha);
      }
   }
}

