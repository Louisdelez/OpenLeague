package flexlib.controls.tabBarClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import flexlib.events.SuperTabEvent;
   import mx.controls.Button;
   import mx.controls.tabBarClasses.Tab;
   import mx.core.UIComponent;
   
   [Style(name="indicatorClass",type="String",inherit="no")]
   [Style(name="tabCloseButtonStyleName",type="String",inherit="no")]
   [Event(name="tabUpdated",type="flexlib.events.SuperTabEvent")]
   public class SuperTab extends Tab
   {
      
      public static const CLOSE_TAB_EVENT:String = "closeTab";
      
      public static const CLOSE_ALWAYS:String = "close_always";
      
      public static const CLOSE_SELECTED:String = "close_selected";
      
      public static const CLOSE_ROLLOVER:String = "close_rollover";
      
      public static const CLOSE_NEVER:String = "close_never";
      
      private var _editableLabel:Boolean = false;
      
      private var _indicatorOffset:Number = 0;
      
      private var _showIndicator:Boolean = false;
      
      private var indicator:DisplayObject;
      
      public var doubleClickToEdit:Boolean = false;
      
      private var _rolledOver:Boolean = false;
      
      private var closeButton:Button;
      
      private var _closePolicy:String;
      
      public function SuperTab()
      {
         super();
         this.mouseChildren = true;
         this.doubleClickEnabled = true;
         this.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
      }
      
      private function cancelEvent(event:Event) : void
      {
         event.stopPropagation();
         event.stopImmediatePropagation();
      }
      
      override protected function rollOutHandler(event:MouseEvent) : void
      {
         _rolledOver = false;
         super.rollOutHandler(event);
      }
      
      override public function set selected(value:Boolean) : void
      {
         super.selected = value;
         callLater(invalidateSize);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(_closePolicy == SuperTab.CLOSE_ALWAYS || _closePolicy == SuperTab.CLOSE_ROLLOVER)
         {
            measuredMinWidth += 10;
         }
         else if(_closePolicy == SuperTab.CLOSE_SELECTED && selected)
         {
            measuredMinWidth += 10;
         }
      }
      
      public function get closePolicy() : String
      {
         return _closePolicy;
      }
      
      private function checkEnterKey(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            event.stopImmediatePropagation();
            event.stopPropagation();
            this.editableLabel = false;
            dispatchEvent(new SuperTabEvent(SuperTabEvent.TAB_UPDATED,-1));
         }
      }
      
      public function set editableLabel(value:Boolean) : void
      {
         if(value != _editableLabel)
         {
            _editableLabel = value;
            this.textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
            this.textField.selectable = value;
            if(value)
            {
               this.addEventListener(MouseEvent.MOUSE_DOWN,cancelEvent,false,10);
               this.textField.addEventListener(FocusEvent.FOCUS_OUT,textUnfocusListener);
               this.textField.addEventListener(KeyboardEvent.KEY_DOWN,checkEnterKey);
               this.textField.setSelection(0,textField.length - 1);
            }
            else
            {
               this.removeEventListener(MouseEvent.MOUSE_DOWN,cancelEvent);
               this.textField.removeEventListener(FocusEvent.FOCUS_OUT,textUnfocusListener);
               this.textField.removeEventListener(KeyboardEvent.KEY_DOWN,checkEnterKey);
               this.textField.setSelection(0,0);
               this.textField.invalidateDisplayList();
            }
         }
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(closeButton))
         {
            closeButton.enabled = value;
         }
      }
      
      override public function get measuredWidth() : Number
      {
         return this.measuredMinWidth;
      }
      
      public function set closePolicy(value:String) : void
      {
         this._closePolicy = value;
         this.invalidateDisplayList();
      }
      
      private function textUnfocusListener(event:Event) : void
      {
         this.label = textField.text;
         this.editableLabel = false;
         dispatchEvent(new SuperTabEvent(SuperTabEvent.TAB_UPDATED,-1));
      }
      
      private function closeClickHandler(event:MouseEvent) : void
      {
         if(this.enabled)
         {
            dispatchEvent(new Event(CLOSE_TAB_EVENT));
         }
         event.stopImmediatePropagation();
         event.stopPropagation();
      }
      
      public function get editableLabel() : Boolean
      {
         return _editableLabel;
      }
      
      private function doubleClickHandler(event:MouseEvent) : void
      {
         if(doubleClickToEdit && this.enabled)
         {
            this.editableLabel = true;
         }
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         if(!enabled)
         {
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
         }
         _rolledOver = true;
         super.rollOverHandler(event);
      }
      
      override protected function createChildren() : void
      {
         var indicatorClass:Class = null;
         super.createChildren();
         closeButton = new Button();
         closeButton.width = 10;
         closeButton.height = 10;
         closeButton.addEventListener(MouseEvent.MOUSE_UP,closeClickHandler,false,0,true);
         closeButton.addEventListener(MouseEvent.MOUSE_DOWN,cancelEvent,false,0,true);
         closeButton.addEventListener(MouseEvent.CLICK,cancelEvent,false,0,true);
         closeButton.styleName = getStyle("tabCloseButtonStyleName");
         indicatorClass = getStyle("indicatorClass") as Class;
         if(Boolean(indicatorClass))
         {
            indicator = new indicatorClass() as DisplayObject;
         }
         else
         {
            indicator = new UIComponent();
         }
         addChild(indicator);
         addChild(closeButton);
         closeButton.enabled = this.enabled;
         this.textField.addEventListener(Event.CHANGE,captureTextChange);
      }
      
      private function captureTextChange(event:Event) : void
      {
         if(this.label != textField.text)
         {
            this.label = textField.text;
         }
         event.stopImmediatePropagation();
      }
      
      public function set showIndicator(val:Boolean) : void
      {
         this._showIndicator = val;
         this.invalidateDisplayList();
      }
      
      public function showIndicatorAt(x:Number) : void
      {
         this._indicatorOffset = x;
         this.showIndicator = true;
      }
      
      public function get showIndicator() : Boolean
      {
         return _showIndicator;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         setChildIndex(closeButton,numChildren - 2);
         setChildIndex(indicator,numChildren - 1);
         closeButton.visible = false;
         indicator.visible = false;
         if(_closePolicy == SuperTab.CLOSE_SELECTED)
         {
            if(selected)
            {
               closeButton.visible = true;
               closeButton.enabled = true;
            }
         }
         else if(!_rolledOver)
         {
            if(_closePolicy == SuperTab.CLOSE_ALWAYS)
            {
               closeButton.visible = true;
               closeButton.enabled = false;
            }
            else if(_closePolicy == SuperTab.CLOSE_ROLLOVER)
            {
               closeButton.visible = false;
               closeButton.enabled = false;
            }
         }
         else if(_closePolicy != SuperTab.CLOSE_NEVER)
         {
            closeButton.visible = true;
            closeButton.enabled = this.enabled;
         }
         if(_showIndicator)
         {
            indicator.visible = true;
            indicator.x = _indicatorOffset - indicator.width / 2;
            indicator.y = 0;
         }
         if(closeButton.visible)
         {
            closeButton.x = unscaledWidth - closeButton.width - 4;
            closeButton.y = 4;
            setChildIndex(closeButton,numChildren - 1);
         }
      }
   }
}

