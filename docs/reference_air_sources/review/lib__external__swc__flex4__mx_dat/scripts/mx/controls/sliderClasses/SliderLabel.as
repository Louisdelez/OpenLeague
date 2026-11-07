package mx.controls.sliderClasses
{
   import mx.controls.Label;
   
   public class SliderLabel extends Label
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function SliderLabel()
      {
         super();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMinimumText(t:String) : String
      {
         if(!t || t.length < 1)
         {
            t = "W";
         }
         return t;
      }
   }
}

