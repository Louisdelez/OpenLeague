package mx.controls
{
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
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.Application;
   import mx.core.EventPriority;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexNativeMenuEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.ISystemManager;
   
   [Event(name="itemClick",type="mx.events.FlexNativeMenuEvent")]
   [Event(name="menuShow",type="mx.events.FlexNativeMenuEvent")]
   public class FlexNativeMenu extends EventDispatcher implements ILayoutManagerClient, IFlexContextMenu
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private static var MNEMONIC_INDEX_CHARACTER:String = "_";
      
      private var _labelField:String = "label";
      
      private var _initialized:Boolean = false;
      
      private var _keyEquivalentFunction:Function;
      
      private var keyEquivalentFieldChanged:Boolean = false;
      
      private var _mnemonicIndexFunction:Function;
      
      private var showRootChanged:Boolean = false;
      
      private var _mnemonicIndexField:String = "mnemonicIndex";
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var _hasRoot:Boolean = false;
      
      private var labelFieldChanged:Boolean = false;
      
      private var _keyEquivalentModifiersFunction:Function = keyEquivalentModifiersDefaultFunction;
      
      private var dataProviderChanged:Boolean = false;
      
      private var _nestLevel:int = 1;
      
      private var _processedDescriptors:Boolean = false;
      
      private var _updateCompletePendingFlag:Boolean = false;
      
      private var mnemonicIndexFieldChanged:Boolean = false;
      
      private var _nativeMenu:NativeMenu = new NativeMenu();
      
      private var dataDescriptorChanged:Boolean = false;
      
      private var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      private var _showRoot:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootModel:ICollectionView;
      
      private var _labelFunction:Function;
      
      private var keyEquivalentModifiersFunctionChanged:Boolean = false;
      
      private var _keyEquivalentField:String = "keyEquivalent";
      
      public function FlexNativeMenu()
      {
         super();
         _nativeMenu.addEventListener(Event.DISPLAYING,menuDisplayHandler,false,0,true);
      }
      
      public function get nestLevel() : int
      {
         return _nestLevel;
      }
      
      [Bindable("nativeMenuUpdate")]
      public function get nativeMenu() : NativeMenu
      {
         return _nativeMenu;
      }
      
      public function set nestLevel(value:int) : void
      {
         _nestLevel = value;
         invalidateProperties();
      }
      
      public function get updateCompletePendingFlag() : Boolean
      {
         return _updateCompletePendingFlag;
      }
      
      [Inspectable(category="Data")]
      [Bindable("mnemonicIndexFunctionChanged")]
      public function get mnemonicIndexFunction() : Function
      {
         return _mnemonicIndexFunction;
      }
      
      [Inspectable(category="Data")]
      [Bindable("keyEquivalentFunctionChanged")]
      public function get keyEquivalentFunction() : Function
      {
         return _keyEquivalentFunction;
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
      
      public function validateSize(recursive:Boolean = false) : void
      {
      }
      
      public function set updateCompletePendingFlag(value:Boolean) : void
      {
         _updateCompletePendingFlag = value;
      }
      
      private function clearMenu(menu:NativeMenu) : void
      {
         var numItems:int = int(menu.numItems);
         for(var i:int = 0; i < numItems; i++)
         {
            menu.removeItemAt(0);
         }
      }
      
      public function set mnemonicIndexFunction(value:Function) : void
      {
         if(_mnemonicIndexFunction != value)
         {
            _mnemonicIndexFunction = value;
            mnemonicIndexFieldChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("mnemonicIndexFunctionChanged"));
         }
      }
      
      [Inspectable(category="Data",defaultValue="keyEquivalent")]
      [Bindable("keyEquivalentChanged")]
      public function get keyEquivalentField() : String
      {
         return _keyEquivalentField;
      }
      
      public function set mnemonicIndexField(value:String) : void
      {
         if(_mnemonicIndexField != value)
         {
            _mnemonicIndexField = value;
            mnemonicIndexFieldChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("mnemonicIndexFieldChanged"));
         }
      }
      
      private function itemSelectHandler(event:Event) : void
      {
         var checked:Boolean = false;
         var nativeMenuItem:NativeMenuItem = event.target as NativeMenuItem;
         var type:String = dataDescriptor.getType(nativeMenuItem.data).toLowerCase();
         if(type == "check")
         {
            checked = !dataDescriptor.isToggled(nativeMenuItem.data);
            nativeMenuItem.checked = checked;
            dataDescriptor.setToggled(nativeMenuItem.data,checked);
         }
         var menuEvent:FlexNativeMenuEvent = new FlexNativeMenuEvent(FlexNativeMenuEvent.ITEM_CLICK);
         menuEvent.nativeMenu = nativeMenuItem.menu;
         menuEvent.index = nativeMenuItem.menu.getItemIndex(nativeMenuItem);
         menuEvent.nativeMenuItem = nativeMenuItem;
         menuEvent.label = nativeMenuItem.label;
         menuEvent.item = nativeMenuItem.data;
         dispatchEvent(menuEvent);
      }
      
      [Inspectable(category="Data")]
      [Bindable("keyEquivalentModifiersFunctionChanged")]
      public function get keyEquivalentModifiersFunction() : Function
      {
         return _keyEquivalentModifiersFunction;
      }
      
      public function set keyEquivalentFunction(value:Function) : void
      {
         if(_keyEquivalentFunction != value)
         {
            _keyEquivalentFunction = value;
            keyEquivalentFieldChanged = true;
            invalidateProperties();
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
      
      private function menuDisplayHandler(event:Event) : void
      {
         var nativeMenu:NativeMenu = event.target as NativeMenu;
         var menuEvent:FlexNativeMenuEvent = new FlexNativeMenuEvent(FlexNativeMenuEvent.MENU_SHOW);
         menuEvent.nativeMenu = nativeMenu;
         dispatchEvent(menuEvent);
      }
      
      private function populateMenu(menu:NativeMenu, collection:ICollectionView) : NativeMenu
      {
         var i:int;
         var collectionLength:int = int(collection.length);
         for(i = 0; i < collectionLength; i++)
         {
            try
            {
               insertMenuItem(menu,i,collection[i]);
            }
            catch(e:ItemPendingError)
            {
            }
         }
         return menu;
      }
      
      public function set processedDescriptors(value:Boolean) : void
      {
         _processedDescriptors = value;
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         _dataDescriptor = value;
         dataDescriptorChanged = true;
      }
      
      private function createMenu() : NativeMenu
      {
         var menu:NativeMenu = new NativeMenu();
         menu.addEventListener(Event.DISPLAYING,menuDisplayHandler,false,0,true);
         return menu;
      }
      
      private function collectionChangeHandler(ce:CollectionEvent) : void
      {
         if(ce.kind == CollectionEventKind.ADD)
         {
            dataProviderChanged = true;
            invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.REMOVE)
         {
            dataProviderChanged = true;
            invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.REFRESH)
         {
            dataProviderChanged = true;
            dataProvider = dataProvider;
            invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.RESET)
         {
            dataProviderChanged = true;
            invalidateProperties();
         }
         else if(ce.kind == CollectionEventKind.UPDATE)
         {
            dataProviderChanged = true;
            invalidateProperties();
         }
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(mx_internal::_rootModel))
         {
            mx_internal::_rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
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
            _hasRoot = true;
            xl = new XMLList();
            xl += value;
            mx_internal::_rootModel = new XMLListCollection(xl);
         }
         else if(value is ICollectionView)
         {
            mx_internal::_rootModel = ICollectionView(value);
            if(mx_internal::_rootModel.length == 1)
            {
               _hasRoot = true;
            }
         }
         else if(value is Array)
         {
            mx_internal::_rootModel = new ArrayCollection(value as Array);
         }
         else if(value is Object)
         {
            _hasRoot = true;
            tmp = [];
            tmp.push(value);
            mx_internal::_rootModel = new ArrayCollection(tmp);
         }
         else
         {
            mx_internal::_rootModel = new ArrayCollection();
         }
         mx_internal::_rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         dataProviderChanged = true;
         invalidateProperties();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         collectionChangeHandler(event);
         dispatchEvent(event);
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="false")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      public function validateDisplayList() : void
      {
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
      
      public function set keyEquivalentModifiersFunction(value:Function) : void
      {
         if(_keyEquivalentModifiersFunction != value)
         {
            _keyEquivalentModifiersFunction = value;
            keyEquivalentModifiersFunctionChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("keyEquivalentModifiersFunctionChanged"));
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      public function set keyEquivalentField(value:String) : void
      {
         if(_keyEquivalentField != value)
         {
            _keyEquivalentField = value;
            keyEquivalentFieldChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("keyEquivalentFieldChanged"));
         }
      }
      
      protected function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(labelFunction != null)
         {
            return labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[labelField].length() != 0)
               {
                  data = data[labelField];
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
               if(data[labelField] != null)
               {
                  data = data[labelField];
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
      
      public function set initialized(value:Boolean) : void
      {
         _initialized = value;
      }
      
      [Inspectable(category="Data",defaultValue="mnemonicIndex")]
      [Bindable("mnemonicIndexChanged")]
      public function get mnemonicIndexField() : String
      {
         return _mnemonicIndexField;
      }
      
      public function get processedDescriptors() : Boolean
      {
         return _processedDescriptors;
      }
      
      [Inspectable(category="Data")]
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(mx_internal::_rootModel))
         {
            return mx_internal::_rootModel;
         }
         return null;
      }
      
      public function display(stage:Stage, x:int, y:int) : void
      {
         nativeMenu.display(stage,x,y);
      }
      
      protected function commitProperties() : void
      {
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged || labelFieldChanged || dataDescriptorChanged)
         {
            dataProviderChanged = false;
            showRootChanged = false;
            labelFieldChanged = false;
            dataDescriptorChanged = false;
            if(Boolean(mx_internal::_rootModel) && Boolean(!_showRoot) && _hasRoot)
            {
               rootItem = mx_internal::_rootModel.createCursor().current;
               if(rootItem != null && Boolean(_dataDescriptor.isBranch(rootItem,mx_internal::_rootModel)) && Boolean(_dataDescriptor.hasChildren(rootItem,mx_internal::_rootModel)))
               {
                  tmpCollection = _dataDescriptor.getChildren(rootItem,mx_internal::_rootModel);
               }
            }
            clearMenu(_nativeMenu);
            if(Boolean(mx_internal::_rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = mx_internal::_rootModel;
               }
               tmpCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
               populateMenu(_nativeMenu,tmpCollection);
            }
            dispatchEvent(new Event("nativeMenuChange"));
         }
      }
      
      public function unsetContextMenu(component:InteractiveObject) : void
      {
         component.contextMenu = null;
      }
      
      public function invalidateProperties() : void
      {
         var myTimer:Timer = null;
         if(!invalidatePropertiesFlag && nestLevel > 0)
         {
            invalidatePropertiesFlag = true;
            if(Boolean(UIComponentGlobals.mx_internal::layoutManager))
            {
               UIComponentGlobals.mx_internal::layoutManager.invalidateProperties(this);
            }
            else
            {
               myTimer = new Timer(100,1);
               myTimer.addEventListener(TimerEvent.TIMER,validatePropertiesTimerHandler);
               myTimer.start();
            }
         }
      }
      
      public function set labelField(value:String) : void
      {
         if(_labelField != value)
         {
            _labelField = value;
            labelFieldChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      public function get initialized() : Boolean
      {
         return _initialized;
      }
      
      public function validatePropertiesTimerHandler(event:TimerEvent) : void
      {
         validateProperties();
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(_labelFunction != value)
         {
            _labelFunction = value;
            labelFieldChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("labelFunctionChanged"));
         }
      }
      
      protected function itemToKeyEquivalentModifiers(data:Object) : Array
      {
         if(data == null)
         {
            return [];
         }
         if(keyEquivalentModifiersFunction != null)
         {
            return keyEquivalentModifiersFunction(data);
         }
         return [];
      }
      
      protected function itemToKeyEquivalent(data:Object) : String
      {
         if(data == null)
         {
            return "";
         }
         if(keyEquivalentFunction != null)
         {
            return keyEquivalentFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[keyEquivalentField].length() != 0)
               {
                  data = data[keyEquivalentField];
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
               if(data[keyEquivalentField] != null)
               {
                  data = data[keyEquivalentField];
                  return data.toString();
               }
            }
            catch(e:Error)
            {
            }
         }
         return "";
      }
      
      public function validateNow() : void
      {
         if(invalidatePropertiesFlag)
         {
            validateProperties();
         }
      }
      
      private function insertMenuItem(menu:NativeMenu, index:int, data:Object) : void
      {
         var labelData:String = null;
         var mnemonicIndex:int = 0;
         if(dataProviderChanged)
         {
            commitProperties();
            return;
         }
         var type:String = dataDescriptor.getType(data).toLowerCase();
         var isSeparator:Boolean = type == "separator";
         var nativeMenuItem:NativeMenuItem = new NativeMenuItem("",isSeparator);
         if(!isSeparator)
         {
            nativeMenuItem.enabled = dataDescriptor.isEnabled(data);
            nativeMenuItem.checked = type == "check" && Boolean(dataDescriptor.isToggled(data));
            nativeMenuItem.data = dataDescriptor.getData(data,mx_internal::_rootModel);
            nativeMenuItem.keyEquivalent = itemToKeyEquivalent(data);
            nativeMenuItem.keyEquivalentModifiers = itemToKeyEquivalentModifiers(data);
            labelData = itemToLabel(data);
            mnemonicIndex = itemToMnemonicIndex(data);
            if(mnemonicIndex >= 0)
            {
               nativeMenuItem.label = parseLabelToString(labelData);
               nativeMenuItem.mnemonicIndex = mnemonicIndex;
            }
            else
            {
               nativeMenuItem.label = parseLabelToString(labelData);
               nativeMenuItem.mnemonicIndex = parseLabelToMnemonicIndex(labelData);
            }
            nativeMenuItem.addEventListener(Event.SELECT,itemSelectHandler,false,0,true);
            if(Boolean(dataDescriptor.isBranch(data,mx_internal::_rootModel)) && Boolean(dataDescriptor.hasChildren(data,mx_internal::_rootModel)))
            {
               nativeMenuItem.submenu = createMenu();
               populateMenu(nativeMenuItem.submenu,dataDescriptor.getChildren(data,mx_internal::_rootModel));
            }
         }
         menu.addItem(nativeMenuItem);
      }
      
      public function setContextMenu(component:InteractiveObject) : void
      {
         var systemManager:ISystemManager = null;
         component.contextMenu = nativeMenu;
         if(component is Application)
         {
            systemManager = Application(component).systemManager;
            if(systemManager is InteractiveObject)
            {
               InteractiveObject(systemManager).contextMenu = nativeMenu;
            }
         }
      }
      
      protected function itemToMnemonicIndex(data:Object) : int
      {
         var mnemonicIndex:int = 0;
         if(data == null)
         {
            return -1;
         }
         if(mnemonicIndexFunction != null)
         {
            return mnemonicIndexFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[mnemonicIndexField].length() != 0)
               {
                  mnemonicIndex = int(data[mnemonicIndexField]);
                  return mnemonicIndex;
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
               if(data[mnemonicIndexField] != null)
               {
                  mnemonicIndex = int(data[mnemonicIndexField]);
                  return mnemonicIndex;
               }
            }
            catch(e:Error)
            {
            }
         }
         return -1;
      }
      
      public function validateProperties() : void
      {
         if(invalidatePropertiesFlag)
         {
            commitProperties();
            invalidatePropertiesFlag = false;
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            showRootChanged = true;
            _showRoot = value;
            invalidateProperties();
         }
      }
   }
}

