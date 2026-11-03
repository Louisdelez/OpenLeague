package mx.accessibility
{
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.ComboBox;
   import mx.core.UIComponent;
   
   public class ComboBoxAccImpl extends ComboBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ComboBoxAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         ComboBox.createAccessibilityImplementation = createAccessibilityImplementation;
         ListAccImpl.enableAccessibility();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ComboBoxAccImpl(component);
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var comboBox:ComboBox = ComboBox(master);
         var iterator:IViewCursor = comboBox.collectionIterator;
         iterator.seek(CursorBookmark.FIRST,childID - 1);
         var item:Object = iterator.current;
         return comboBox.itemToLabel(item);
      }
   }
}

