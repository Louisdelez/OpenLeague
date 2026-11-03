package flexlib.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flexlib.containers.SuperTabNavigator;
   import flexlib.controls.tabBarClasses.SuperTab;
   import flexlib.events.SuperTabEvent;
   import flexlib.events.TabReorderEvent;
   import mx.collections.IList;
   import mx.containers.ViewStack;
   import mx.controls.Button;
   import mx.controls.TabBar;
   import mx.core.ClassFactory;
   import mx.core.DragSource;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.events.DragEvent;
   import mx.managers.DragManager;
   
   [IconFile("SuperTabBar.png")]
   [Event(name="tabUpdated",type="flexlib.events.SuperTabEvent")]
   [Event(name="tabClose",type="flexlib.events.SuperTabEvent")]
   [Event(name="tabsReordered",type="flexlib.events.TabReorderEvent")]
   public class SuperTabBar extends TabBar
   {
      
      public static const TABS_REORDERED:String = "tabsReordered";
      
      private var _dragEnabled:Boolean = true;
      
      private var _dropEnabled:Boolean = true;
      
      private var _closePolicy:String = SuperTab.CLOSE_ROLLOVER;
      
      private var _editableTabLabels:Boolean = false;
      
      public function SuperTabBar()
      {
         super();
         navItemFactory = new ClassFactory(getTabClass());
      }
      
      private function addDragListeners(tab:SuperTab) : void
      {
         tab.addEventListener(MouseEvent.MOUSE_DOWN,tryDrag,false,0,true);
         tab.addEventListener(MouseEvent.MOUSE_UP,removeDrag,false,0,true);
      }
      
      protected function getTabClass() : Class
      {
         return SuperTab;
      }
      
      private function doDrag(event:MouseEvent) : void
      {
         var tab:SuperTab = null;
         var ds:DragSource = null;
         var bmapData:BitmapData = null;
         var dragProxy:Bitmap = null;
         var obj:UIComponent = null;
         if(event.target is IUIComponent && (IUIComponent(event.target) is SuperTab || IUIComponent(event.target).parent is SuperTab && !(IUIComponent(event.target) is Button)))
         {
            if(IUIComponent(event.target) is SuperTab)
            {
               tab = IUIComponent(event.target) as SuperTab;
            }
            if(IUIComponent(event.target).parent is SuperTab)
            {
               tab = IUIComponent(event.target).parent as SuperTab;
            }
            ds = new DragSource();
            ds.addData(event.currentTarget,"tabDrag");
            if(dataProvider is IList)
            {
               ds.addData(event.currentTarget,"listDP");
            }
            if(dataProvider is ViewStack)
            {
               ds.addData(event.currentTarget,"stackDP");
            }
            bmapData = new BitmapData(tab.width,tab.height,true,0);
            bmapData.draw(tab);
            dragProxy = new Bitmap(bmapData);
            obj = new UIComponent();
            obj.addChild(dragProxy);
            event.target.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
            DragManager.doDrag(IUIComponent(event.target),ds,event,obj);
         }
      }
      
      private function addDropListeners(tab:SuperTab) : void
      {
         tab.addEventListener(DragEvent.DRAG_ENTER,tabDragEnter,false,0,true);
         tab.addEventListener(DragEvent.DRAG_OVER,tabDragOver,false,0,true);
         tab.addEventListener(DragEvent.DRAG_DROP,tabDragDrop,false,0,true);
         tab.addEventListener(DragEvent.DRAG_EXIT,tabDragExit,false,0,true);
      }
      
      private function tabDragDrop(event:DragEvent) : void
      {
         var dropTab:SuperTab = null;
         var dragTab:SuperTab = null;
         var left:Boolean = false;
         var parentBar:SuperTabBar = null;
         var object:* = undefined;
         var oldIndex:Number = NaN;
         var newIndex:Number = NaN;
         if(Boolean(event.dragSource.hasFormat("tabDrag")) && event.draggedItem != event.dragInitiator)
         {
            dropTab = event.currentTarget as SuperTab;
            dragTab = event.dragInitiator as SuperTab;
            left = event.localX < dropTab.width / 2;
            object = event.dragInitiator;
            while(Boolean(object) && Boolean(object.parent))
            {
               object = object.parent;
               if(object is SuperTab)
               {
                  dragTab = object;
               }
               else if(object is SuperTabBar)
               {
                  parentBar = object;
                  break;
               }
            }
            dropTab.showIndicator = false;
            oldIndex = Number(parentBar.getChildIndex(dragTab));
            newIndex = Number(this.getChildIndex(dropTab));
            if(!left)
            {
               newIndex += 1;
            }
            this.dispatchEvent(new TabReorderEvent(SuperTabBar.TABS_REORDERED,false,true,parentBar,oldIndex,newIndex));
         }
      }
      
      override protected function updateNavItemLabel(index:int, label:String) : void
      {
         super.updateNavItemLabel(index,label);
         if(dataProvider is SuperTabNavigator)
         {
            SuperTabNavigator(dataProvider).invalidateDisplayList();
         }
         dispatchEvent(new SuperTabEvent(SuperTabEvent.TAB_UPDATED,index));
      }
      
      public function get closePolicy() : String
      {
         return _closePolicy;
      }
      
      private function removeDragListeners(tab:SuperTab) : void
      {
         tab.removeEventListener(MouseEvent.MOUSE_DOWN,tryDrag);
         tab.removeEventListener(MouseEvent.MOUSE_UP,removeDrag);
      }
      
      public function get dropEnabled() : Boolean
      {
         return _dropEnabled;
      }
      
      public function resetTabs() : void
      {
         this.resetNavItems();
      }
      
      private function tryDrag(e:MouseEvent) : void
      {
         e.target.addEventListener(MouseEvent.MOUSE_MOVE,doDrag);
      }
      
      public function get editableTabLabels() : Boolean
      {
         return _editableTabLabels;
      }
      
      private function tabDragEnter(event:DragEvent) : void
      {
         if(Boolean(event.dragSource.hasFormat("tabDrag")) && event.draggedItem != event.dragInitiator)
         {
            if(this.dataProvider is ViewStack)
            {
               if(event.dragSource.hasFormat("stackDP"))
               {
                  DragManager.acceptDragDrop(IUIComponent(event.target));
               }
            }
            else if(this.dataProvider is IList)
            {
               if(event.dragSource.hasFormat("listDP"))
               {
                  DragManager.acceptDragDrop(IUIComponent(event.target));
               }
            }
         }
      }
      
      private function removeDropListeners(tab:SuperTab) : void
      {
         tab.removeEventListener(DragEvent.DRAG_ENTER,tabDragEnter);
         tab.removeEventListener(DragEvent.DRAG_OVER,tabDragOver);
         tab.removeEventListener(DragEvent.DRAG_DROP,tabDragDrop);
         tab.removeEventListener(DragEvent.DRAG_EXIT,tabDragExit);
      }
      
      override protected function createNavItem(label:String, icon:Class = null) : IFlexDisplayObject
      {
         var tab:SuperTab = null;
         tab = super.createNavItem(label,icon) as SuperTab;
         tab.closePolicy = this.closePolicy;
         tab.doubleClickToEdit = this.editableTabLabels;
         if(dragEnabled)
         {
            addDragListeners(tab);
         }
         if(dropEnabled)
         {
            addDropListeners(tab);
         }
         tab.addEventListener(SuperTab.CLOSE_TAB_EVENT,onCloseTabClicked,false,0,true);
         tab.addEventListener(SuperTabEvent.TAB_UPDATED,onTabUpdated);
         return tab;
      }
      
      private function onTabUpdated(event:SuperTabEvent) : void
      {
         var tab:SuperTab = null;
         var index:Number = NaN;
         var dpItem:Object = null;
         tab = event.currentTarget as SuperTab;
         index = Number(this.getChildIndex(tab));
         if(dataProvider is IList)
         {
            dpItem = dataProvider.getItemAt(index);
         }
         else if(dataProvider is ViewStack)
         {
            dpItem = dataProvider.getChildAt(index);
         }
         if(Boolean(labelField))
         {
            dpItem[labelField] = tab.label;
         }
         else if(dpItem.hasOwnProperty("label"))
         {
            dpItem.label = tab.label;
         }
      }
      
      public function set closePolicy(value:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:SuperTab = null;
         this._closePolicy = value;
         this.invalidateDisplayList();
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            child = SuperTab(getChildAt(i));
            child.closePolicy = value;
         }
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:SuperTab = null;
         this._dropEnabled = value;
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            child = SuperTab(getChildAt(i));
            if(value)
            {
               addDropListeners(child);
            }
            else
            {
               removeDropListeners(child);
            }
         }
      }
      
      private function tabDragOver(event:DragEvent) : void
      {
         var dropTab:SuperTab = null;
         var dropIndex:Number = NaN;
         var gap:Number = NaN;
         var left:Boolean = false;
         if(Boolean(event.dragSource.hasFormat("tabDrag")) && event.dragInitiator != event.currentTarget)
         {
            dropTab = event.currentTarget as SuperTab;
            dropIndex = Number(this.getChildIndex(dropTab));
            gap = 0;
            left = event.localX < dropTab.width / 2;
            if(left && dropIndex > 0 || dropIndex < this.numChildren - 1)
            {
               gap = this.getStyle("horizontalGap") / 2;
            }
            gap = left ? -gap : dropTab.width + gap;
            dropTab.showIndicatorAt(gap);
            DragManager.showFeedback(DragManager.LINK);
         }
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:SuperTab = null;
         this._dragEnabled = value;
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            child = SuperTab(getChildAt(i));
            if(value)
            {
               addDragListeners(child);
            }
            else
            {
               removeDragListeners(child);
            }
         }
      }
      
      public function onCloseTabClicked(event:Event) : void
      {
         var index:int = 0;
         var tabCloseEvent:SuperTabEvent = null;
         index = int(getChildIndex(DisplayObject(event.currentTarget)));
         tabCloseEvent = new SuperTabEvent(SuperTabEvent.TAB_CLOSE,index,false,true);
         dispatchEvent(tabCloseEvent);
         if(!tabCloseEvent.isDefaultPrevented())
         {
            if(dataProvider is IList)
            {
               dataProvider.removeItemAt(index);
            }
            else if(dataProvider is ViewStack)
            {
               dataProvider.removeChildAt(index);
            }
         }
      }
      
      private function tabDragExit(event:DragEvent) : void
      {
         var dropTab:SuperTab = null;
         dropTab = event.currentTarget as SuperTab;
         dropTab.showIndicator = false;
      }
      
      public function getClosePolicyForTab(index:int) : String
      {
         return (getChildAt(index) as SuperTab).closePolicy;
      }
      
      public function get dragEnabled() : Boolean
      {
         return _dragEnabled;
      }
      
      public function setClosePolicyForTab(index:int, value:String) : void
      {
         if(this.numChildren >= index + 1)
         {
            (getChildAt(index) as SuperTab).closePolicy = value;
         }
      }
      
      public function set editableTabLabels(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:SuperTab = null;
         this._editableTabLabels = value;
         n = int(numChildren);
         for(i = 0; i < n; i++)
         {
            child = SuperTab(getChildAt(i));
            child.doubleClickToEdit = value;
         }
      }
      
      private function removeDrag(e:MouseEvent) : void
      {
         e.target.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
      }
      
      override protected function updateNavItemIcon(index:int, icon:Class) : void
      {
         super.updateNavItemIcon(index,icon);
         dispatchEvent(new SuperTabEvent(SuperTabEvent.TAB_UPDATED,index));
      }
   }
}

