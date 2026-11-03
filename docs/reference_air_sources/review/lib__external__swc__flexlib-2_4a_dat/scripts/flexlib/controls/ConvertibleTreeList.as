package flexlib.controls
{
   import mx.collections.XMLListCollection;
   import mx.containers.Canvas;
   import mx.containers.ViewStack;
   import mx.controls.List;
   import mx.controls.Tree;
   import mx.core.ScrollPolicy;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   
   [Event(name="change",type="mx.events.ListEvent")]
   public class ConvertibleTreeList extends Canvas
   {
      
      public static const TREE:String = "tree";
      
      public static const FULL_LIST:String = "list";
      
      public static const ICON_LIST:String = "icon";
      
      public static const TEXT_LIST:String = "text";
      
      private var _allowMultipleSelection:Boolean = false;
      
      [Bindable]
      private var _1684178472_listDataProvider:Object;
      
      private var _tree:Tree;
      
      [Bindable]
      private var _248366370_showRoot:Boolean = true;
      
      private var _list:List;
      
      private var _listField:String = "showInList";
      
      [Bindable]
      private var _2098511064_treeDataProvider:Object;
      
      [Bindable]
      private var _1392202370_iconField:String;
      
      private var _mode:String = ConvertibleTreeList.TREE;
      
      [Bindable]
      private var _584597499_labelField:String;
      
      private var viewstack:ViewStack;
      
      public function ConvertibleTreeList()
      {
         super();
      }
      
      public function get iconField() : String
      {
         return _iconField;
      }
      
      [Bindable(event="propertyChange")]
      private function get _labelField() : String
      {
         return this._584597499_labelField;
      }
      
      public function set iconField(value:String) : void
      {
         _iconField = value;
      }
      
      private function set _labelField(value:String) : void
      {
         var oldValue:Object = null;
         oldValue = this._584597499_labelField;
         if(oldValue !== value)
         {
            this._584597499_labelField = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_labelField",oldValue,value));
         }
      }
      
      public function get selectedItem() : Object
      {
         if(this._mode == ConvertibleTreeList.TREE)
         {
            return tree.selectedItem;
         }
         return list.selectedItem;
      }
      
      public function get list() : List
      {
         return _list;
      }
      
      public function set selectedItem(value:Object) : void
      {
         if(this._mode == ConvertibleTreeList.TREE)
         {
            tree.selectedItem = value;
         }
         else
         {
            list.selectedItem = value;
         }
      }
      
      private function changeListener(event:ListEvent) : void
      {
         if(event.target == _list)
         {
            _tree.selectedItems = _list.selectedItems;
         }
         else if(event.target == tree)
         {
            _list.selectedItems = _tree.selectedItems;
         }
         redispatchEvent(event);
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
      }
      
      [Bindable(event="propertyChange")]
      private function get _treeDataProvider() : Object
      {
         return this._2098511064_treeDataProvider;
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return _allowMultipleSelection;
      }
      
      private function set _iconField(value:String) : void
      {
         var oldValue:Object = null;
         oldValue = this._1392202370_iconField;
         if(oldValue !== value)
         {
            this._1392202370_iconField = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_iconField",oldValue,value));
         }
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      private function set _showRoot(value:Boolean) : void
      {
         var oldValue:Object = null;
         oldValue = this._248366370_showRoot;
         if(oldValue !== value)
         {
            this._248366370_showRoot = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_showRoot",oldValue,value));
         }
      }
      
      public function get mode() : String
      {
         return _mode;
      }
      
      private function set _treeDataProvider(value:Object) : void
      {
         var oldValue:Object = null;
         oldValue = this._2098511064_treeDataProvider;
         if(oldValue !== value)
         {
            this._2098511064_treeDataProvider = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_treeDataProvider",oldValue,value));
         }
      }
      
      public function get selectedItems() : Array
      {
         if(this._mode == ConvertibleTreeList.TREE)
         {
            return tree.selectedItems;
         }
         return list.selectedItems;
      }
      
      [Bindable(event="propertyChange")]
      private function get _listDataProvider() : Object
      {
         return this._1684178472_listDataProvider;
      }
      
      public function set listField(value:String) : void
      {
         _listField = value;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         _allowMultipleSelection = value;
         if(Boolean(list))
         {
            list.allowMultipleSelection = value;
         }
         if(Boolean(tree))
         {
            tree.allowMultipleSelection = value;
         }
      }
      
      public function get labelField() : String
      {
         return _labelField;
      }
      
      private function flattenXMLList(input:XMLList) : XMLListCollection
      {
         var flat:XMLListCollection = null;
         var n:int = 0;
         var i:int = 0;
         var item:Object = null;
         var others:XMLListCollection = null;
         var j:int = 0;
         var loneItem:XML = null;
         flat = new XMLListCollection();
         n = input.length();
         for(i = 0; i < n; i++)
         {
            item = input[i];
            if(item is XML && (item as XML).children().length() > 0)
            {
               if((item as XML).attribute(_listField).toString() == "true")
               {
                  loneItem = (item as XML).copy();
                  loneItem.setChildren(undefined);
                  flat.addItem(loneItem);
               }
               others = flattenXMLList(item.children());
               for(j = 0; j < others.length; j++)
               {
                  if((others[j] as XML).attribute(_listField).toString() == "true")
                  {
                     flat.addItem((others[j] as XML).copy());
                  }
               }
            }
            else if(item is XML)
            {
               flat.addItem((item as XML).copy());
            }
         }
         return flat;
      }
      
      [Bindable(event="propertyChange")]
      private function get _iconField() : String
      {
         return this._1392202370_iconField;
      }
      
      private function redispatchEvent(event:ListEvent) : void
      {
         this.dispatchEvent(event);
      }
      
      [Bindable(event="propertyChange")]
      private function get _showRoot() : Boolean
      {
         return this._248366370_showRoot;
      }
      
      public function get listField() : String
      {
         return _listField;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         var different:Boolean = false;
         different = value != _showRoot;
         _showRoot = value;
         if(different)
         {
            dataProvider = _treeDataProvider;
         }
      }
      
      override protected function createChildren() : void
      {
         var canvas1:Canvas = null;
         var canvas2:Canvas = null;
         super.createChildren();
         _tree = new Tree();
         _list = new List();
         viewstack = new ViewStack();
         viewstack.setStyle("borderStyle","none");
         _tree.setStyle("borderStyle","none");
         _list.setStyle("borderStyle","none");
         canvas1 = new Canvas();
         canvas1.addChild(_tree);
         _tree.percentHeight = _tree.percentWidth = 100;
         canvas2 = new Canvas();
         canvas2.addChild(_list);
         canvas1.horizontalScrollPolicy = canvas2.horizontalScrollPolicy = ScrollPolicy.OFF;
         _list.percentHeight = _list.percentWidth = 100;
         canvas1.percentHeight = canvas1.percentWidth = 100;
         canvas2.percentHeight = canvas2.percentWidth = 100;
         viewstack.addChild(canvas2);
         viewstack.addChild(canvas1);
         addListEventListeners(_tree);
         addListEventListeners(_list);
         _tree.dataProvider = _treeDataProvider;
         _list.dataProvider = _listDataProvider;
         _tree.iconField = _list.iconField = _iconField;
         _tree.labelField = _list.labelField = _labelField;
         _tree.showRoot = _showRoot;
         _tree.allowMultipleSelection = _list.allowMultipleSelection = _allowMultipleSelection;
         modeChanged();
         addChild(viewstack);
      }
      
      public function get selectedIndex() : Object
      {
         if(this._mode == ConvertibleTreeList.TREE)
         {
            return tree.selectedIndex;
         }
         return list.selectedIndex;
      }
      
      public function set mode(value:String) : void
      {
         _mode = value;
         if(Boolean(viewstack) && Boolean(tree) && Boolean(list))
         {
            modeChanged();
         }
      }
      
      public function set dataProvider(value:Object) : void
      {
         var listDP:XMLListCollection = null;
         var children:XMLList = null;
         this._treeDataProvider = value;
         if(_showRoot)
         {
            listDP = flattenXMLList(new XMLList(value));
         }
         else
         {
            children = new XMLList(value).children();
            listDP = flattenXMLList(new XMLList(value).children());
         }
         this._listDataProvider = listDP;
         if(Boolean(_list))
         {
            list.dataProvider = _listDataProvider;
         }
         if(Boolean(_tree))
         {
            tree.dataProvider = _treeDataProvider;
         }
      }
      
      private function modeChanged() : void
      {
         if(_mode == ConvertibleTreeList.FULL_LIST || _mode == ConvertibleTreeList.ICON_LIST || "" + _mode == ConvertibleTreeList.TEXT_LIST)
         {
            viewstack.selectedChild = _list.parent as Canvas;
         }
         else if(_mode == ConvertibleTreeList.TREE)
         {
            viewstack.selectedChild = _tree.parent as Canvas;
         }
         if(_mode == ConvertibleTreeList.FULL_LIST || _mode == ConvertibleTreeList.TEXT_LIST)
         {
            list.labelField = _labelField;
         }
         else
         {
            list.labelField = undefined;
         }
         if(_mode == ConvertibleTreeList.FULL_LIST || _mode == ConvertibleTreeList.ICON_LIST)
         {
            list.iconField = _iconField;
         }
         else
         {
            list.iconField = undefined;
         }
      }
      
      public function get tree() : Tree
      {
         return _tree;
      }
      
      private function set _listDataProvider(value:Object) : void
      {
         var oldValue:Object = null;
         oldValue = this._1684178472_listDataProvider;
         if(oldValue !== value)
         {
            this._1684178472_listDataProvider = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_listDataProvider",oldValue,value));
         }
      }
      
      public function get dataProvider() : Object
      {
         return this._treeDataProvider;
      }
      
      public function set selectedItems(value:Array) : void
      {
         if(this._mode == ConvertibleTreeList.TREE)
         {
            tree.selectedItems = value;
         }
         else
         {
            list.selectedItems = value;
         }
      }
      
      private function addListEventListeners(obj:*) : void
      {
         obj.addEventListener(ListEvent.CHANGE,changeListener);
         obj.addEventListener(ListEvent.ITEM_CLICK,redispatchEvent);
         obj.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,redispatchEvent);
         obj.addEventListener(ListEvent.ITEM_FOCUS_IN,redispatchEvent);
         obj.addEventListener(ListEvent.ITEM_FOCUS_OUT,redispatchEvent);
         obj.addEventListener(ListEvent.ITEM_ROLL_OUT,redispatchEvent);
         obj.addEventListener(ListEvent.ITEM_ROLL_OVER,redispatchEvent);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         viewstack.setActualSize(unscaledWidth,unscaledHeight);
      }
   }
}

