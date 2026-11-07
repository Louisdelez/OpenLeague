package flexlib.baseClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.controls.Menu;
   import mx.controls.PopUpButton;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.IUIComponent;
   import mx.events.FlexEvent;
   import mx.events.MenuEvent;
   import mx.managers.PopUpManager;
   
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
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   public class PopUpMenuButtonBase extends PopUpButton
   {
      
      private var _labelField:String = "label";
      
      protected var popUpMenu:Menu = null;
      
      private var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      private var _labelFunction:Function;
      
      private var itemRenderer:IListItemRenderer = null;
      
      private var labelSet:Boolean = false;
      
      private var _dataProvider:Object = null;
      
      private var _label:String = "";
      
      private var _showRootChanged:Boolean = false;
      
      private var dataProviderChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _showRoot:Boolean = true;
      
      private var selectedIndex:int = -1;
      
      public function PopUpMenuButtonBase()
      {
         super();
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         super.clickHandler(event);
         if(!overArrowButton(event))
         {
            menuClickHandler(event);
         }
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
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         _dataDescriptor = value;
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="true")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override public function set popUp(value:IUIComponent) : void
      {
         super.popUp = value;
      }
      
      override protected function commitProperties() : void
      {
         var item:* = undefined;
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
               item = popUpMenu.dataProvider[selectedIndex];
               if(labelSet)
               {
                  super.label = _label;
               }
               else
               {
                  super.label = popUpMenu.itemToLabel(item);
               }
               setStyle("icon",popUpMenu.itemToIcon(item));
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
      
      [Inspectable(category="General",defaultValue="")]
      override public function set label(value:String) : void
      {
         labelSet = true;
         _label = value;
         super.label = _label;
      }
      
      protected function menuChangeHandler(event:MenuEvent) : void
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
            setStyle("icon",popUpMenu.itemToIcon(event.item));
            menuEvent.menu = popUpMenu;
            menuEvent.menu.selectedIndex = menuEvent.index = selectedIndex = event.index;
            menuEvent.item = event.item;
            itemRenderer = menuEvent.itemRenderer = event.itemRenderer;
            dispatchEvent(menuEvent);
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      [Inspectable(category="Data")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
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
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         super.getPopUp();
         if(!popUpMenu)
         {
            popUpMenu = new Menu();
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
      
      public function set dataProvider(value:Object) : void
      {
         _dataProvider = value;
         dataProviderChanged = true;
         getPopUp();
         invalidateProperties();
      }
      
      private function menuClickHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         if(selectedIndex >= 0)
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.menu = popUpMenu;
            menuEvent.menu.selectedIndex = selectedIndex;
            menuEvent.item = popUpMenu.dataProvider[selectedIndex];
            menuEvent.itemRenderer = itemRenderer;
            menuEvent.index = selectedIndex;
            menuEvent.label = popUpMenu.itemToLabel(popUpMenu.dataProvider[selectedIndex]);
            dispatchEvent(menuEvent);
            popUpMenu.selectedIndex = -1;
         }
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(popUpMenu))
         {
            return Menu(popUpMenu).dataProvider;
         }
         return null;
      }
      
      protected function menuValueCommitHandler(event:FlexEvent) : void
      {
         if(popUpMenu.selectedIndex >= 0)
         {
            selectedIndex = popUpMenu.selectedIndex;
            if(labelSet)
            {
               super.label = _label;
            }
            else
            {
               super.label = popUpMenu.itemToLabel(popUpMenu.dataProvider[selectedIndex]);
            }
            setStyle("icon",popUpMenu.itemToIcon(popUpMenu.dataProvider[selectedIndex]));
         }
      }
   }
}

