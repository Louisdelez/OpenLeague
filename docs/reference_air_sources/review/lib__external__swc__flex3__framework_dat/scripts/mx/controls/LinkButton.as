package mx.controls
{
   import flash.text.TextLineMetrics;
   import mx.core.FlexVersion;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("LinkButton.png")]
   [AccessibilityClass(implementation="mx.accessibility.LinkButtonAccImpl")]
   [Exclude(name="highlightAlphas",kind="style")]
   [Exclude(name="fillColors",kind="style")]
   [Exclude(name="fillAlphas",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="emphasized",kind="property")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   public class LinkButton extends Button
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function LinkButton()
      {
         super();
         buttonMode = true;
         mx_internal::extraSpacing = 4;
      }
      
      [Inspectable(environment="none")]
      override public function set emphasized(value:Boolean) : void
      {
      }
      
      override protected function measure() : void
      {
         var textWidth:Number = NaN;
         var textHeight:Number = NaN;
         var iconWidth:Number = NaN;
         var iconHeight:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var lineMetrics:TextLineMetrics = null;
         super.measure();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            textWidth = 8;
            textHeight = 8;
            if(Boolean(label))
            {
               lineMetrics = measureText(label);
               textWidth += lineMetrics.width;
               textHeight += lineMetrics.height;
            }
            textWidth += getStyle("paddingLeft") + getStyle("paddingRight");
            viewIcon();
            viewSkin();
            iconWidth = Boolean(currentIcon) ? currentIcon.width : 0;
            iconHeight = Boolean(currentIcon) ? currentIcon.height : 0;
            w = 0;
            h = 0;
            if(labelPlacement == ButtonLabelPlacement.LEFT || labelPlacement == ButtonLabelPlacement.RIGHT)
            {
               if(Boolean(label) && label.length > 0)
               {
                  w = textWidth + iconWidth;
               }
               else
               {
                  w = iconWidth;
               }
               if(iconWidth != 0)
               {
                  w += getStyle("horizontalGap");
               }
               h = Math.max(textHeight,iconHeight);
            }
            else
            {
               w = Math.max(textWidth,iconWidth);
               if(Boolean(label) && label.length > 0)
               {
                  h = textHeight + iconHeight;
               }
               else
               {
                  h = iconHeight;
               }
               if(iconHeight != 0)
               {
                  h += getStyle("verticalGap");
               }
            }
            if(Boolean(label) && label != "")
            {
               w += extraSpacing;
            }
            w = Math.max(20,w);
            h = Math.max(14,h);
            measuredMinWidth = measuredWidth = w;
            measuredMinHeight = measuredHeight = h;
         }
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         buttonMode = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(createAccessibilityImplementation != null)
         {
            createAccessibilityImplementation(this);
         }
      }
   }
}

