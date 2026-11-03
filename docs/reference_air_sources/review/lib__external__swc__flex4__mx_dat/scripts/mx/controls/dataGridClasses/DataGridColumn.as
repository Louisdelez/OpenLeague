package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import mx.controls.TextInput;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.ContextualClassFactory;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.Singleton;
   import mx.styles.CSSStyleDeclaration;
   import mx.utils.StringUtil;
   
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   public class DataGridColumn extends CSSStyleDeclaration implements IIMESupport
   {
      
      private static var noEmbeddedFonts:Boolean;
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      private static var _defaultItemEditorFactory:IFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var owner:DataGridBase;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedHeaderRenderer:IListItemRenderer;
      
      private var oldEmbeddedFontContext:IFlexModuleFactory = null;
      
      private var oldHeaderEmbeddedFontContext:IFlexModuleFactory = null;
      
      protected var hasComplexFieldName:Boolean = false;
      
      protected var complexFieldNameComponents:Array;
      
      public var sortDescending:Boolean = false;
      
      private var _itemRenderer:IFactory;
      
      private var _contextItemRenderer:IFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var colNum:Number;
      
      private var _dataField:String;
      
      private var _dataTipField:String;
      
      private var _dataTipFunction:Function;
      
      [Inspectable(category="General")]
      public var draggable:Boolean = true;
      
      private var _editable:Boolean = true;
      
      [Inspectable(category="General")]
      public var itemEditor:IFactory = defaultItemEditorFactory;
      
      [Inspectable(category="General")]
      public var editorDataField:String = "text";
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorHeightOffset:Number = 0;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorWidthOffset:Number = 0;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorXOffset:Number = 0;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorYOffset:Number = 0;
      
      [Inspectable(category="General",defaultValue="false")]
      public var editorUsesEnterKey:Boolean = false;
      
      private var _headerRenderer:IFactory;
      
      private var _contextHeaderRenderer:IFactory;
      
      private var _headerText:String;
      
      private var _headerWordWrap:*;
      
      private var _imeMode:String;
      
      [Inspectable(category="General",defaultValue="false")]
      public var rendererIsEditor:Boolean = false;
      
      private var _labelFunction:Function;
      
      private var _minWidth:Number = 20;
      
      private var _nullItemRenderer:IFactory;
      
      private var _contextNullItemRenderer:IFactory;
      
      [Inspectable(category="General")]
      public var resizable:Boolean = true;
      
      private var _showDataTips:*;
      
      [Inspectable(category="General")]
      public var sortable:Boolean = true;
      
      private var _sortCompareFunction:Function;
      
      private var _visible:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var newlyVisible:Boolean = false;
      
      private var _width:Number = 100;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var preferredWidth:Number = 100;
      
      private var _wordWrap:*;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var measuringObjects:Dictionary;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var freeItemRenderersByFactory:Dictionary;
      
      public function DataGridColumn(columnName:String = null)
      {
         super();
         if(Boolean(columnName))
         {
            this.dataField = columnName;
            this.headerText = columnName;
         }
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry && !noEmbeddedFonts)
         {
            try
            {
               _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            }
            catch(e:Error)
            {
               noEmbeddedFonts = true;
            }
         }
         return _embeddedFontRegistry;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function get defaultItemEditorFactory() : IFactory
      {
         if(!_defaultItemEditorFactory)
         {
            _defaultItemEditorFactory = new ClassFactory(TextInput);
         }
         return _defaultItemEditorFactory;
      }
      
      [Inspectable(category="Other")]
      [Bindable("itemRendererChanged")]
      public function get itemRenderer() : IFactory
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         this._itemRenderer = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
            this.owner.columnRendererChanged(this);
            this._contextItemRenderer = null;
         }
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get dataField() : String
      {
         return this._dataField;
      }
      
      public function set dataField(value:String) : void
      {
         this._dataField = value;
         if(value.indexOf(".") != -1)
         {
            this.hasComplexFieldName = true;
            this.complexFieldNameComponents = value.split(".");
            if(this._sortCompareFunction == null)
            {
               this._sortCompareFunction = this.complexColumnSortCompare;
            }
         }
         else
         {
            this.hasComplexFieldName = false;
         }
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
      }
      
      [Inspectable(category="Advanced",defaultValue="label")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return this._dataTipField;
      }
      
      public function set dataTipField(value:String) : void
      {
         this._dataTipField = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
         dispatchEvent(new Event("dataTipChanged"));
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return this._dataTipFunction;
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         this._dataTipFunction = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="General")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
      }
      
      public function get enableIME() : Boolean
      {
         return false;
      }
      
      [Inspectable(category="Other")]
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return this._headerRenderer;
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         this._headerRenderer = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
            this.owner.columnRendererChanged(this);
            this._contextHeaderRenderer = null;
         }
         dispatchEvent(new Event("headerRendererChanged"));
      }
      
      [Inspectable(category="General")]
      [Bindable("headerTextChanged")]
      public function get headerText() : String
      {
         return this._headerText != null ? this._headerText : this.dataField;
      }
      
      public function set headerText(value:String) : void
      {
         this._headerText = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
         dispatchEvent(new Event("headerTextChanged"));
      }
      
      [Inspectable(category="Advanced")]
      public function get headerWordWrap() : *
      {
         return this._headerWordWrap;
      }
      
      public function set headerWordWrap(value:*) : void
      {
         this._headerWordWrap = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
      }
      
      [Inspectable(category="Other")]
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Inspectable(category="Other")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         this._labelFunction = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="General",defaultValue="100")]
      [Bindable("minWidthChanged")]
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(value:Number) : void
      {
         this._minWidth = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
         if(this._width < value)
         {
            this._width = value;
         }
         dispatchEvent(new Event("minWidthChanged"));
      }
      
      [Inspectable(category="Other")]
      [Bindable("nullItemRendererChanged")]
      public function get nullItemRenderer() : IFactory
      {
         return this._nullItemRenderer;
      }
      
      public function set nullItemRenderer(value:IFactory) : void
      {
         this._nullItemRenderer = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
            this.owner.columnRendererChanged(this);
            this._contextNullItemRenderer = null;
         }
         dispatchEvent(new Event("nullItemRendererChanged"));
      }
      
      [Inspectable(category="Advanced")]
      public function get showDataTips() : *
      {
         return this._showDataTips;
      }
      
      public function set showDataTips(value:*) : void
      {
         this._showDataTips = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("sortCompareFunctionChanged")]
      public function get sortCompareFunction() : Function
      {
         return this._sortCompareFunction;
      }
      
      public function set sortCompareFunction(value:Function) : void
      {
         this._sortCompareFunction = value;
         dispatchEvent(new Event("sortCompareFunctionChanged"));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         if(this._visible != value)
         {
            this._visible = value;
            if(value)
            {
               this.newlyVisible = true;
            }
            if(Boolean(this.owner))
            {
               this.owner.columnsInvalid = true;
               this.owner.invalidateSize();
               this.owner.invalidateList();
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="100")]
      [Bindable("widthChanged")]
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(value:Number) : void
      {
         var oldVal:Boolean = false;
         this.explicitWidth = value;
         this.preferredWidth = value;
         if(this.owner != null)
         {
            oldVal = this.resizable;
            this.resizable = false;
            this.owner.resizeColumn(this.colNum,value);
            this.resizable = oldVal;
         }
         else
         {
            this._width = value;
         }
         dispatchEvent(new Event("widthChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setWidth(value:Number) : void
      {
         var oldValue:Number = this._width;
         this._width = value;
         if(oldValue != value)
         {
            dispatchEvent(new Event("widthChanged"));
         }
      }
      
      [Inspectable(category="Advanced")]
      public function get wordWrap() : *
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(value:*) : void
      {
         this._wordWrap = value;
         if(Boolean(this.owner))
         {
            this.owner.invalidateList();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addStyleToProtoChain(chain:Object, target:DisplayObject, filterMap:Object = null) : Object
      {
         var styleName:Object = null;
         var s:Object = null;
         var headerStyleName:Object = null;
         var parentGrid:DataGridBase = this.owner;
         var item:IListItemRenderer = IListItemRenderer(target);
         styleName = styleName;
         if(Boolean(styleName))
         {
            if(styleName is String)
            {
               chain = this.addStylesToProtoChain(String(styleName),chain,target);
            }
            else if(styleName is CSSStyleDeclaration)
            {
               chain = styleName.addStyleToProtoChain(chain,target);
            }
         }
         chain = super.addStyleToProtoChain(chain,target);
         if(Boolean(item.data) && item.data is DataGridColumn)
         {
            headerStyleName = parentGrid.getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               if(headerStyleName is String)
               {
                  chain = this.addStylesToProtoChain(String(headerStyleName),chain,target);
               }
               else if(headerStyleName is CSSStyleDeclaration)
               {
                  chain = headerStyleName.addStyleToProtoChain(chain,target);
               }
            }
            headerStyleName = getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               if(headerStyleName is String)
               {
                  chain = this.addStylesToProtoChain(String(headerStyleName),chain,target);
               }
               else if(headerStyleName is CSSStyleDeclaration)
               {
                  chain = headerStyleName.addStyleToProtoChain(chain,target);
               }
            }
         }
         return chain;
      }
      
      override public function setStyle(styleProp:String, value:*) : void
      {
         if(styleProp == "fontFamily" || styleProp == "fontWeight" || styleProp == "fontStyle")
         {
            if(Boolean(this.owner))
            {
               this.owner.fontContextChanged = true;
               this.owner.invalidateProperties();
            }
         }
         var oldValue:Object = getStyle(styleProp);
         var regenerate:Boolean = false;
         if(factory == null && defaultFactory == null && !overrides && oldValue !== value)
         {
            regenerate = true;
         }
         super.setLocalStyle(styleProp,value);
         if(styleProp == "headerStyleName")
         {
            if(Boolean(this.owner))
            {
               this.owner.regenerateStyleCache(true);
               this.owner.notifyStyleChangeInChildren("headerStyleName",true);
            }
            return;
         }
         if(Boolean(this.owner))
         {
            if(regenerate)
            {
               this.owner.regenerateStyleCache(true);
            }
            this.owner.invalidateList();
         }
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(!data)
         {
            return " ";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data,this);
         }
         if(this.owner.labelFunction != null)
         {
            return this.owner.labelFunction(data,this);
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            try
            {
               if(!this.hasComplexFieldName)
               {
                  data = data[this.dataField];
               }
               else
               {
                  data = this.deriveComplexColumnData(data);
               }
            }
            catch(e:Error)
            {
               data = null;
            }
         }
         if(data is String)
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
      
      public function itemToDataTip(data:Object) : String
      {
         var field:String = null;
         if(this.dataTipFunction != null)
         {
            return this.dataTipFunction(data);
         }
         if(this.owner.dataTipFunction != null)
         {
            return this.owner.dataTipFunction(data);
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            field = this.dataTipField;
            if(!field)
            {
               field = this.owner.dataTipField;
            }
            try
            {
               if(data[field] != null)
               {
                  data = data[field];
               }
               else if(data[this.dataField] != null)
               {
                  data = data[this.dataField];
               }
            }
            catch(e:Error)
            {
               data = null;
            }
         }
         if(data is String)
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
      
      protected function deriveComplexColumnData(data:Object) : Object
      {
         var i:int = 0;
         var currentRef:Object = data;
         if(Boolean(this.complexFieldNameComponents))
         {
            for(i = 0; i < this.complexFieldNameComponents.length; i++)
            {
               currentRef = currentRef[this.complexFieldNameComponents[i]];
            }
         }
         return currentRef;
      }
      
      protected function complexColumnSortCompare(obj1:Object, obj2:Object) : int
      {
         if(!obj1 && !obj2)
         {
            return 0;
         }
         if(!obj1)
         {
            return 1;
         }
         if(!obj2)
         {
            return -1;
         }
         var obj1Data:String = this.deriveComplexColumnData(obj1).toString();
         var obj2Data:String = this.deriveComplexColumnData(obj2).toString();
         if(obj1Data < obj2Data)
         {
            return -1;
         }
         if(obj1Data > obj2Data)
         {
            return 1;
         }
         return 0;
      }
      
      public function getItemRendererFactory(forHeader:Boolean, data:Object) : IFactory
      {
         if(forHeader)
         {
            if(!this._contextHeaderRenderer)
            {
               this._contextHeaderRenderer = this.replaceItemRendererFactory(this.headerRenderer,true);
            }
            return this._contextHeaderRenderer;
         }
         if(!data)
         {
            if(!this._contextNullItemRenderer)
            {
               this._contextNullItemRenderer = this.replaceItemRendererFactory(this.nullItemRenderer);
            }
            return this._contextNullItemRenderer;
         }
         if(!this._contextItemRenderer)
         {
            this._contextItemRenderer = this.replaceItemRendererFactory(this.itemRenderer);
         }
         return this._contextItemRenderer;
      }
      
      private function replaceItemRendererFactory(rendererFactory:IFactory, forHeader:Boolean = false) : IFactory
      {
         var contextualClassFactory:ContextualClassFactory = null;
         if(this.oldEmbeddedFontContext == null)
         {
            return rendererFactory;
         }
         if(rendererFactory == null && this.owner != null)
         {
            rendererFactory = this.owner.itemRenderer;
         }
         if(rendererFactory is ClassFactory)
         {
            contextualClassFactory = new ContextualClassFactory(ClassFactory(rendererFactory).generator,forHeader ? this.oldHeaderEmbeddedFontContext : this.oldEmbeddedFontContext);
            contextualClassFactory.properties = ClassFactory(rendererFactory).properties;
            return contextualClassFactory;
         }
         return rendererFactory;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMeasuringRenderer(forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var factory:IFactory = this.getItemRendererFactory(forHeader,data);
         if(!factory)
         {
            factory = this.owner.itemRenderer;
         }
         if(!this.measuringObjects)
         {
            this.measuringObjects = new Dictionary(false);
         }
         var item:IListItemRenderer = this.measuringObjects[factory];
         if(!item)
         {
            item = factory.newInstance();
            item.visible = false;
            item.styleName = this;
            this.measuringObjects[factory] = item;
         }
         return item;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resetFactories() : void
      {
         this._contextHeaderRenderer = null;
         this._contextItemRenderer = null;
         this._contextNullItemRenderer = null;
         this.determineFontContext();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function determineFontContext() : void
      {
         var embeddedFontContext:IFlexModuleFactory = null;
         var headerFontName:String = null;
         var headerFontWeight:String = null;
         var headerFontStyle:String = null;
         var fontName:String = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
         var fontWeight:String = getStyle("fontWeight");
         var fontStyle:String = getStyle("fontStyle");
         if(fontName == null)
         {
            fontName = StringUtil.trimArrayElements(this.owner.getStyle("fontFamily"),",");
         }
         if(fontWeight == null)
         {
            fontWeight = this.owner.getStyle("fontWeight");
         }
         if(fontStyle == null)
         {
            fontStyle = this.owner.getStyle("fontStyle");
         }
         var bold:Boolean = fontWeight == "bold";
         var italic:Boolean = fontStyle == "italic";
         embeddedFontContext = noEmbeddedFonts || !embeddedFontRegistry ? null : embeddedFontRegistry.getAssociatedModuleFactory(fontName,bold,italic,this,this.owner.moduleFactory,this.owner.systemManager);
         if(embeddedFontContext != this.oldEmbeddedFontContext)
         {
            this.oldEmbeddedFontContext = embeddedFontContext;
            this.owner.invalidateList();
            this.owner.columnRendererChanged(this);
            this._contextItemRenderer = null;
            this._contextNullItemRenderer = null;
         }
         var headerStyleName:Object = this.owner.getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            if(headerStyleName is String)
            {
               headerStyleName = this.owner.styleManager.getMergedStyleDeclaration(String(headerStyleName));
            }
         }
         if(Boolean(headerStyleName))
         {
            headerFontName = StringUtil.trimArrayElements(headerStyleName.getStyle("fontFamily"),",");
            if(Boolean(headerFontName))
            {
               fontName = headerFontName;
            }
            headerFontWeight = headerStyleName.getStyle("fontWeight");
            if(Boolean(headerFontWeight))
            {
               fontWeight = headerFontWeight;
            }
            headerFontStyle = headerStyleName.getStyle("fontStyle");
            if(Boolean(headerFontStyle))
            {
               fontStyle = headerFontStyle;
            }
            bold = fontWeight == "bold";
            italic = fontStyle == "italic";
         }
         headerStyleName = getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            if(headerStyleName is String)
            {
               headerStyleName = this.owner.styleManager.getMergedStyleDeclaration(String(headerStyleName));
            }
         }
         if(Boolean(headerStyleName))
         {
            headerFontName = StringUtil.trimArrayElements(headerStyleName.getStyle("fontFamily"),",");
            if(Boolean(headerFontName))
            {
               fontName = headerFontName;
            }
            headerFontWeight = headerStyleName.getStyle("fontWeight");
            if(Boolean(headerFontWeight))
            {
               fontWeight = headerFontWeight;
            }
            headerFontStyle = headerStyleName.getStyle("fontStyle");
            if(Boolean(headerFontStyle))
            {
               fontStyle = headerFontStyle;
            }
            bold = fontWeight == "bold";
            italic = fontStyle == "italic";
         }
         embeddedFontContext = noEmbeddedFonts || !embeddedFontRegistry ? null : embeddedFontRegistry.getAssociatedModuleFactory(fontName,bold,italic,this,this.owner.moduleFactory,this.owner.systemManager);
         if(embeddedFontContext != this.oldHeaderEmbeddedFontContext)
         {
            this.oldHeaderEmbeddedFontContext = embeddedFontContext;
            this.cachedHeaderRenderer = null;
            this.owner.dataGridHeader.headerItemsChanged = true;
            this._contextHeaderRenderer = null;
         }
      }
      
      private function addStylesToProtoChain(styles:String, chain:Object, target:DisplayObject) : Object
      {
         var declaration:CSSStyleDeclaration = null;
         var styleNames:Array = styles.split(/\s+/);
         for(var c:int = 0; c < styleNames.length; c++)
         {
            if(Boolean(styleNames[c].length))
            {
               declaration = this.owner.styleManager.getMergedStyleDeclaration("." + styleNames[c]);
               if(Boolean(declaration))
               {
                  chain = declaration.addStyleToProtoChain(chain,target);
               }
            }
         }
         return chain;
      }
   }
}

