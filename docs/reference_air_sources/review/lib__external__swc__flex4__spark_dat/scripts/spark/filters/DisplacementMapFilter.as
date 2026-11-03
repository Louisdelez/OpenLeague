package spark.filters
{
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.Point;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   
   public class DisplacementMapFilter extends BaseFilter implements IBitmapFilter
   {
      
      private var _alpha:Number = 0;
      
      private var _color:uint = 0;
      
      private var _componentX:uint = 16711680;
      
      private var _componentY:uint = 16711680;
      
      private var _mapBitmap:BitmapData;
      
      private var _mapPoint:Point;
      
      private var _mode:String = "wrap";
      
      private var _scaleX:Number = 0;
      
      private var _scaleY:Number = 0;
      
      public function DisplacementMapFilter(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:uint = 0, componentY:uint = 0, scaleX:Number = 0, scaleY:Number = 0, mode:String = "wrap", color:uint = 0, alpha:Number = 0)
      {
         super();
         this.mapBitmap = mapBitmap;
         this.mapPoint = mapPoint;
         this.componentX = componentX;
         this.componentY = componentY;
         this.scaleX = scaleX;
         this.scaleY = scaleY;
         this.mode = mode;
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
      
      public function get componentX() : uint
      {
         return this._componentX;
      }
      
      public function set componentX(value:uint) : void
      {
         if(value != this._componentX)
         {
            this._componentX = value;
            notifyFilterChanged();
         }
      }
      
      public function get componentY() : uint
      {
         return this._componentY;
      }
      
      public function set componentY(value:uint) : void
      {
         if(value != this._componentY)
         {
            this._componentY = value;
            notifyFilterChanged();
         }
      }
      
      public function get mapBitmap() : BitmapData
      {
         return this._mapBitmap;
      }
      
      public function set mapBitmap(value:BitmapData) : void
      {
         if(value != this._mapBitmap)
         {
            this._mapBitmap = value;
            notifyFilterChanged();
         }
      }
      
      public function get mapPoint() : Point
      {
         return this._mapPoint;
      }
      
      public function set mapPoint(value:Point) : void
      {
         if(value != this._mapPoint)
         {
            this._mapPoint = value;
            notifyFilterChanged();
         }
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(value:String) : void
      {
         if(value != this._mode)
         {
            this._mode = value;
            notifyFilterChanged();
         }
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set scaleX(value:Number) : void
      {
         if(value != this._scaleX)
         {
            this._scaleX = value;
            notifyFilterChanged();
         }
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleY(value:Number) : void
      {
         if(value != this._scaleY)
         {
            this._scaleY = value;
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return null;
      }
   }
}

