package mx.controls
{
   import mx.controls.sliderClasses.Slider;
   import mx.controls.sliderClasses.SliderDirection;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("HSlider.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="labels")]
   [Exclude(name="direction",kind="property")]
   [Style(name="dataTipPlacement",type="String",enumeration="left, top, right, bottom",inherit="no")]
   public class HSlider extends Slider
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function HSlider()
      {
         super();
         direction = SliderDirection.HORIZONTAL;
      }
   }
}

