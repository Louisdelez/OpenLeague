package flexlib.controls
{
   import flexlib.controls.sliderClasses.ExtendedSlider;
   import mx.controls.sliderClasses.SliderDirection;
   
   [IconFile("VSlider.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="value",destination="labels")]
   [Exclude(name="direction",kind="property")]
   [Style(name="dataTipPlacement",type="String",enumeration="left, top, right, bottom",inherit="no")]
   public class VSlider extends ExtendedSlider
   {
      
      public function VSlider()
      {
         super();
         direction = SliderDirection.VERTICAL;
      }
   }
}

