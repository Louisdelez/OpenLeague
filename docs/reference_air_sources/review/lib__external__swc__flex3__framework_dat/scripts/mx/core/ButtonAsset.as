package mx.core
{
   use namespace mx_internal;
   
   public class ButtonAsset extends FlexSimpleButton implements IFlexAsset, IFlexDisplayObject
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _measuredHeight:Number;
      
      private var _measuredWidth:Number;
      
      public function ButtonAsset()
      {
         super();
         _measuredWidth = width;
         _measuredHeight = height;
      }
      
      public function get measuredWidth() : Number
      {
         return _measuredWidth;
      }
      
      public function get measuredHeight() : Number
      {
         return _measuredHeight;
      }
      
      public function setActualSize(newWidth:Number, newHeight:Number) : void
      {
         width = newWidth;
         height = newHeight;
      }
      
      public function move(x:Number, y:Number) : void
      {
         this.x = x;
         this.y = y;
      }
   }
}

