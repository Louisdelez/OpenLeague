package flexlib.controls
{
   import flexlib.controls.sliderClasses.ExtendedSlider;
   import mx.controls.sliderClasses.SliderDirection;
   
   [IconFile("HSlider.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="labels")]
   [Exclude(name="direction",kind="property")]
   [Style(name="dataTipPlacement",type="String",inherit="no")]
   public class HSlider extends ExtendedSlider
   {
      
      public function HSlider()
      {
         super();
         direction = SliderDirection.HORIZONTAL;
      }
   }
}

