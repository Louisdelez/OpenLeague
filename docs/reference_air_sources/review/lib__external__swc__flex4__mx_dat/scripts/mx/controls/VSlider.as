package mx.controls
{
   import mx.controls.sliderClasses.Slider;
   import mx.controls.sliderClasses.SliderDirection;
   
   [Alternative(replacement="spark.components.VSlider",since="4.0")]
   [IconFile("VSlider.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="labels")]
   [Exclude(name="direction",kind="property")]
   [Style(name="dataTipPlacement",type="String",enumeration="left,top,right,bottom",inherit="no")]
   public class VSlider extends Slider
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function VSlider()
      {
         super();
         direction = SliderDirection.VERTICAL;
      }
   }
}

