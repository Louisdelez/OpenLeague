package mx.controls.olapDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import mx.controls.OLAPDataGrid;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.Container;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IUIComponent;
   import mx.events.FlexEvent;
   import mx.olap.IOLAPElement;
   import mx.styles.ISimpleStyleClient;
   
   public class OLAPDataGridHeaderRenderer extends Container implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      private var dataProviderChanged:Boolean = false;
      
      private var _listData:AdvancedDataGridListData;
      
      private var _data:Object;
      
      private var _dataProvider:Array;
      
      private var _factories:Array;
      
      private var factoriesChanged:Boolean = false;
      
      private var listOwner:OLAPDataGrid;
      
      public function OLAPDataGridHeaderRenderer()
      {
         super();
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = "off";
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var factory:IFactory = null;
         var r:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         super.commitProperties();
         if((Boolean(factoriesChanged || dataProviderChanged)) && Boolean(factories) && Boolean(dataProvider))
         {
            factoriesChanged = dataProviderChanged = false;
            while(Boolean(this.numChildren))
            {
               this.removeChildAt(0);
            }
            for(i = 0; i < factories.length; i++)
            {
               factory = factories[i];
               r = factory.newInstance();
               if(r is IDropInListItemRenderer)
               {
                  if(data is AdvancedDataGridColumn)
                  {
                     c = AdvancedDataGridColumn(data);
                  }
                  else
                  {
                     c = null;
                  }
                  IDropInListItemRenderer(r).listData = makeListData(this.dataProvider[i],_listData.uid,_listData.rowIndex,_listData.columnIndex,c);
               }
               r.data = this.data;
               this.addChild(DisplayObject(r));
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var w:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var startx:Number = 0;
         var g:Graphics = this.graphics;
         g.clear();
         var color:uint = uint(getStyle("verticalGridLineColor"));
         g.lineStyle(1,color,100);
         for(var i:int = 0; i < factories.length; i++)
         {
            child = IUIComponent(this.getChildAt(i));
            child.move(startx,0);
            w = Number(child.getExplicitOrMeasuredWidth());
            child.setActualSize(w,child.getExplicitOrMeasuredHeight());
            startx += w;
            g.moveTo(startx,-5);
            g.lineTo(startx,unscaledHeight);
         }
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = AdvancedDataGridListData(value);
         invalidateProperties();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      private function checkIfChanged(a:Array, b:Array) : Boolean
      {
         var i:int = 0;
         var mismatch:Boolean = false;
         if(!a)
         {
            mismatch = true;
         }
         else if(Boolean(b) && Boolean(b.length))
         {
            if(b.length != a.length)
            {
               mismatch = true;
            }
            else
            {
               i = 0;
               while(i < b.length && i < a.length)
               {
                  if(a[i] != b[i])
                  {
                     mismatch = true;
                  }
                  i++;
               }
            }
         }
         return mismatch;
      }
      
      override protected function measure() : void
      {
         var child:IUIComponent = null;
         super.measure();
         var w:Number = 0;
         var h:Number = 0;
         for(var i:int = 0; i < factories.length; i++)
         {
            child = IUIComponent(this.getChildAt(i));
            h = Math.max(h,child.getExplicitOrMeasuredHeight());
            w += child.getExplicitOrMeasuredWidth() + 5;
         }
         if(!isNaN(explicitWidth))
         {
            w = Number(explicitWidth);
         }
         measuredWidth = w;
         measuredHeight = h;
      }
      
      public function set factories(value:Array) : void
      {
         if(checkIfChanged(_factories,value))
         {
            _factories = value;
            factoriesChanged = true;
            invalidateProperties();
         }
      }
      
      public function get factories() : Array
      {
         return _factories;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
         super.verticalScrollPolicy = "off";
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      [Bindable("dataChange")]
      override public function get data() : Object
      {
         return _data;
      }
      
      public function set dataProvider(value:Array) : void
      {
         if(checkIfChanged(_dataProvider,value))
         {
            _dataProvider = value;
            dataProviderChanged = true;
            invalidateProperties();
         }
      }
      
      public function get dataProvider() : Array
      {
         return _dataProvider;
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:AdvancedDataGridColumn) : BaseListData
      {
         var text:String = "";
         if(data is IOLAPElement)
         {
            text = data.name;
         }
         return new AdvancedDataGridListData(text,Boolean(column) ? column.dataField : "",columnNum,uid,_listData.owner,rowNum);
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         var i:int = 0;
         var child:DisplayObject = null;
         super.setStyle(styleProp,newValue);
         if(styleProp == "axisHeaderStyleName")
         {
            for(i = 0; i < this.numChildren; i++)
            {
               child = DisplayObject(this.getChildAt(i));
               if(child is ISimpleStyleClient)
               {
                  ISimpleStyleClient(child).styleName = newValue;
               }
            }
         }
      }
   }
}

