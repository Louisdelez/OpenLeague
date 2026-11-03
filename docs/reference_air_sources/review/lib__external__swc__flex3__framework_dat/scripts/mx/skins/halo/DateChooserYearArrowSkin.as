package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.FlexVersion;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class DateChooserYearArrowSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function DateChooserYearArrowSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 6;
      }
      
      override public function get measuredHeight() : Number
      {
         return FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ? 4 : 6;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var themeColor:uint = getStyle("themeColor");
         var themeColorDrk1:Number = ColorUtil.adjustBrightness2(themeColor,-25);
         var arrowColor:uint = getStyle("iconColor");
         var g:Graphics = graphics;
         g.clear();
         switch(name)
         {
            case "prevYearUpSkin":
            case "nextYearUpSkin":
               break;
            case "prevYearOverSkin":
            case "nextYearOverSkin":
               arrowColor = themeColor;
               break;
            case "prevYearDownSkin":
            case "nextYearDownSkin":
               arrowColor = themeColorDrk1;
               break;
            case "prevYearDisabledSkin":
            case "nextYearDisabledSkin":
               arrowColor = getStyle("disabledIconColor");
         }
         g.beginFill(arrowColor);
         if(name.charAt(0) == "p")
         {
            g.moveTo(w / 2,h / 2 + 2);
            g.lineTo(w / 2 - 3,h / 2 - 2);
            g.lineTo(w / 2 + 3,h / 2 - 2);
            g.lineTo(w / 2,h / 2 + 2);
         }
         else
         {
            g.moveTo(w / 2,h / 2 - 2);
            g.lineTo(w / 2 - 3,h / 2 + 2);
            g.lineTo(w / 2 + 3,h / 2 + 2);
            g.lineTo(w / 2,h / 2 - 2);
         }
         g.endFill();
      }
   }
}

