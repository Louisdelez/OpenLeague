package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import mx.controls.TextInput;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.ContextualClassFactory;
   import mx.core.EmbeddedFont;
   import mx.core.EmbeddedFontRegistry;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
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
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   public class DataGridColumn extends CSSStyleDeclaration implements IIMESupport
   {
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _headerText:String;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorXOffset:Number = 0;
      
      mx_internal var measuringObjects:Dictionary;
      
      private var fontPropertiesSet:Boolean = false;
      
      [Inspectable(category="General",defaultValue="false")]
      public var rendererIsEditor:Boolean = false;
      
      mx_internal var cachedHeaderRenderer:IListItemRenderer;
      
      public var sortDescending:Boolean = false;
      
      private var cachedEmbeddedFont:EmbeddedFont = null;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorYOffset:Number = 0;
      
      private var _headerWordWrap:*;
      
      private var _dataTipFunction:Function;
      
      private var _visible:Boolean = true;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorWidthOffset:Number = 0;
      
      [Inspectable(category="General")]
      public var itemEditor:IFactory = new ClassFactory(TextInput);
      
      [Inspectable(category="General",defaultValue="false")]
      public var editorUsesEnterKey:Boolean = false;
      
      [Inspectable(category="General")]
      public var editable:Boolean = true;
      
      private var _nullItemRenderer:IFactory;
      
      mx_internal var freeItemRenderersByFactory:Dictionary;
      
      [Inspectable(category="General")]
      public var editorDataField:String = "text";
      
      mx_internal var newlyVisible:Boolean = false;
      
      [Inspectable(category="General")]
      public var draggable:Boolean = true;
      
      protected var hasComplexFieldName:Boolean = false;
      
      private var _sortCompareFunction:Function;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorHeightOffset:Number = 0;
      
      [Inspectable(category="General")]
      public var resizable:Boolean = true;
      
      private var _headerRenderer:IFactory;
      
      mx_internal var owner:DataGridBase;
      
      private var _imeMode:String;
      
      private var _dataTipField:String;
      
      protected var complexFieldNameComponents:Array;
      
      private var _width:Number = 100;
      
      private var oldEmbeddedFontContext:IFlexModuleFactory = null;
      
      private var _wordWrap:*;
      
      mx_internal var preferredWidth:Number = 100;
      
      private var _itemRenderer:IFactory;
      
      mx_internal var colNum:Number;
      
      private var _dataField:String;
      
      private var _minWidth:Number = 20;
      
      private var _labelFunction:Function;
      
      private var hasFontContextBeenSaved:Boolean = false;
      
      [Inspectable(category="General")]
      public var sortable:Boolean = true;
      
      mx_internal var explicitWidth:Number;
      
      private var _showDataTips:*;
      
      public function DataGridColumn(columnName:String = null)
      {
         super();
         if(Boolean(columnName))
         {
            dataField = columnName;
            headerText = columnName;
         }
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry)
         {
            _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
         }
         return _embeddedFontRegistry;
      }
      
      mx_internal function getMeasuringRenderer(forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var factory:IFactory = getItemRendererFactory(forHeader,data);
         if(!factory)
         {
            factory = owner.itemRenderer;
         }
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(false);
         }
         var item:IListItemRenderer = measuringObjects[factory];
         if(!item)
         {
            item = factory.newInstance();
            item.visible = false;
            item.styleName = this;
            measuringObjects[factory] = item;
         }
         return item;
      }
      
      [Inspectable(category="Other")]
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         _imeMode = value;
      }
      
      public function getItemRendererFactory(forHeader:Boolean, data:Object) : IFactory
      {
         if(forHeader)
         {
            return replaceItemRendererFactory(headerRenderer);
         }
         if(!data)
         {
            return replaceItemRendererFactory(nullItemRenderer);
         }
         return replaceItemRendererFactory(itemRenderer);
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         _dataTipFunction = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="Other")]
      [Bindable("nullItemRendererChanged")]
      public function get nullItemRenderer() : IFactory
      {
         return _nullItemRenderer;
      }
      
      [Inspectable(category="Advanced")]
      public function get showDataTips() : *
      {
         return _showDataTips;
      }
      
      [Inspectable(category="Advanced")]
      public function get headerWordWrap() : *
      {
         return _headerWordWrap;
      }
      
      public function set minWidth(value:Number) : void
      {
         _minWidth = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         if(_width < value)
         {
            _width = value;
         }
         dispatchEvent(new Event("minWidthChanged"));
      }
      
      public function set nullItemRenderer(value:IFactory) : void
      {
         _nullItemRenderer = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
            owner.columnRendererChanged(this);
         }
         dispatchEvent(new Event("nullItemRendererChanged"));
      }
      
      public function set showDataTips(value:*) : void
      {
         _showDataTips = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
      }
      
      public function set headerWordWrap(value:*) : void
      {
         _headerWordWrap = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
      }
      
      override mx_internal function addStyleToProtoChain(chain:Object, target:DisplayObject, filterMap:Object = null) : Object
      {
         var styleName:Object = null;
         var s:Object = null;
         var headerStyleName:Object = null;
         var parentGrid:DataGridBase = owner;
         var item:IListItemRenderer = IListItemRenderer(target);
         styleName = styleName;
         if(Boolean(styleName))
         {
            if(styleName is String)
            {
               styleName = StyleManager.getStyleDeclaration("." + styleName);
            }
            if(styleName is CSSStyleDeclaration)
            {
               chain = styleName.addStyleToProtoChain(chain,target);
            }
         }
         chain = super.mx_internal::addStyleToProtoChain(chain,target);
         if(Boolean(item.data) && item.data is DataGridColumn)
         {
            headerStyleName = parentGrid.getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               if(headerStyleName is String)
               {
                  headerStyleName = StyleManager.getStyleDeclaration("." + headerStyleName);
               }
               if(headerStyleName is CSSStyleDeclaration)
               {
                  chain = headerStyleName.addStyleToProtoChain(chain,target);
               }
            }
            headerStyleName = getStyle("headerStyleName");
            if(Boolean(headerStyleName))
            {
               if(headerStyleName is String)
               {
                  headerStyleName = StyleManager.getStyleDeclaration("." + headerStyleName);
               }
               if(headerStyleName is CSSStyleDeclaration)
               {
                  chain = headerStyleName.addStyleToProtoChain(chain,target);
               }
            }
         }
         if(!fontPropertiesSet)
         {
            fontPropertiesSet = true;
            saveFontContext(Boolean(owner) ? owner.moduleFactory : null);
         }
         return chain;
      }
      
      [Inspectable(category="General")]
      [Bindable("headerTextChanged")]
      public function get headerText() : String
      {
         return _headerText != null ? _headerText : dataField;
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("sortCompareFunctionChanged")]
      public function get sortCompareFunction() : Function
      {
         return _sortCompareFunction;
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
         var obj1Data:String = deriveComplexColumnData(obj1).toString();
         var obj2Data:String = deriveComplexColumnData(obj2).toString();
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
      
      mx_internal function hasFontContextChanged(flexModuleFactory:IFlexModuleFactory) : Boolean
      {
         if(!hasFontContextBeenSaved)
         {
            return false;
         }
         var fontName:String = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
         var fontWeight:String = getStyle("fontWeight");
         var fontStyle:String = getStyle("fontStyle");
         var bold:Boolean = fontWeight == "bold";
         var italic:Boolean = fontStyle == "italic";
         var embeddedFont:EmbeddedFont = getEmbeddedFont(fontName,bold,italic);
         var fontContext:IFlexModuleFactory = embeddedFontRegistry.getAssociatedModuleFactory(embeddedFont,flexModuleFactory);
         return fontContext != oldEmbeddedFontContext;
      }
      
      override public function setStyle(styleProp:String, value:*) : void
      {
         fontPropertiesSet = false;
         var oldValue:Object = getStyle(styleProp);
         var regenerate:Boolean = false;
         if(factory == null && defaultFactory == null && !overrides && oldValue !== value)
         {
            regenerate = true;
         }
         super.mx_internal::setStyle(styleProp,value);
         if(styleProp == "headerStyleName")
         {
            if(Boolean(owner))
            {
               owner.regenerateStyleCache(true);
               owner.notifyStyleChangeInChildren("headerStyleName",true);
            }
            return;
         }
         if(Boolean(owner))
         {
            if(regenerate)
            {
               owner.regenerateStyleCache(true);
            }
            if(hasFontContextChanged(owner.moduleFactory))
            {
               owner.columnRendererChanged(this);
            }
            owner.invalidateList();
         }
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get dataField() : String
      {
         return _dataField;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      [Inspectable(category="Advanced")]
      public function get wordWrap() : *
      {
         return _wordWrap;
      }
      
      [Inspectable(category="Other")]
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return _headerRenderer;
      }
      
      mx_internal function setWidth(value:Number) : void
      {
         var oldValue:Number = _width;
         _width = value;
         if(oldValue != value)
         {
            dispatchEvent(new Event("widthChanged"));
         }
      }
      
      mx_internal function getEmbeddedFont(fontName:String, bold:Boolean, italic:Boolean) : EmbeddedFont
      {
         if(Boolean(cachedEmbeddedFont))
         {
            if(cachedEmbeddedFont.fontName == fontName && cachedEmbeddedFont.fontStyle == EmbeddedFontRegistry.getFontStyle(bold,italic))
            {
               return cachedEmbeddedFont;
            }
         }
         cachedEmbeddedFont = new EmbeddedFont(fontName,bold,italic);
         return cachedEmbeddedFont;
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return _dataTipFunction;
      }
      
      public function set width(value:Number) : void
      {
         var oldVal:Boolean = false;
         explicitWidth = value;
         preferredWidth = value;
         if(owner != null)
         {
            oldVal = resizable;
            resizable = false;
            owner.resizeColumn(colNum,value);
            resizable = oldVal;
         }
         else
         {
            _width = value;
         }
         dispatchEvent(new Event("widthChanged"));
      }
      
      [Inspectable(category="General",defaultValue="100")]
      [Bindable("minWidthChanged")]
      public function get minWidth() : Number
      {
         return _minWidth;
      }
      
      protected function deriveComplexColumnData(data:Object) : Object
      {
         var i:int = 0;
         var currentRef:Object = data;
         if(Boolean(complexFieldNameComponents))
         {
            for(i = 0; i < complexFieldNameComponents.length; i++)
            {
               currentRef = currentRef[complexFieldNameComponents[i]];
            }
         }
         return currentRef;
      }
      
      private function saveFontContext(flexModuleFactory:IFlexModuleFactory) : void
      {
         hasFontContextBeenSaved = true;
         var fontName:String = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
         var fontWeight:String = getStyle("fontWeight");
         var fontStyle:String = getStyle("fontStyle");
         var bold:Boolean = fontWeight == "bold";
         var italic:Boolean = fontStyle == "italic";
         var embeddedFont:EmbeddedFont = getEmbeddedFont(fontName,bold,italic);
         oldEmbeddedFontContext = embeddedFontRegistry.getAssociatedModuleFactory(embeddedFont,flexModuleFactory);
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(!data)
         {
            return " ";
         }
         if(labelFunction != null)
         {
            return labelFunction(data,this);
         }
         if(owner.labelFunction != null)
         {
            return owner.labelFunction(data,this);
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            try
            {
               if(!hasComplexFieldName)
               {
                  data = data[dataField];
               }
               else
               {
                  data = deriveComplexColumnData(data);
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
      
      public function set headerText(value:String) : void
      {
         _headerText = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         dispatchEvent(new Event("headerTextChanged"));
      }
      
      public function set sortCompareFunction(value:Function) : void
      {
         _sortCompareFunction = value;
         dispatchEvent(new Event("sortCompareFunctionChanged"));
      }
      
      public function itemToDataTip(data:Object) : String
      {
         var field:String = null;
         if(dataTipFunction != null)
         {
            return dataTipFunction(data);
         }
         if(owner.dataTipFunction != null)
         {
            return owner.dataTipFunction(data);
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            field = dataTipField;
            if(!field)
            {
               field = owner.dataTipField;
            }
            try
            {
               if(data[field] != null)
               {
                  data = data[field];
               }
               else if(data[dataField] != null)
               {
                  data = data[dataField];
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
      
      [Inspectable(category="General",defaultValue="100")]
      [Bindable("widthChanged")]
      public function get width() : Number
      {
         return _width;
      }
      
      public function set dataTipField(value:String) : void
      {
         _dataTipField = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         dispatchEvent(new Event("dataTipChanged"));
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      public function set dataField(value:String) : void
      {
         _dataField = value;
         if(value.indexOf(".") != -1)
         {
            hasComplexFieldName = true;
            complexFieldNameComponents = value.split(".");
            if(_sortCompareFunction == null)
            {
               _sortCompareFunction = complexColumnSortCompare;
            }
         }
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         _headerRenderer = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
            owner.columnRendererChanged(this);
         }
         dispatchEvent(new Event("headerRendererChanged"));
      }
      
      public function set wordWrap(value:*) : void
      {
         _wordWrap = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
      }
      
      [Inspectable(category="Advanced",defaultValue="label")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return _dataTipField;
      }
      
      public function set visible(value:Boolean) : void
      {
         if(_visible != value)
         {
            _visible = value;
            if(value)
            {
               newlyVisible = true;
            }
            if(Boolean(owner))
            {
               owner.columnsInvalid = true;
               owner.invalidateSize();
               owner.invalidateList();
            }
         }
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         _itemRenderer = value;
         if(Boolean(owner))
         {
            owner.invalidateList();
            owner.columnRendererChanged(this);
         }
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      private function replaceItemRendererFactory(rendererFactory:IFactory) : IFactory
      {
         if(oldEmbeddedFontContext == null)
         {
            return rendererFactory;
         }
         if(rendererFactory == null && owner != null)
         {
            rendererFactory = owner.itemRenderer;
         }
         if(rendererFactory is ClassFactory)
         {
            return new ContextualClassFactory(ClassFactory(rendererFactory).generator,oldEmbeddedFontContext);
         }
         return rendererFactory;
      }
      
      [Inspectable(category="Other")]
      [Bindable("itemRendererChanged")]
      public function get itemRenderer() : IFactory
      {
         return _itemRenderer;
      }
      
      [Inspectable(category="Other")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
   }
}

