package mx.containers
{
   [Alternative(replacement="spark.components.TitleWindow",since="4.0")]
   [IconFile("TitleWindow.png")]
   [AccessibilityClass(implementation="mx.accessibility.TitleWindowAccImpl")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="closeButtonUpSkin",type="Class",inherit="no")]
   [Style(name="closeButtonOverSkin",type="Class",inherit="no")]
   [Style(name="closeButtonDownSkin",type="Class",inherit="no")]
   [Style(name="closeButtonDisabledSkin",type="Class",inherit="no")]
   [Style(name="closeButtonSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Event(name="close",type="mx.events.CloseEvent")]
   public class TitleWindow extends Panel
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TitleWindow()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get showCloseButton() : Boolean
      {
         return _showCloseButton;
      }
      
      public function set showCloseButton(value:Boolean) : void
      {
         _showCloseButton = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TitleWindow.createAccessibilityImplementation != null)
         {
            TitleWindow.createAccessibilityImplementation(this);
         }
      }
   }
}

