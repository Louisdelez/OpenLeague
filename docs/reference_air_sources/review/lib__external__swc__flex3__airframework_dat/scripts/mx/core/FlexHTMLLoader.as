package mx.core
{
   import flash.html.HTMLLoader;
   import mx.managers.IFocusManagerComplexComponent;
   import mx.utils.NameUtil;
   
   public class FlexHTMLLoader extends HTMLLoader implements IFocusManagerComplexComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private var _focusEnabled:Boolean = true;
      
      private var _mouseFocusEnabled:Boolean = true;
      
      public function FlexHTMLLoader()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
      
      public function get focusEnabled() : Boolean
      {
         return _focusEnabled;
      }
      
      public function assignFocus(direction:String) : void
      {
         stage.assignFocus(this,direction);
      }
      
      [Inspectable(defaultValue="true")]
      public function get mouseFocusEnabled() : Boolean
      {
         return _mouseFocusEnabled;
      }
      
      public function set focusEnabled(value:Boolean) : void
      {
         _focusEnabled = value;
      }
      
      public function drawFocus(isFocused:Boolean) : void
      {
      }
      
      public function setFocus() : void
      {
         stage.focus = this;
      }
      
      public function set mouseFocusEnabled(value:Boolean) : void
      {
         _mouseFocusEnabled = value;
      }
   }
}

