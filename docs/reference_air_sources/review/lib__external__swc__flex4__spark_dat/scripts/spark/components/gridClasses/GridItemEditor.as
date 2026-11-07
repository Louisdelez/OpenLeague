package spark.components.gridClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.describeType;
   import mx.collections.ICollectionView;
   import mx.collections.ISort;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.validators.IValidatorListener;
   import spark.components.DataGrid;
   import spark.components.Group;
   
   public class GridItemEditor extends Group implements IGridItemEditor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _column:GridColumn;
      
      private var _data:Object = null;
      
      private var _imeMode:String = null;
      
      private var _itemRenderer:IGridItemRenderer;
      
      private var _rowIndex:int;
      
      private var _value:Object;
      
      public function GridItemEditor()
      {
         super();
      }
      
      public function get column() : GridColumn
      {
         return this._column;
      }
      
      public function set column(value:GridColumn) : void
      {
         this._column = value;
      }
      
      public function get columnIndex() : int
      {
         return this.column.columnIndex;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(Boolean(this._data) && Boolean(this.column.dataField))
         {
            this.value = this._data[this.column.dataField];
         }
      }
      
      public function get dataGrid() : DataGrid
      {
         return DataGrid(owner);
      }
      
      public function get enableIME() : Boolean
      {
         return true;
      }
      
      [Inspectable(environment="none")]
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         var child:IIMESupport = null;
         this._imeMode = value;
         var n:int = numElements;
         for(var i:int = 0; i < n; i++)
         {
            child = getElementAt(i) as IIMESupport;
            if(Boolean(child))
            {
               child.imeMode = value;
            }
         }
      }
      
      public function get itemRenderer() : IGridItemRenderer
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IGridItemRenderer) : void
      {
         this._itemRenderer = value;
      }
      
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(value:int) : void
      {
         this._rowIndex = value;
      }
      
      [Bindable("valueChanged")]
      public function get value() : Object
      {
         return this._value;
      }
      
      public function set value(newValue:Object) : void
      {
         if(newValue != this.value)
         {
            this._value = newValue;
            if(hasEventListener("valueChanged"))
            {
               dispatchEvent(new Event("valueChanged"));
            }
         }
      }
      
      public function discard() : void
      {
         this.clearErrorStringFromContainer(this);
         removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpDownMoveHandler);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseUpDownMoveHandler);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      public function prepare() : void
      {
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpDownMoveHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseUpDownMoveHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      public function save() : Boolean
      {
         var variable:XML = null;
         var strNewData:String = null;
         var sort:ISort = null;
         var oldData:Object = null;
         var dataProvider:ICollectionView = null;
         if(!this.validate())
         {
            return false;
         }
         var newData:Object = this.value;
         var property:String = this.column.dataField;
         var data:Object = this.data;
         var typeInfo:String = "";
         for each(variable in describeType(data).variable)
         {
            if(property == variable.@name.toString())
            {
               typeInfo = variable.@type.toString();
               break;
            }
         }
         if(typeInfo == "String")
         {
            if(!(newData is String))
            {
               newData = newData.toString();
            }
         }
         else if(typeInfo == "uint")
         {
            if(!(newData is uint))
            {
               newData = uint(newData);
            }
         }
         else if(typeInfo == "int")
         {
            if(!(newData is int))
            {
               newData = int(newData);
            }
         }
         else if(typeInfo == "Number")
         {
            if(!(newData is Number))
            {
               newData = Number(newData);
            }
         }
         else if(typeInfo == "Boolean")
         {
            if(!(newData is Boolean))
            {
               strNewData = newData.toString();
               if(Boolean(strNewData))
               {
                  newData = strNewData.toLowerCase() == "true" ? true : false;
               }
            }
         }
         if(Boolean(property) && data[property] !== newData)
         {
            sort = null;
            if(this.dataGrid.dataProvider is ICollectionView)
            {
               dataProvider = ICollectionView(this.dataGrid.dataProvider);
               if(Boolean(dataProvider.sort))
               {
                  sort = dataProvider.sort;
                  dataProvider.sort = null;
               }
            }
            oldData = data[property];
            data[property] = newData;
            this.dataGrid.dataProvider.itemUpdated(data,property,oldData,newData);
            if(Boolean(sort))
            {
               ICollectionView(this.dataGrid.dataProvider).sort = sort;
            }
         }
         return true;
      }
      
      protected function validate() : Boolean
      {
         return this.validateContainer(this);
      }
      
      private function validateContainer(container:IVisualElementContainer) : Boolean
      {
         var child:IVisualElement = null;
         if(container is IValidatorListener && Boolean(IValidatorListener(container).errorString))
         {
            return false;
         }
         var n:int = int(container.numElements);
         for(var i:int = 0; i < n; i++)
         {
            child = container.getElementAt(i);
            if(child is IValidatorListener && Boolean(IValidatorListener(child).errorString))
            {
               return false;
            }
            if(child is IVisualElementContainer && !this.validateContainer(IVisualElementContainer(child)))
            {
               return false;
            }
         }
         return true;
      }
      
      private function clearErrorStringFromContainer(container:IVisualElementContainer) : void
      {
         var child:IVisualElement = null;
         if(container is IValidatorListener && Boolean(IValidatorListener(container).errorString))
         {
            this.clearErrorString(IValidatorListener(container));
         }
         var n:int = int(container.numElements);
         for(var i:int = 0; i < n; i++)
         {
            child = container.getElementAt(i);
            if(child is IValidatorListener && Boolean(IValidatorListener(child).errorString))
            {
               this.clearErrorString(IValidatorListener(child));
            }
            if(child is IVisualElementContainer)
            {
               this.clearErrorStringFromContainer(IVisualElementContainer(child));
            }
         }
      }
      
      private function clearErrorString(validatorListener:IValidatorListener) : void
      {
         validatorListener.errorString = "";
         if(validatorListener is IInvalidating)
         {
            IInvalidating(validatorListener).validateNow();
         }
      }
      
      private function mouseUpDownMoveHandler(event:MouseEvent) : void
      {
         if(event.cancelable)
         {
            event.preventDefault();
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = this.dataGrid.parent.globalToLocal(new Point(event.stageX,event.stageY));
         event.localX = pt.x;
         event.localY = pt.y;
         this.dataGrid.parent.dispatchEvent(event);
         event.stopPropagation();
      }
   }
}

