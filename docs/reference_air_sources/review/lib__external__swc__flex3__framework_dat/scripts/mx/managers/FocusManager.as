package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   import mx.core.IButton;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class FocusManager implements IFocusManager
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const FROM_INDEX_UNSPECIFIED:int = -2;
      
      private var _focusPane:Sprite = new Sprite();
      
      private var _form:IFocusManagerContainer;
      
      public function FocusManager(container:IFocusManagerContainer, popup:Boolean = false)
      {
         super();
      }
      
      public function set focusPane(value:Sprite) : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      mx_internal function get form() : IFocusManagerContainer
      {
         return _form;
      }
      
      mx_internal function set form(value:IFocusManagerContainer) : void
      {
         _form = value;
      }
      
      private function addFocusables(o:DisplayObject, skipTopLevel:Boolean = false) : void
      {
      }
      
      public function addSWFBridge(bridge:IEventDispatcher, owner:DisplayObject) : void
      {
      }
      
      public function removeSWFBridge(bridge:IEventDispatcher) : void
      {
      }
      
      public function moveFocus(direction:String, fromDisplayObject:DisplayObject = null) : void
      {
      }
      
      public function findFocusManagerComponent(o:InteractiveObject) : IFocusManagerComponent
      {
         return null;
      }
      
      public function get nextTabIndex() : int
      {
         return -1;
      }
      
      public function get defaultButton() : IButton
      {
         return null;
      }
      
      public function setFocus(o:IFocusManagerComponent) : void
      {
      }
      
      public function showFocus() : void
      {
      }
      
      public function get focusPane() : Sprite
      {
         return _focusPane;
      }
      
      mx_internal function get lastFocus() : IFocusManagerComponent
      {
         return null;
      }
      
      public function set defaultButton(value:IButton) : void
      {
      }
      
      public function set showFocusIndicator(value:Boolean) : void
      {
      }
      
      public function getFocus() : IFocusManagerComponent
      {
         return null;
      }
      
      public function set defaultButtonEnabled(value:Boolean) : void
      {
      }
      
      public function toString() : String
      {
         return "FakeFocusManager";
      }
      
      public function get defaultButtonEnabled() : Boolean
      {
         return false;
      }
      
      public function get showFocusIndicator() : Boolean
      {
         return false;
      }
      
      public function hideFocus() : void
      {
      }
      
      public function getNextFocusManagerComponent(backward:Boolean = false) : IFocusManagerComponent
      {
         return null;
      }
      
      public function activate() : void
      {
      }
      
      mx_internal function sendDefaultButtonEvent() : void
      {
      }
   }
}

IFocusManagerComponent;

