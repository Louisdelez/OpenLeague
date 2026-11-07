package spark.primitives
{
   import mx.core.UIComponent;
   import mx.graphics.RectangularDropShadow;
   
   public class RectangularDropShadow extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var dropShadow:mx.graphics.RectangularDropShadow;
      
      private var _alpha:Number = 0.4;
      
      private var _angle:Number = 45;
      
      private var _color:int = 0;
      
      private var _distance:Number = 4;
      
      private var _tlRadius:Number = 0;
      
      private var _trRadius:Number = 0;
      
      private var _blRadius:Number = 0;
      
      private var _brRadius:Number = 0;
      
      private var _blurX:Number = 4;
      
      private var _blurY:Number = 4;
      
      public function RectangularDropShadow()
      {
         mouseEnabled = false;
         super();
      }
      
      [Inspectable]
      override public function get alpha() : Number
      {
         return this._alpha;
      }
      
      override public function set alpha(value:Number) : void
      {
         if(this._alpha != value)
         {
            this._alpha = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(value:Number) : void
      {
         if(this._angle != value)
         {
            this._angle = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get color() : int
      {
         return this._color;
      }
      
      public function set color(value:int) : void
      {
         if(this._color != value)
         {
            this._color = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get distance() : Number
      {
         return this._distance;
      }
      
      public function set distance(value:Number) : void
      {
         if(this._distance != value)
         {
            this._distance = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get tlRadius() : Number
      {
         return this._tlRadius;
      }
      
      public function set tlRadius(value:Number) : void
      {
         if(this._tlRadius != value)
         {
            this._tlRadius = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get trRadius() : Number
      {
         return this._trRadius;
      }
      
      public function set trRadius(value:Number) : void
      {
         if(this._trRadius != value)
         {
            this._trRadius = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get blRadius() : Number
      {
         return this._blRadius;
      }
      
      public function set blRadius(value:Number) : void
      {
         if(this._blRadius != value)
         {
            this._blRadius = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get brRadius() : Number
      {
         return this._brRadius;
      }
      
      public function set brRadius(value:Number) : void
      {
         if(this._brRadius != value)
         {
            this._brRadius = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function set blurX(value:Number) : void
      {
         if(this._blurX != value)
         {
            this._blurX = value;
            invalidateDisplayList();
         }
      }
      
      [Inspectable]
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set blurY(value:Number) : void
      {
         if(this._blurY != value)
         {
            this._blurY = value;
            invalidateDisplayList();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         graphics.clear();
         if(!this.dropShadow)
         {
            this.dropShadow = new mx.graphics.RectangularDropShadow();
         }
         this.dropShadow.distance = this._distance;
         this.dropShadow.angle = this._angle;
         this.dropShadow.color = this._color;
         this.dropShadow.blurX = this._blurX;
         this.dropShadow.blurY = this._blurY;
         this.dropShadow.alpha = this._alpha;
         this.dropShadow.tlRadius = isNaN(this._tlRadius) ? 0 : this._tlRadius;
         this.dropShadow.trRadius = isNaN(this._trRadius) ? 0 : this._trRadius;
         this.dropShadow.blRadius = isNaN(this._blRadius) ? 0 : this._blRadius;
         this.dropShadow.brRadius = isNaN(this._brRadius) ? 0 : this._brRadius;
         this.dropShadow.drawShadow(graphics,0,0,unscaledWidth,unscaledHeight);
      }
   }
}

