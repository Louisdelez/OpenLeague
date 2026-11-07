package mx.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.MenuEvent;
   import mx.managers.PopUpManager;
   
   use namespace mx_internal;
   
   [RequiresDataBinding("true")]
   [Exclude(name="selectedUpSkin",kind="style")]
   [Exclude(name="selectedUpIcon",kind="style")]
   [Exclude(name="selectedOverSkin",kind="style")]
   [Exclude(name="selectedOverIcon",kind="style")]
   [Exclude(name="selectedDownSkin",kind="style")]
   [Exclude(name="selectedDownIcon",kind="style")]
   [Exclude(name="selectedDisabledSkin",kind="style")]
   [Exclude(name="selectedDisabledIcon",kind="style")]
   [Exclude(name="toggle",kind="property")]
   [Style(name="popUpStyleName",type="String",inherit="no")]
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   public class PopUpMenuButton extends PopUpButton
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _iconField:String = "icon";
      
      private var _labelField:String = "label";
      
      private var itemRenderer:IListItemRenderer = null;
      
      private var _dataProvider:Object = null;
      
      private var menuSelectedStyle:Boolean = false;
      
      private var popUpMenu:Menu = null;
      
      private var explicitIcon:Class = null;
      
      private var labelSet:Boolean = false;
      
      private var _iconFunction:Function;
      
      private var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      mx_internal var _showRoot:Boolean = true;
      
      private var _labelFunction:Function;
      
      private var _showRootChanged:Boolean = false;
      
      private var selectedIndex:int = -1;
      
      private var dataProviderChanged:Boolean = false;
      
      private var _label:String = "";
      
      public function PopUpMenuButton()
      {
         super();
      }
      
      [Inspectable(category="Data",defaultValue="icon")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return _iconField;
      }
      
      public function set iconField(value:String) : void
      {
         if(_iconField != value)
         {
            _iconField = value;
            if(Boolean(popUpMenu))
            {
               popUpMenu.iconField = _iconField;
            }
            dispatchEvent(new Event("iconFieldChanged"));
         }
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         _dataDescriptor = value;
      }
      
      override public function set popUp(value:IUIComponent) : void
      {
      }
      
      override mx_internal function getPopUp() : IUIComponent
      {
         super.mx_internal::getPopUp();
         if(!popUpMenu || !super.popUp)
         {
            popUpMenu = new Menu();
            popUpMenu.iconField = _iconField;
            popUpMenu.iconFunction = _iconFunction;
            popUpMenu.labelField = _labelField;
            popUpMenu.labelFunction = _labelFunction;
            popUpMenu.showRoot = _showRoot;
            popUpMenu.dataDescriptor = _dataDescriptor;
            popUpMenu.dataProvider = _dataProvider;
            popUpMenu.addEventListener(MenuEvent.ITEM_CLICK,menuChangeHandler);
            popUpMenu.addEventListener(FlexEvent.VALUE_COMMIT,menuValueCommitHandler);
            super.popUp = popUpMenu;
            PopUpManager.addPopUp(super.popUp,this,false);
            super.popUp.owner = this;
         }
         return popUpMenu;
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         super.clickHandler(event);
         if(!overArrowButton(event))
         {
            menuClickHandler(event);
         }
      }
      
      private function setSafeIcon(iconClass:Class) : void
      {
         menuSelectedStyle = true;
         setStyle("icon",iconClass);
         menuSelectedStyle = false;
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(popUpMenu))
         {
            return Menu(popUpMenu).dataProvider;
         }
         return _dataProvider;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "icon" || styleProp == null || styleProp == "styleName")
         {
            if(menuSelectedStyle)
            {
               if(Boolean(explicitIcon))
               {
                  menuSelectedStyle = false;
                  setStyle("icon",explicitIcon);
               }
            }
            else
            {
               explicitIcon = getStyle("icon");
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var cursor:IViewCursor = null;
         var item:* = undefined;
         if(dataProviderChanged && !popUpMenu)
         {
            getPopUp();
         }
         if(_showRootChanged)
         {
            _showRootChanged = false;
            if(popUpMenu != null)
            {
               popUpMenu.showRoot = _showRoot;
            }
            invalidateDisplayList();
         }
         if(Boolean(popUpMenu) && dataProviderChanged)
         {
            popUpMenu.dataProvider = _dataProvider;
            popUpMenu.validateNow();
            if(Boolean(dataProvider.length))
            {
               selectedIndex = 0;
               cursor = dataProvider.createCursor();
               cursor.seek(CursorBookmark.FIRST,0);
               item = cursor.current;
               if(labelSet)
               {
                  super.label = _label;
               }
               else
               {
                  super.label = popUpMenu.itemToLabel(item);
               }
               setSafeIcon(popUpMenu.itemToIcon(item));
            }
            else
            {
               selectedIndex = -1;
               if(labelSet)
               {
                  super.label = _label;
               }
               else
               {
                  super.label = "";
               }
               clearStyle("icon");
            }
            dataProviderChanged = false;
         }
         super.commitProperties();
      }
      
      public function set labelField(value:String) : void
      {
         if(_labelField != value)
         {
            _labelField = value;
            if(Boolean(popUpMenu))
            {
               popUpMenu.labelField = _labelField;
            }
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      private function menuChangeHandler(event:MenuEvent) : void
      {
         var menuEvent:MenuEvent = null;
         if(event.index >= 0)
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.label = popUpMenu.itemToLabel(event.item);
            if(labelSet)
            {
               super.label = _label;
            }
            else
            {
               super.label = popUpMenu.itemToLabel(event.item);
            }
            setSafeIcon(popUpMenu.itemToIcon(event.item));
            menuEvent.menu = popUpMenu;
            menuEvent.menu.selectedIndex = menuEvent.index = selectedIndex = event.index;
            menuEvent.item = event.item;
            itemRenderer = menuEvent.itemRenderer = event.itemRenderer;
            dispatchEvent(menuEvent);
         }
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(_labelFunction != value)
         {
            _labelFunction = value;
            if(Boolean(popUpMenu))
            {
               popUpMenu.labelFunction = _labelFunction;
            }
         }
      }
      
      private function menuValueCommitHandler(event:FlexEvent) : void
      {
         var cursor:IViewCursor = null;
         if(popUpMenu.selectedIndex >= 0)
         {
            cursor = dataProvider.createCursor();
            cursor.seek(CursorBookmark.FIRST,selectedIndex);
            selectedIndex = popUpMenu.selectedIndex;
            if(labelSet)
            {
               super.label = _label;
            }
            else
            {
               super.label = popUpMenu.itemToLabel(cursor.current);
            }
            setSafeIcon(popUpMenu.itemToIcon(cursor.current));
         }
      }
      
      public function set iconFunction(value:Function) : void
      {
         if(_iconFunction != value)
         {
            _iconFunction = value;
            if(Boolean(popUpMenu))
            {
               popUpMenu.iconFunction = _iconFunction;
            }
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      private function menuClickHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var cursor:IViewCursor = null;
         if(selectedIndex >= 0)
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.menu = popUpMenu;
            menuEvent.menu.selectedIndex = selectedIndex;
            cursor = dataProvider.createCursor();
            cursor.seek(CursorBookmark.FIRST,selectedIndex);
            menuEvent.item = cursor.current;
            menuEvent.itemRenderer = itemRenderer;
            menuEvent.index = selectedIndex;
            menuEvent.label = popUpMenu.itemToLabel(cursor.current);
            dispatchEvent(menuEvent);
            popUpMenu.selectedIndex = -1;
         }
      }
      
      [Inspectable(category="General",defaultValue="")]
      override public function set label(value:String) : void
      {
         labelSet = true;
         _label = value;
         super.label = _label;
      }
      
      [Inspectable(category="Data")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      [Inspectable(category="Data")]
      public function get iconFunction() : Function
      {
         return _iconFunction;
      }
      
      public function set dataProvider(value:Object) : void
      {
         _dataProvider = value;
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            _showRoot = value;
            _showRootChanged = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="true")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
   }
}

