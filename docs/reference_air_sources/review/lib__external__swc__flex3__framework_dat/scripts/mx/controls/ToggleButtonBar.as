package mx.controls
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.core.IFlexDisplayObject;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   [IconFile("ButtonBar.png")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="shadowDistance",kind="style")]
   [Exclude(name="shadowDirection",kind="style")]
   [Exclude(name="shadowColor",kind="style")]
   [Exclude(name="shadowCapColor",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="dropShadowEnabled",kind="style")]
   [Exclude(name="dropShadowColor",kind="style")]
   [Exclude(name="cornerRadius",kind="style")]
   [Exclude(name="borderThickness",kind="style")]
   [Exclude(name="borderStyle",kind="style")]
   [Exclude(name="borderSkin",kind="style")]
   [Exclude(name="borderSides",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="backgroundSize",kind="style")]
   [Exclude(name="backgroundImage",kind="style")]
   [Exclude(name="backgroundColor",kind="style")]
   [Exclude(name="backgroundAttachment",kind="style")]
   [Exclude(name="backgroundAlpha",kind="style")]
   [Exclude(name="click",kind="event")]
   [Exclude(name="scroll",kind="event")]
   [Exclude(name="verticalScrollPosition",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBar",kind="property")]
   [Exclude(name="verticalPageScrollSize",kind="property")]
   [Exclude(name="verticalLineScrollSize",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBar",kind="property")]
   [Exclude(name="horizontalPageScrollSize",kind="property")]
   [Exclude(name="horizontalLineScrollSize",kind="property")]
   [Style(name="selectedButtonTextStyleName",type="String",inherit="no")]
   public class ToggleButtonBar extends ButtonBar
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var selectedButtonTextStyleNameProp:String = "selectedButtonTextStyleName";
      
      private var initializeSelectedButton:Boolean = true;
      
      private var _toggleOnClick:Boolean = false;
      
      private var _selectedIndex:int = -2;
      
      private var selectedIndexChanged:Boolean = false;
      
      public function ToggleButtonBar()
      {
         super();
      }
      
      override protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         var b:Button = Button(super.createNavItem(label,icon));
         b.toggle = true;
         return b;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var child:Button = null;
         var selectedButtonTextStyleName:String = null;
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == selectedButtonTextStyleNameProp)
         {
            if(selectedIndex != -1 && selectedIndex < numChildren)
            {
               child = Button(getChildAt(selectedIndex));
               if(Boolean(child))
               {
                  selectedButtonTextStyleName = getStyle(selectedButtonTextStyleNameProp);
                  child.getTextField().styleName = Boolean(selectedButtonTextStyleName) ? selectedButtonTextStyleName : "activeButtonStyle";
               }
            }
         }
      }
      
      override protected function resetNavItems() : void
      {
         var child:Button = null;
         var selectedButtonTextStyleName:String = getStyle(selectedButtonTextStyleNameProp);
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = Button(getChildAt(i));
            if(i == selectedIndex)
            {
               child.selected = true;
               child.getTextField().styleName = Boolean(selectedButtonTextStyleName) ? selectedButtonTextStyleName : "activeButtonStyle";
            }
            else
            {
               child.selected = false;
               child.getTextField().styleName = child;
            }
         }
         super.resetNavItems();
      }
      
      mx_internal function selectButton(index:int, updateFocusIndex:Boolean = false, trigger:Event = null) : void
      {
         _selectedIndex = index;
         if(updateFocusIndex)
         {
            drawButtonFocus(focusedIndex,false);
            focusedIndex = index;
            drawButtonFocus(focusedIndex,false);
         }
         var child:Button = Button(getChildAt(index));
         simulatedClickTriggerEvent = trigger;
         child.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         simulatedClickTriggerEvent = null;
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(selectedIndexChanged)
         {
            hiliteSelectedNavItem(_selectedIndex);
            super.selectedIndex = _selectedIndex;
            selectedIndexChanged = false;
         }
      }
      
      override protected function hiliteSelectedNavItem(index:int) : void
      {
         var child:Button = null;
         var selectedButtonTextStyleName:String = null;
         if(selectedIndex != -1 && selectedIndex < numChildren)
         {
            child = Button(getChildAt(selectedIndex));
            child.selected = false;
            child.getTextField().styleName = child;
            child.invalidateDisplayList();
            child.invalidateSize();
         }
         super.selectedIndex = index;
         _selectedIndex = index;
         if(index > -1)
         {
            child = Button(getChildAt(selectedIndex));
            child.selected = true;
            selectedButtonTextStyleName = getStyle(selectedButtonTextStyleNameProp);
            child.getTextField().styleName = Boolean(selectedButtonTextStyleName) ? selectedButtonTextStyleName : "activeButtonStyle";
            child.invalidateDisplayList();
         }
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         var index:int = getChildIndex(Button(event.currentTarget));
         _selectedIndex = index;
         if(_toggleOnClick && index == selectedIndex)
         {
            selectedIndex = -1;
            hiliteSelectedNavItem(-1);
         }
         else
         {
            hiliteSelectedNavItem(index);
         }
         super.clickHandler(event);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var targetIndex:int = -1;
         var updateFocusIndex:Boolean = true;
         var n:int = numChildren;
         switch(event.keyCode)
         {
            case Keyboard.PAGE_DOWN:
               targetIndex = nextIndex(selectedIndex);
               break;
            case Keyboard.PAGE_UP:
               if(selectedIndex != -1)
               {
                  targetIndex = prevIndex(selectedIndex);
               }
               else if(n > 0)
               {
                  targetIndex = 0;
               }
               break;
            case Keyboard.HOME:
               if(n > 0)
               {
                  targetIndex = 0;
               }
               break;
            case Keyboard.END:
               if(n > 0)
               {
                  targetIndex = n - 1;
               }
               break;
            case Keyboard.SPACE:
            case Keyboard.ENTER:
               if(focusedIndex != -1)
               {
                  targetIndex = focusedIndex;
                  updateFocusIndex = false;
               }
               break;
            default:
               super.keyDownHandler(event);
         }
         if(targetIndex != -1)
         {
            selectButton(targetIndex,updateFocusIndex,event);
         }
         event.stopPropagation();
      }
      
      public function set toggleOnClick(value:Boolean) : void
      {
         _toggleOnClick = value;
      }
      
      override public function set selectedIndex(value:int) : void
      {
         if(value == selectedIndex && value != -1)
         {
            return;
         }
         if(numChildren == 0)
         {
            _selectedIndex = value;
            selectedIndexChanged = true;
         }
         if(value < numChildren)
         {
            _selectedIndex = value;
            selectedIndexChanged = true;
            invalidateProperties();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get toggleOnClick() : Boolean
      {
         return _toggleOnClick;
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("click")]
      override public function get selectedIndex() : int
      {
         return super.selectedIndex;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var index:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(initializeSelectedButton)
         {
            initializeSelectedButton = false;
            index = _selectedIndex;
            if(index == -2)
            {
               if(numChildren > 0)
               {
                  index = 0;
               }
               else
               {
                  index = -1;
               }
            }
            hiliteSelectedNavItem(index);
         }
      }
   }
}

