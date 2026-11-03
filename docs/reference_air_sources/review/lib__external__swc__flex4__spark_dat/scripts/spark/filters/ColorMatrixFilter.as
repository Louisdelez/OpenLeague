package spark.filters
{
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   
   public class ColorMatrixFilter extends BaseFilter implements IBitmapFilter
   {
      
      private var _matrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      public function ColorMatrixFilter(matrix:Array = null)
      {
         super();
         if(matrix != null)
         {
            this.matrix = matrix;
         }
      }
      
      public function get matrix() : Object
      {
         return this._matrix;
      }
      
      public function set matrix(value:Object) : void
      {
         if(value != this._matrix)
         {
            if(value is Array)
            {
               this._matrix = value as Array;
            }
            else if(value is String)
            {
               this._matrix = String(value).split(",");
            }
            notifyFilterChanged();
         }
      }
      
      public function clone() : BitmapFilter
      {
         return new flash.filters.ColorMatrixFilter(this._matrix);
      }
   }
}

