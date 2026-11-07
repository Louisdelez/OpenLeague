package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.controls.tabBarClasses.Tab;
   import mx.core.ClassFactory;
   import mx.core.IFlexDisplayObject;
   
   [MaxChildren("0")]
   [IconFile("TabBar.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultProperty("dataProvider")]
   [AccessibilityClass(implementation="mx.accessibility.TabBarAccImpl")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="shadowDistance",kind="style")]
   [Exclude(name="shadowDirection",kind="style")]
   [Exclude(name="shadowColor",kind="style")]
   [Exclude(name="shadowCapColor",kind="style")]
   [Exclude(name="lastButtonStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="firstButtonStyleName",kind="style")]
   [Exclude(name="dropShadowEnabled",kind="style")]
   [Exclude(name="dropShadowColor",kind="style")]
   [Exclude(name="cornerRadius",kind="style")]
   [Exclude(name="borderVisible",kind="style")]
   [Exclude(name="borderThickness",kind="style")]
   [Exclude(name="borderStyle",kind="style")]
   [Exclude(name="borderSkin",kind="style")]
   [Exclude(name="borderSides",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="borderAlpha",kind="style")]
   [Exclude(name="backgroundSize",kind="style")]
   [Exclude(name="backgroundImage",kind="style")]
   [Exclude(name="backgroundColor",kind="style")]
   [Exclude(name="backgroundAttachment",kind="style")]
   [Exclude(name="backgroundAlpha",kind="style")]
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom",inherit="no")]
   [Style(name="tabWidth",type="Number",format="Length",inherit="no")]
   [Style(name="tabHeight",type="Number",format="Length",inherit="no")]
   [Style(name="tabStyleName",type="String",inherit="no")]
   [Style(name="selectedTabTextStyleName",type="String",inherit="no")]
   [Style(name="lastTabStyleName",type="String",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="firstTabStyleName",type="String",inherit="no")]
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class TabBar extends ToggleButtonBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TabBar()
      {
         super();
         buttonHeightProp = "tabHeight";
         buttonStyleNameProp = "tabStyleName";
         firstButtonStyleNameProp = "firstTabStyleName";
         lastButtonStyleNameProp = "lastTabStyleName";
         buttonWidthProp = "tabWidth";
         navItemFactory = new ClassFactory(Tab);
         selectedButtonTextStyleNameProp = "selectedTabTextStyleName";
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TabBar.createAccessibilityImplementation != null)
         {
            TabBar.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         var navItem:IFlexDisplayObject = super.createNavItem(label,icon);
         DisplayObject(navItem).addEventListener(MouseEvent.MOUSE_DOWN,this.tab_mouseDownHandler);
         DisplayObject(navItem).addEventListener(MouseEvent.DOUBLE_CLICK,this.tab_doubleClickHandler);
         return navItem;
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(getChildIndex(DisplayObject(event.currentTarget)) == selectedIndex)
         {
            Button(event.currentTarget).selected = true;
            event.stopImmediatePropagation();
            return;
         }
         super.clickHandler(event);
      }
      
      private function tab_mouseDownHandler(event:MouseEvent) : void
      {
         selectButton(event.currentTarget.parent.getChildIndex(event.currentTarget),true,event);
      }
      
      private function tab_doubleClickHandler(event:MouseEvent) : void
      {
         Button(event.currentTarget).selected = true;
      }
   }
}

