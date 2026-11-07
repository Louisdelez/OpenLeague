package mx.accessibility
{
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.ComboBox;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ComboBoxAccImpl extends ComboBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function ComboBoxAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         ComboBox.createAccessibilityImplementation = createAccessibilityImplementation;
         ListAccImpl.enableAccessibility();
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
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

