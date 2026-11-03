package mx.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.xml.XMLNode;
   import mx.automation.IAutomationObject;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.Application;
   import mx.core.EventPriority;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexNativeMenuEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.ISystemManager;
   
   [Event(name="itemClick",type="mx.events.FlexNativeMenuEvent")]
   [Event(name="menuShow",type="mx.events.FlexNativeMenuEvent")]
   public class FlexNativeMenu extends EventDispatcher implements ILayoutManagerClient, IFlexContextMenu, IAutomationObject
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var MNEMONIC_INDEX_CHARACTER:String = "_";
      
      private var _automationDelegate:IAutomationObject;
      
      private var _automationName:String = null;
      
      private var _automationOwner:DisplayObjectContainer;
      
      private var _automationParent:DisplayObjectContainer;
      
      private var _showInAutomationHierarchy:Boolean = true;
      
      private var _initialized:Boolean = false;
      
      private var _nestLevel:int = 1;
      
      private var _processedDescriptors:Boolean = false;
      
      private var _updateCompletePendingFlag:Boolean = false;
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var _nativeMenu:NativeMenu = new NativeMenu();
      
      private var dataDescriptorChanged:Boolean = false;
      
      private var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      private var dataProviderChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootModel:ICollectionView;
      
      private var _hasRoot:Boolean = false;
      
      private var keyEquivalentFieldChanged:Boolean = false;
      
      private var _keyEquivalentField:String = "keyEquivalent";
      
      private var _keyEquivalentFunction:Function;
      
      private var keyEquivalentModifiersFunctionChanged:Boolean = false;
      
      private var _keyEquivalentModifiersFunction:Function;
      
      private var labelFieldChanged:Boolean = false;
      
      private var _labelField:String = "label";
      
      private var _labelFunction:Function;
      
      private var mnemonicIndexFieldChanged:Boolean = false;
      
      private var _mnemonicIndexField:String = "mnemonicIndex";
      
      private var _mnemonicIndexFunction:Function;
      
      private var _showRoot:Boolean = true;
      
      private var showRootChanged:Boolean = false;
      
      public function FlexNativeMenu()
      {
         this._keyEquivalentModifiersFunction = this.keyEquivalentModifiersDefaultFunction;
         super();
         this._nativeMenu.addEventListener(Event.DISPLAYING,this.menuDisplayHandler,false,0,true);
      }
      
      public function get automationDelegate() : Object
      {
         return this._automationDelegate;
      }
      
      public function set automationDelegate(value:Object) : void
      {
         this._automationDelegate = value as IAutomationObject;
      }
      
      public function get automationName() : String
      {
         if(Boolean(this._automationName))
         {
            return this._automationName;
         }
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.automationName;
         }
         return "";
      }
      
      public function set automationName(value:String) : void
      {
         this._automationName = value;
      }
      
      public function get automationValue() : Array
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.automationValue;
         }
         return [];
      }
      
      public function get numAutomationChildren() : int
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.numAutomationChildren;
         }
         return 0;
      }
      
      public function get automationTabularData() : Object
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.automationTabularData;
         }
         return null;
      }
      
      public function get automationOwner() : DisplayObjectContainer
      {
         return Boolean(this._automationOwner) ? this._automationOwner : this.automationParent;
      }
      
      public function set automationOwner(value:DisplayObjectContainer) : void
      {
         this._automationOwner = value;
      }
      
      public function get automationParent() : DisplayObjectContainer
      {
         return this._automationParent;
      }
      
      public function set automationParent(value:DisplayObjectContainer) : void
      {
         this._automationParent = value;
      }
      
      public function get automationEnabled() : Boolean
      {
         return true;
      }
      
      public function get automationVisible() : Boolean
      {
         return true;
      }
      
      public function get showInAutomationHierarchy() : Boolean
      {
         return this._showInAutomationHierarchy;
      }
      
      public function set showInAutomationHierarchy(value:Boolean) : void
      {
         this._showInAutomationHierarchy = value;
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function set initialized(value:Boolean) : void
      {
         this._initialized = value;
      }
      
      public function get nestLevel() : int
      {
         return this._nestLevel;
      }
      
      public function set nestLevel(value:int) : void
      {
         this._nestLevel = value;
         this.invalidateProperties();
      }
      
      public function get processedDescriptors() : Boolean
      {
         return this._processedDescriptors;
      }
      
      public function set processedDescriptors(value:Boolean) : void
      {
         this._processedDescriptors = value;
      }
      
      public function get updateCompletePendingFlag() : Boolean
      {
         return this._updateCompletePendingFlag;
      }
      
      public function set updateCompletePendingFlag(value:Boolean) : void
      {
         this._updateCompletePendingFlag = value;
      }
      
      [Bindable("nativeMenuUpdate")]
      public function get nativeMenu() : NativeMenu
      {
         return this._nativeMenu;
      }
      
      [Inspectable(category="Data")]
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(this._dataDescriptor);
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         this._dataDescriptor = value;
         this.dataDescriptorChanged = true;
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(this._rootModel))
         {
            return this._rootModel;
         }
         return null;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(this._rootModel))
         {
            this._rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
         }
         if(typeof value == "string")
         {
            value = new XML(value);
         }
         else if(value is XMLNode)
         {
            value = new XML(XMLNode(value).toString());
         }
         else if(value is XMLList)
         {
            value = new XMLListCollection(value as XMLList);
         }
         if(value is XML)
         {
            this._hasRoot = true;
            xl = new XMLList();
            xl += value;
            this._rootModel = new XMLListCollection(xl);
         }
         else if(value is ICollectionView)
         {
            this._rootModel = ICollectionView(value);
            if(this._rootModel.length == 1)
            {
               this._hasRoot = true;
            }
         }
         else if(value is Array)
         {
            this._rootModel = new ArrayCollection(value as Array);
         }
         else if(value is Object)
         {
            this._hasRoot = true;
            tmp = [];
            tmp.push(value);
            this._rootModel = new ArrayCollection(tmp);
         }
         else
         {
            this._rootModel = new ArrayCollection();
         }
         this._rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         this.dataProviderChanged = true;
         this.invalidateProperties();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         this.collectionChangeHandler(event);
         dispatchEvent(event);
      }
      
      public function get hasRoot() : Boolean
      {
         return this._hasRoot;
      }
      
      [Inspectable(category="Data",defaultValue="keyEquivalent")]
      [Bindable("keyEquivalentChanged")]
      public function get keyEquivalentField() : String
      {
         return this._keyEquivalentField;
      }
      
      public function set keyEquivalentField(value:String) : void
      {
         if(this._keyEquivalentField != value)
         {
            this._keyEquivalentField = value;
            this.keyEquivalentFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("keyEquivalentFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("keyEquivalentFunctionChanged")]
      public function get keyEquivalentFunction() : Function
      {
         return this._keyEquivalentFunction;
      }
      
      public function set keyEquivalentFunction(value:Function) : void
      {
         if(this._keyEquivalentFunction != value)
         {
            this._keyEquivalentFunction = value;
            this.keyEquivalentFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("keyEquivalentFunctionChanged"));
         }
      }
      
      private function keyEquivalentModifiersDefaultFunction(data:Object) : Array
      {
         var i:int = 0;
         var modifier:* = undefined;
         var modifiers:Array = [];
         var xmlModifiers:Array = ["@altKey","@cmdKey","@ctrlKey","@shiftKey","@commandKey","@controlKey"];
         var objectModifiers:Array = ["altKey","cmdKey","ctrlKey","shiftKey","commandKey","controlKey"];
         var keyboardModifiers:Array = [Keyboard.ALTERNATE,Keyboard.COMMAND,Keyboard.CONTROL,Keyboard.SHIFT,Keyboard.COMMAND,Keyboard.CONTROL];
         if(data is XML)
         {
            for(i = 0; i < xmlModifiers.length; i++)
            {
               try
               {
                  modifier = data[xmlModifiers[i]];
                  if(modifier[0] == true)
                  {
                     modifiers.push(keyboardModifiers[i]);
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         else if(data is Object)
         {
            for(i = 0; i < objectModifiers.length; i++)
            {
               try
               {
                  modifier = data[objectModifiers[i]];
                  if(String(modifier).toLowerCase() == "true")
                  {
                     modifiers.push(keyboardModifiers[i]);
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         return modifiers;
      }
      
      [Inspectable(category="Data")]
      [Bindable("keyEquivalentModifiersFunctionChanged")]
      public function get keyEquivalentModifiersFunction() : Function
      {
         return this._keyEquivalentModifiersFunction;
      }
      
      public function set keyEquivalentModifiersFunction(value:Function) : void
      {
         if(this._keyEquivalentModifiersFunction != value)
         {
            this._keyEquivalentModifiersFunction = value;
            this.keyEquivalentModifiersFunctionChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("keyEquivalentModifiersFunctionChanged"));
         }
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
            this.labelFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(this._labelFunction != value)
         {
            this._labelFunction = value;
            this.labelFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("labelFunctionChanged"));
         }
      }
      
      [Inspectable(category="Data",defaultValue="mnemonicIndex")]
      [Bindable("mnemonicIndexChanged")]
      public function get mnemonicIndexField() : String
      {
         return this._mnemonicIndexField;
      }
      
      public function set mnemonicIndexField(value:String) : void
      {
         if(this._mnemonicIndexField != value)
         {
            this._mnemonicIndexField = value;
            this.mnemonicIndexFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("mnemonicIndexFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("mnemonicIndexFunctionChanged")]
      public function get mnemonicIndexFunction() : Function
      {
         return this._mnemonicIndexFunction;
      }
      
      public function set mnemonicIndexFunction(value:Function) : void
      {
         if(this._mnemonicIndexFunction != value)
         {
            this._mnemonicIndexFunction = value;
            this.mnemonicIndexFieldChanged = true;
            this.invalidateProperties();
            dispatchEvent(new Event("mnemonicIndexFunctionChanged"));
         }
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="false")]
      public function get showRoot() : Boolean
      {
         return this._showRoot;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(this._showRoot != value)
         {
            this.showRootChanged = true;
            this._showRoot = value;
            this.invalidateProperties();
         }
      }
      
      public function invalidateProperties() : void
      {
         var myTimer:Timer = null;
         if(!this.invalidatePropertiesFlag && this.nestLevel > 0)
         {
            this.invalidatePropertiesFlag = true;
            if(Boolean(UIComponentGlobals.layoutManager))
            {
               UIComponentGlobals.layoutManager.invalidateProperties(this);
            }
            else
            {
               myTimer = new Timer(100,1);
               myTimer.addEventListener(TimerEvent.TIMER,this.validatePropertiesTimerHandler);
               myTimer.start();
            }
         }
      }
      
      public function validatePropertiesTimerHandler(event:TimerEvent) : void
      {
         this.validateProperties();
      }
      
      public function validateProperties() : void
      {
         if(this.invalidatePropertiesFlag)
         {
            this.commitProperties();
            this.invalidatePropertiesFlag = false;
         }
      }
      
      public function validateSize(recursive:Boolean = false) : void
      {
      }
      
      public function validateDisplayList() : void
      {
      }
      
      public function validateNow() : void
      {
         if(this.invalidatePropertiesFlag)
         {
            this.validateProperties();
         }
      }
      
      public function setContextMenu(component:InteractiveObject) : void
      {
         var systemManager:ISystemManager = null;
         component.contextMenu = this.nativeMenu;
         if(component is Application)
         {
            systemManager = Application(component).systemManager;
            if(systemManager is InteractiveObject)
            {
               InteractiveObject(systemManager).contextMenu = this.nativeMenu;
            }
         }
         this.automationParent = component as DisplayObjectContainer;
         this.automationOwner = component as DisplayObjectContainer;
         component.dispatchEvent(new Event("flexContextMenuChanged"));
      }
      
      public function unsetContextMenu(component:InteractiveObject) : void
      {
         component.contextMenu = null;
         this.automationParent = null;
         this.automationOwner = null;
         component.dispatchEvent(new Event("flexContextMenuChanged"));
      }
      
      protected function commitProperties() : void
      {
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
         if(this.showRootChanged)
         {
            if(!this._hasRoot)
            {
               this.showRootChanged = false;
            }
         }
         if(this.dataProviderChanged || this.showRootChanged || this.labelFieldChanged || this.dataDescriptorChanged)
         {
            this.dataProviderChanged = false;
            this.showRootChanged = false;
            this.labelFieldChanged = false;
            this.dataDescriptorChanged = false;
            if(Boolean(this._rootModel) && Boolean(!this._showRoot) && this._hasRoot)
            {
               rootItem = this._rootModel.createCursor().current;
               if(rootItem != null && Boolean(this._dataDescriptor.isBranch(rootItem,this._rootModel)) && Boolean(this._dataDescriptor.hasChildren(rootItem,this._rootModel)))
               {
                  tmpCollection = this._dataDescriptor.getChildren(rootItem,this._rootModel);
               }
            }
            this.clearMenu(this._nativeMenu);
            if(Boolean(this._rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = this._rootModel;
               }
               tmpCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
               this.populateMenu(this._nativeMenu,tmpCollection);
            }
            dispatchEvent(new Event("nativeMenuChange"));
         }
      }
      
      private function createMenu() : NativeMenu
      {
         var menu:NativeMenu = new NativeMenu();
         menu.addEventListener(Event.DISPLAYING,this.menuDisplayHandler,false,0,true);
         return menu;
      }
      
      private function clearMenu(menu:NativeMenu) : void
      {
         var numItems:int = int(menu.numItems);
         for(var i:int = 0; i < numItems; i++)
         {
            menu.removeItemAt(0);
         }
      }
      
      private function populateMenu(menu:NativeMenu, collection:ICollectionView) : NativeMenu
      {
         var collectionLength:int = int(collection.length);
         for(var i:int = 0; i < collectionLength; i++)
         {
            try
            {
               this.insertMenuItem(menu,i,collection[i]);
            }
            catch(e:ItemPendingError)
            {
            }
         }
         return menu;
      }
      
      private function insertMenuItem(menu:NativeMenu, index:int, data:Object) : void
      {
         var labelData:String = null;
         var mnemonicIndex:int = 0;
         if(this.dataProviderChanged)
         {
            this.commitProperties();
            return;
         }
         var type:String = this.dataDescriptor.getType(data).toLowerCase();
         var isSeparator:Boolean = type == "separator";
         var nativeMenuItem:NativeMenuItem = new NativeMenuItem("",isSeparator);
         if(!isSeparator)
         {
            nativeMenuItem.enabled = this.dataDescriptor.isEnabled(data);
            nativeMenuItem.checked = type == "check" && Boolean(this.dataDescriptor.isToggled(data));
            nativeMenuItem.data = this.dataDescriptor.getData(data,this._rootModel);
            nativeMenuItem.keyEquivalent = this.itemToKeyEquivalent(data);
            nativeMenuItem.keyEquivalentModifiers = this.itemToKeyEquivalentModifiers(data);
            labelData = this.itemToLabel(data);
            mnemonicIndex = this.itemToMnemonicIndex(data);
            if(mnemonicIndex >= 0)
            {
               nativeMenuItem.label = this.parseLabelToString(labelData);
               nativeMenuItem.mnemonicIndex = mnemonicIndex;
            }
            else
            {
               nativeMenuItem.label = this.parseLabelToString(labelData);
               nativeMenuItem.mnemonicIndex = this.parseLabelToMnemonicIndex(labelData);
            }
            nativeMenuItem.addEventListener(Event.SELECT,this.itemSelectHandler,false,0,true);
            if(Boolean(this.dataDescriptor.isBranch(data,this._rootModel)) && Boolean(this.dataDescriptor.hasChildren(data,this._rootModel)))
            {
               nativeMenuItem.submenu = this.createMenu();
               this.populateMenu(nativeMenuItem.submenu,this.dataDescriptor.getChildren(data,this._rootModel));
            }
         }
         menu.addItem(nativeMenuItem);
      }
      
      public function display(stage:Stage, x:int, y:int) : void
      {
         this.nativeMenu.display(stage,x,y);
      }
      
      protected function itemToKeyEquivalent(data:Object) : String
      {
         if(data == null)
         {
            return "";
         }
         if(this.keyEquivalentFunction != null)
         {
            return this.keyEquivalentFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.keyEquivalentField].length() != 0)
               {
                  data = data[this.keyEquivalentField];
                  return data.toString();
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.keyEquivalentField] != null)
               {
                  data = data[this.keyEquivalentField];
                  return data.toString();
               }
            }
            catch(e:Error)
            {
            }
         }
         return "";
      }
      
      protected function itemToKeyEquivalentModifiers(data:Object) : Array
      {
         if(data == null)
         {
            return [];
         }
         if(this.keyEquivalentModifiersFunction != null)
         {
            return this.keyEquivalentModifiersFunction(data);
         }
         return [];
      }
      
      protected function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.labelField].length() != 0)
               {
                  data = data[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.labelField] != null)
               {
                  data = data[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is String)
         {
            return String(data);
         }
         try
         {
            return data.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      protected function itemToMnemonicIndex(data:Object) : int
      {
         var mnemonicIndex:int = 0;
         if(data == null)
         {
            return -1;
         }
         if(this.mnemonicIndexFunction != null)
         {
            return this.mnemonicIndexFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.mnemonicIndexField].length() != 0)
               {
                  return int(data[this.mnemonicIndexField]);
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.mnemonicIndexField] != null)
               {
                  return int(data[this.mnemonicIndexField]);
               }
            }
            catch(e:Error)
            {
            }
         }
         return -1;
      }
      
      protected function parseLabelToString(data:String) : String
      {
         var str:String = null;
         var singleCharacter:RegExp = new RegExp(MNEMONIC_INDEX_CHARACTER,"g");
         var doubleCharacter:RegExp = new RegExp(MNEMONIC_INDEX_CHARACTER + MNEMONIC_INDEX_CHARACTER,"g");
         var dataWithoutEscapedUnderscores:Array = data.split(doubleCharacter);
         var len:int = int(dataWithoutEscapedUnderscores.length);
         for(var i:int = 0; i < len; i++)
         {
            str = String(dataWithoutEscapedUnderscores[i]);
            dataWithoutEscapedUnderscores[i] = str.replace(singleCharacter,"");
         }
         return dataWithoutEscapedUnderscores.join(MNEMONIC_INDEX_CHARACTER);
      }
      
      protected function parseLabelToMnemonicIndex(data:String) : int
      {
         var str:String = null;
         var index:int = 0;
         var doubleCharacter:RegExp = new RegExp(MNEMONIC_INDEX_CHARACTER + MNEMONIC_INDEX_CHARACTER,"g");
         var dataWithoutEscapedUnderscores:Array = data.split(doubleCharacter);
         var len:int = int(dataWithoutEscapedUnderscores.length);
         var strLengthUpTo:int = 0;
         for(var i:int = 0; i < len; i++)
         {
            str = String(dataWithoutEscapedUnderscores[i]);
            index = str.indexOf(MNEMONIC_INDEX_CHARACTER);
            if(index >= 0)
            {
               return index + strLengthUpTo;
            }
            strLengthUpTo += str.length + MNEMONIC_INDEX_CHARACTER.length;
         }
         return -1;
      }
      
      public function createAutomationIDPart(child:IAutomationObject) : Object
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.createAutomationIDPart(child);
         }
         return null;
      }
      
      public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array) : Object
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.createAutomationIDPartWithRequiredProperties(child,properties);
         }
         return null;
      }
      
      public function resolveAutomationIDPart(criteria:Object) : Array
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.resolveAutomationIDPart(criteria);
         }
         return [];
      }
      
      public function getAutomationChildAt(index:int) : IAutomationObject
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.getAutomationChildAt(index);
         }
         return null;
      }
      
      public function getAutomationChildren() : Array
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.getAutomationChildren();
         }
         return null;
      }
      
      public function replayAutomatableEvent(event:Event) : Boolean
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.replayAutomatableEvent(event);
         }
         return false;
      }
      
      private function itemSelectHandler(event:Event) : void
      {
         var checked:Boolean = false;
         var nativeMenuItem:NativeMenuItem = event.target as NativeMenuItem;
         var type:String = this.dataDescriptor.getType(nativeMenuItem.data).toLowerCase();
         if(type == "check")
         {
            checked = !this.dataDescriptor.isToggled(nativeMenuItem.data);
            nativeMenuItem.checked = checked;
            this.dataDescriptor.setToggled(nativeMenuItem.data,checked);
         }
         var menuEvent:FlexNativeMenuEvent = new FlexNativeMenuEvent(FlexNativeMenuEvent.ITEM_CLICK);
         menuEvent.nativeMenu = nativeMenuItem.menu;
         menuEvent.index = nativeMenuItem.menu.getItemIndex(nativeMenuItem);
         menuEvent.nativeMenuItem = nativeMenuItem;
         menuEvent.label = nativeMenuItem.label;
         menuEvent.item = nativeMenuItem.data;
         dispatchEvent(menuEvent);
      }
      
      private function menuDisplayHandler(event:Event) : void
      {
         var nativeMenu:NativeMenu = event.target as NativeMenu;
         var menuEvent:FlexNativeMenuEvent = new FlexNativeMenuEvent(FlexNativeMenuEvent.MENU_SHOW);
         menuEvent.nativeMenu = nativeMenu;
         dispatchEvent(menuEvent);
      }
      
      private function collectionChangeHandler(ce:CollectionEvent) : void
      {
         if(ce.kind == CollectionEventKind.ADD)
         {
            this.dataProviderChanged = true;
            this.invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.REMOVE)
         {
            this.dataProviderChanged = true;
            this.invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.REFRESH)
         {
            this.dataProviderChanged = true;
            this.dataProvider = this.dataProvider;
            this.invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.RESET)
         {
            this.dataProviderChanged = true;
            this.invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.UPDATE)
         {
            this.dataProviderChanged = true;
            this.invalidateProperties();
         }
      }
   }
}

