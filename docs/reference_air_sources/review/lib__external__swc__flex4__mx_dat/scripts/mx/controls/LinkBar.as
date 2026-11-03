package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.styles.ISimpleStyleClient;
   
   [MaxChildren("0")]
   [IconFile("LinkBar.png")]
   [DefaultProperty("dataProvider")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
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
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="separatorWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="separatorSkin",type="Class",inherit="no")]
   [Style(name="separatorColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="linkButtonStyleName",type="String",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class LinkBar extends NavBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const SEPARATOR_NAME:String = "_separator";
      
      private var _selectedIndex:int = -1;
      
      private var _selectedIndexChanged:Boolean = false;
      
      public function LinkBar()
      {
         super();
         navItemFactory = new ClassFactory(LinkButton);
         addEventListener(MouseEvent.CLICK,this.defaultClickHandler);
         addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,this.childRemoveHandler);
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      override public function get selectedIndex() : int
      {
         return super.selectedIndex;
      }
      
      override public function set selectedIndex(value:int) : void
      {
         if(value == this.selectedIndex)
         {
            return;
         }
         this._selectedIndex = value;
         this._selectedIndexChanged = true;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var navItemStyleName:Object = null;
         var n:int = 0;
         var i:int = 0;
         super.styleChanged(styleProp);
         if(styleProp == "linkButtonStyleName")
         {
            navItemStyleName = getStyle("linkButtonStyleName");
         }
         if(Boolean(navItemStyleName))
         {
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               LinkButton(getChildAt(i)).styleName = navItemStyleName;
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._selectedIndexChanged)
         {
            this.hiliteSelectedNavItem(this._selectedIndex);
            super.selectedIndex = this._selectedIndex;
            this._selectedIndexChanged = false;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IFlexDisplayObject = null;
         var separator:IFlexDisplayObject = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var separatorHeight:Number = unscaledHeight - (vm.top + vm.bottom);
         var separatorWidth:Number = unscaledWidth - (vm.left + vm.right);
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IFlexDisplayObject(getChildAt(i));
            separator = IFlexDisplayObject(rawChildren.getChildByName(SEPARATOR_NAME + i));
            if(Boolean(separator))
            {
               separator.visible = false;
               if(i != 0)
               {
                  if(isVertical())
                  {
                     separator.move(vm.left,child.y - verticalGap);
                     separator.setActualSize(separatorWidth,verticalGap);
                     if(separator.y + separator.height < unscaledHeight - vm.bottom)
                     {
                        separator.visible = true;
                     }
                  }
                  else
                  {
                     separator.move(child.x - horizontalGap,vm.top);
                     separator.setActualSize(horizontalGap,separatorHeight);
                     if(separator.x + separator.width < unscaledWidth - vm.right)
                     {
                        separator.visible = true;
                     }
                  }
               }
            }
         }
      }
      
      override protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         var newLink:Button = Button(navItemFactory.newInstance());
         var linkButtonStyleName:String = getStyle("linkButtonStyleName");
         if(Boolean(linkButtonStyleName))
         {
            newLink.styleName = linkButtonStyleName;
         }
         if(Boolean(label) && label.length > 0)
         {
            newLink.label = label;
         }
         else
         {
            newLink.label = " ";
         }
         if(Boolean(icon))
         {
            newLink.setStyle("icon",icon);
         }
         addChild(newLink);
         newLink.addEventListener(MouseEvent.CLICK,this.clickHandler);
         var separatorClass:Class = Class(getStyle("separatorSkin"));
         var separator:DisplayObject = DisplayObject(new separatorClass());
         separator.name = SEPARATOR_NAME + (numChildren - 1);
         if(separator is ISimpleStyleClient)
         {
            ISimpleStyleClient(separator).styleName = this;
         }
         rawChildren.addChild(separator);
         return newLink;
      }
      
      override protected function hiliteSelectedNavItem(index:int) : void
      {
         var child:Button = null;
         if(this.selectedIndex != -1 && this.selectedIndex < numChildren)
         {
            child = Button(getChildAt(this.selectedIndex));
            child.enabled = true;
         }
         super.selectedIndex = index;
         if(index != -1)
         {
            child = Button(getChildAt(this.selectedIndex));
            child.enabled = false;
         }
      }
      
      override protected function resetNavItems() : void
      {
         var child:Button = null;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = Button(getChildAt(i));
            child.enabled = i != this.selectedIndex;
         }
         invalidateDisplayList();
      }
      
      private function childRemoveHandler(event:ChildExistenceChangedEvent) : void
      {
         var child:DisplayObject = event.relatedObject;
         var index:int = getChildIndex(child);
         var separator:DisplayObject = rawChildren.getChildByName(SEPARATOR_NAME + index);
         rawChildren.removeChild(separator);
         var n:int = numChildren - 1;
         for(var i:int = index; i < n; i++)
         {
            rawChildren.getChildByName(SEPARATOR_NAME + (i + 1)).name = SEPARATOR_NAME + i;
         }
      }
      
      private function defaultClickHandler(event:MouseEvent) : void
      {
         if(!(event is ItemClickEvent))
         {
            event.stopImmediatePropagation();
         }
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         var index:int = getChildIndex(Button(event.currentTarget));
         if(Boolean(targetStack))
         {
            if(index == this.selectedIndex)
            {
               this.hiliteSelectedNavItem(-1);
            }
            else
            {
               this.hiliteSelectedNavItem(index);
            }
         }
         super.clickHandler(event);
      }
   }
}

