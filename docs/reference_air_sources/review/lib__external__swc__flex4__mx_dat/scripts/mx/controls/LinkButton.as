package mx.controls
{
   [IconFile("LinkButton.png")]
   [AccessibilityClass(implementation="mx.accessibility.LinkButtonAccImpl")]
   [Exclude(name="highlightAlphas",kind="style")]
   [Exclude(name="fillColors",kind="style")]
   [Exclude(name="fillAlphas",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="chromeColor",kind="style")]
   [Exclude(name="emphasized",kind="property")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   public class LinkButton extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LinkButton()
      {
         super();
         buttonMode = true;
         extraSpacing = 4;
      }
      
      [Inspectable(environment="none")]
      override public function set emphasized(value:Boolean) : void
      {
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

