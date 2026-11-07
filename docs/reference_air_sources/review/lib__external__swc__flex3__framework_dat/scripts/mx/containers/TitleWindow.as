package mx.containers
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
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
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function TitleWindow()
      {
         super();
      }
      
      public function set showCloseButton(value:Boolean) : void
      {
         _showCloseButton = value;
      }
      
      [Inspectable(category="General")]
      public function get showCloseButton() : Boolean
      {
         return _showCloseButton;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TitleWindow.mx_internal::createAccessibilityImplementation != null)
         {
            TitleWindow.mx_internal::createAccessibilityImplementation(this);
         }
      }
   }
}

