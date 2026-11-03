package mx.filters
{
   public class BaseDimensionFilter extends BaseFilter
   {
      
      private var _blurX:Number = 4;
      
      private var _blurY:Number = 4;
      
      private var _knockout:Boolean = false;
      
      private var _quality:int = 1;
      
      private var _strength:Number = 1;
      
      public function BaseDimensionFilter()
      {
         super();
      }
      
      [Inspectable(minValue="0.0",maxValue="255.0")]
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function set blurX(value:Number) : void
      {
         if(value != this._blurX)
         {
            this._blurX = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="0.0",maxValue="255.0")]
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set blurY(value:Number) : void
      {
         if(value != this._blurY)
         {
            this._blurY = value;
            notifyFilterChanged();
         }
      }
      
      public function get knockout() : Boolean
      {
         return this._knockout;
      }
      
      public function set knockout(value:Boolean) : void
      {
         if(value != this._knockout)
         {
            this._knockout = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="1",maxValue="15")]
      public function get quality() : int
      {
         return this._quality;
      }
      
      public function set quality(value:int) : void
      {
         if(value != this._quality)
         {
            this._quality = value;
            notifyFilterChanged();
         }
      }
      
      [Inspectable(minValue="0.0",maxValue="255.0")]
      public function get strength() : Number
      {
         return this._strength;
      }
      
      public function set strength(value:Number) : void
      {
         if(value != this._strength)
         {
            this._strength = value;
            notifyFilterChanged();
         }
      }
   }
}

