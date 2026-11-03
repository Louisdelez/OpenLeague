package mx.controls
{
   import mx.core.FlexVersion;
   import mx.core.IToggleButton;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("CheckBox.png")]
   [DefaultTriggerEvent("click")]
   [DefaultBindingProperty(source="selected",destination="selected")]
   [AccessibilityClass(implementation="mx.accessibility.CheckBoxAccImpl")]
   [Exclude(name="toggle",kind="property")]
   [Exclude(name="emphasized",kind="property")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
   public class CheckBox extends Button implements IToggleButton
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function CheckBox()
      {
         super();
         mx_internal::_toggle = true;
         mx_internal::centerContent = false;
         mx_internal::extraSpacing = 8;
      }
      
      [Inspectable(environment="none")]
      override public function set toggle(value:Boolean) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function set emphasized(value:Boolean) : void
      {
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CheckBox.mx_internal::createAccessibilityImplementation != null)
         {
            CheckBox.mx_internal::createAccessibilityImplementation(this);
         }
      }
      
      override protected function measure() : void
      {
         var textHeight:Number = NaN;
         var iconHeight:Number = NaN;
         var h:Number = NaN;
         var verticalGap:Number = NaN;
         super.measure();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            textHeight = measureText(label).height;
            iconHeight = Boolean(currentIcon) ? currentIcon.height : 0;
            h = 0;
            if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               h = Math.max(textHeight,iconHeight);
            }
            else
            {
               h = textHeight + iconHeight;
               verticalGap = getStyle("verticalGap");
               if(iconHeight != 0 && !isNaN(verticalGap))
               {
                  h += verticalGap;
               }
            }
            measuredMinHeight = measuredHeight = Math.max(h,18);
         }
      }
   }
}

