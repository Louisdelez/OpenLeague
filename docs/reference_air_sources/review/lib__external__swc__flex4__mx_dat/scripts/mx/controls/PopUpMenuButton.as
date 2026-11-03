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
   [Style(name="popUpStyleName",type="String",inherit="no")]
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   public class PopUpMenuButton extends PopUpButton
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var dataProviderChanged:Boolean = false;
      
      private var labelSet:Boolean = false;
      
      private var popUpMenu:Menu = null;
      
      private var selectedIndex:int = -1;
      
      private var itemRenderer:IListItemRenderer = null;
      
      private var explicitIcon:Class = null;
      
      private var menuSelectedStyle:Boolean = false;
      
      private var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      private var _dataProvider:Object = null;
      
      private var _iconField:String = "icon";
      
      private var _iconFunction:Function;
      
      private var _label:String = "";
      
      private var _labelField:String = "label";
      
      private var _labelFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _showRoot:Boolean = true;
      
      private var _showRootChanged:Boolean = false;
      
      public function PopUpMenuButton()
      {
         super();
      }
      
      override public function set popUp(value:IUIComponent) : void
      {
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(this._dataDescriptor);
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         this._dataDescriptor = value;
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(this.popUpMenu))
         {
            return Menu(this.popUpMenu).dataProvider;
         }
         return this._dataProvider;
      }
      
      public function set dataProvider(value:Object) : void
      {
         this._dataProvider = value;
         this.dataProviderChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data",defaultValue="icon")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(value:String) : void
      {
         if(this._iconField != value)
         {
            this._iconField = value;
            if(Boolean(this.popUpMenu))
            {
               this.popUpMenu.iconField = this._iconField;
            }
            dispatchEvent(new Event("iconFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(value:Function) : void
      {
         if(this._iconFunction != value)
         {
            this._iconFunction = value;
            if(Boolean(this.popUpMenu))
            {
               this.popUpMenu.iconFunction = this._iconFunction;
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="")]
      override public function set label(value:String) : void
      {
         this.labelSet = true;
         this._label = value;
         super.label = this._label;
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         if(this._labelField != value)
         {
            this._labelField = value;
            if(Boolean(this.popUpMenu))
            {
               this.popUpMenu.labelField = this._labelField;
            }
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(this._labelFunction != value)
         {
            this._labelFunction = value;
            if(Boolean(this.popUpMenu))
            {
               this.popUpMenu.labelFunction = this._labelFunction;
            }
         }
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="true")]
      public function get showRoot() : Boolean
      {
         return this._showRoot;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(this._showRoot != value)
         {
            this._showRoot = value;
            this._showRootChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var cursor:IViewCursor = null;
         var item:* = undefined;
         if(this.dataProviderChanged && !this.popUpMenu)
         {
            this.getPopUp();
         }
         if(this._showRootChanged)
         {
            this._showRootChanged = false;
            if(this.popUpMenu != null)
            {
               this.popUpMenu.showRoot = this._showRoot;
            }
            invalidateDisplayList();
         }
         if(Boolean(this.popUpMenu) && this.dataProviderChanged)
         {
            this.popUpMenu.dataProvider = this._dataProvider;
            this.popUpMenu.validateNow();
            if(Boolean(this.dataProvider.length))
            {
               this.selectedIndex = 0;
               cursor = this.dataProvider.createCursor();
               cursor.seek(CursorBookmark.FIRST,0);
               item = cursor.current;
               if(this.labelSet)
               {
                  super.label = this._label;
               }
               else
               {
                  super.label = this.popUpMenu.itemToLabel(item);
               }
               this.setSafeIcon(this.popUpMenu.itemToIcon(item));
            }
            else
            {
               this.selectedIndex = -1;
               if(this.labelSet)
               {
                  super.label = this._label;
               }
               else
               {
                  super.label = "";
               }
               clearStyle("icon");
            }
            this.dataProviderChanged = false;
         }
         super.commitProperties();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "icon" || styleProp == null || styleProp == "styleName")
         {
            if(this.menuSelectedStyle)
            {
               if(Boolean(this.explicitIcon))
               {
                  this.menuSelectedStyle = false;
                  setStyle("icon",this.explicitIcon);
               }
            }
            else
            {
               this.explicitIcon = getStyle("icon");
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPopUp() : IUIComponent
      {
         super.getPopUp();
         if(!this.popUpMenu || !super.popUp)
         {
            this.popUpMenu = new Menu();
            this.popUpMenu.iconField = this._iconField;
            this.popUpMenu.iconFunction = this._iconFunction;
            this.popUpMenu.labelField = this._labelField;
            this.popUpMenu.labelFunction = this._labelFunction;
            this.popUpMenu.showRoot = this._showRoot;
            this.popUpMenu.dataDescriptor = this._dataDescriptor;
            this.popUpMenu.dataProvider = this._dataProvider;
            this.popUpMenu.addEventListener(MenuEvent.ITEM_CLICK,this.menuChangeHandler);
            this.popUpMenu.addEventListener(FlexEvent.VALUE_COMMIT,this.menuValueCommitHandler);
            super.popUp = this.popUpMenu;
            PopUpManager.addPopUp(super.popUp,this,false);
            super.popUp.owner = this;
         }
         return this.popUpMenu;
      }
      
      private function setSafeIcon(iconClass:Class) : void
      {
         this.menuSelectedStyle = true;
         setStyle("icon",iconClass);
         this.menuSelectedStyle = false;
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         super.clickHandler(event);
         if(!overArrowButton(event))
         {
            this.menuClickHandler(event);
         }
      }
      
      private function menuClickHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var cursor:IViewCursor = null;
         if(this.selectedIndex >= 0)
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.menu = this.popUpMenu;
            menuEvent.menu.selectedIndex = this.selectedIndex;
            cursor = this.dataProvider.createCursor();
            cursor.seek(CursorBookmark.FIRST,this.selectedIndex);
            menuEvent.item = cursor.current;
            menuEvent.itemRenderer = this.itemRenderer;
            menuEvent.index = this.selectedIndex;
            menuEvent.label = this.popUpMenu.itemToLabel(cursor.current);
            dispatchEvent(menuEvent);
            this.popUpMenu.selectedIndex = -1;
         }
      }
      
      private function menuValueCommitHandler(event:FlexEvent) : void
      {
         var cursor:IViewCursor = null;
         if(this.popUpMenu.selectedIndex >= 0)
         {
            cursor = this.dataProvider.createCursor();
            cursor.seek(CursorBookmark.FIRST,this.selectedIndex);
            this.selectedIndex = this.popUpMenu.selectedIndex;
            if(this.labelSet)
            {
               super.label = this._label;
            }
            else
            {
               super.label = this.popUpMenu.itemToLabel(cursor.current);
            }
            this.setSafeIcon(this.popUpMenu.itemToIcon(cursor.current));
         }
      }
      
      private function menuChangeHandler(event:MenuEvent) : void
      {
         var menuEvent:MenuEvent = null;
         if(event.index >= 0)
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.label = this.popUpMenu.itemToLabel(event.item);
            if(this.labelSet)
            {
               super.label = this._label;
            }
            else
            {
               super.label = this.popUpMenu.itemToLabel(event.item);
            }
            this.setSafeIcon(this.popUpMenu.itemToIcon(event.item));
            menuEvent.menu = this.popUpMenu;
            menuEvent.menu.selectedIndex = menuEvent.index = this.selectedIndex = event.index;
            menuEvent.item = event.item;
            this.itemRenderer = menuEvent.itemRenderer = event.itemRenderer;
            dispatchEvent(menuEvent);
         }
      }
   }
}

