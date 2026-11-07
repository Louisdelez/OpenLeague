package mx.skins.spark
{
   import spark.skins.SparkSkin;
   
   public class SparkSkinForHalo extends SparkSkin
   {
      
      public function SparkSkinForHalo()
      {
         super();
      }
      
      protected function get borderItems() : Array
      {
         return null;
      }
      
      protected function get defaultBorderItemColor() : uint
      {
         return 0;
      }
      
      protected function get defaultBorderAlpha() : Number
      {
         return NaN;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var isError:Boolean = false;
         var borderItemColor:uint = 0;
         var errorColor:uint = 0;
         var borderAlpha:Number = NaN;
         var i:int = 0;
         var borderItems:Array = this.borderItems;
         if(Boolean(borderItems) && borderItems.length > 0)
         {
            isError = false;
            errorColor = uint(getStyle("errorColor"));
            borderAlpha = this.defaultBorderAlpha;
            if(getStyle("borderColor") == errorColor)
            {
               borderItemColor = errorColor;
            }
            else
            {
               borderItemColor = this.defaultBorderItemColor;
            }
            for(i = 0; i < borderItems.length; i++)
            {
               if(Boolean(this[borderItems[i]]))
               {
                  this[borderItems[i]].color = borderItemColor;
                  if(!isNaN(borderAlpha))
                  {
                     this[borderItems[i]].alpha = borderAlpha;
                  }
               }
            }
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

