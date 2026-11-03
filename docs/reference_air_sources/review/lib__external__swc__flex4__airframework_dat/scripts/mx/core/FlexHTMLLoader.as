package mx.core
{
   import flash.events.Event;
   import flash.html.HTMLLoader;
   import mx.managers.IFocusManagerComplexComponent;
   import mx.utils.NameUtil;
   
   public class FlexHTMLLoader extends HTMLLoader implements IFocusManagerComplexComponent, IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _hasFocusableContent:Boolean;
      
      private var _focusEnabled:Boolean = true;
      
      private var _hasFocusableChildren:Boolean = false;
      
      private var _imeMode:String = null;
      
      private var _mouseFocusEnabled:Boolean = true;
      
      private var _tabFocusEnabled:Boolean = true;
      
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
         addEventListener(Event.HTML_RENDER,this.htmlRenderHandler);
      }
      
      public function get enableIME() : Boolean
      {
         return this._hasFocusableContent;
      }
      
      public function get focusEnabled() : Boolean
      {
         return this._focusEnabled;
      }
      
      public function set focusEnabled(value:Boolean) : void
      {
         this._focusEnabled = value;
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("hasFocusableChildrenChange")]
      public function get hasFocusableChildren() : Boolean
      {
         return this._hasFocusableChildren;
      }
      
      public function set hasFocusableChildren(value:Boolean) : void
      {
         if(value != this._hasFocusableChildren)
         {
            this._hasFocusableChildren = value;
            dispatchEvent(new Event("hasFocusableChildrenChange"));
         }
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Inspectable(defaultValue="true")]
      public function get mouseFocusEnabled() : Boolean
      {
         return this._mouseFocusEnabled;
      }
      
      public function set mouseFocusEnabled(value:Boolean) : void
      {
         this._mouseFocusEnabled = value;
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("tabFocusEnabledChange")]
      public function get tabFocusEnabled() : Boolean
      {
         return this._tabFocusEnabled;
      }
      
      public function set tabFocusEnabled(value:Boolean) : void
      {
         if(value != this._tabFocusEnabled)
         {
            this._tabFocusEnabled = value;
            dispatchEvent(new Event("tabFocusEnabledChange"));
         }
      }
      
      public function setFocus() : void
      {
         stage.focus = this;
      }
      
      public function drawFocus(isFocused:Boolean) : void
      {
      }
      
      public function assignFocus(direction:String) : void
      {
         stage.assignFocus(this,direction);
      }
      
      private function htmlRenderHandler(event:Event) : void
      {
         this._hasFocusableContent = hasFocusableContent;
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}

