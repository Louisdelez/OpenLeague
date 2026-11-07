package mx.controls.sliderClasses
{
   import mx.controls.Label;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SliderLabel extends Label
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function SliderLabel()
      {
         super();
      }
      
      override mx_internal function getMinimumText(t:String) : String
      {
         if(!t || t.length < 1)
         {
            t = "W";
         }
         return t;
      }
   }
}

