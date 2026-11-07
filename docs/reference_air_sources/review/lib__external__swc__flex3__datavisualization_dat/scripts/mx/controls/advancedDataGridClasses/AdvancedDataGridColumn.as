package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.controls.AdvancedDataGridBaseEx;
   import mx.controls.TextInput;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.EmbeddedFont;
   import mx.core.EmbeddedFontRegistry;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.Singleton;
   import mx.formatters.Formatter;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   
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
   public class AdvancedDataGridColumn extends CSSStyleDeclaration implements IIMESupport
   {
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _headerText:String;
      
      private var _showDataTips:*;
      
      [Inspectable(category="General",defaultValue="false")]
      public var rendererIsEditor:Boolean = false;
      
      private var fontPropertiesSet:Boolean = false;
      
      public var sortDescending:Boolean = false;
      
      private var _visible:Boolean = true;
      
      private var cachedEmbeddedFont:EmbeddedFont = null;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorYOffset:Number = 0;
      
      private var _headerWordWrap:*;
      
      private var _dataTipFunction:Function;
      
      private var _formatter:Formatter;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorWidthOffset:Number = 0;
      
      [Inspectable(category="General")]
      public var itemEditor:IFactory = new ClassFactory(TextInput);
      
      [Inspectable(category="General")]
      public var editable:Boolean = true;
      
      [Inspectable(category="General",defaultValue="false")]
      public var editorUsesEnterKey:Boolean = false;
      
      [Inspectable(category="General")]
      public var editorDataField:String = "text";
      
      private var _headerRenderer:IFactory;
      
      private var _sortCompareFunction:Function;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorHeightOffset:Number = 0;
      
      [Inspectable(category="General")]
      public var resizable:Boolean = true;
      
      private var _styleFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var owner:AdvancedDataGridBaseEx;
      
      private var _imeMode:String;
      
      private var _dataTipField:String;
      
      private var _width:Number = 100;
      
      private var oldEmbeddedFontContext:IFlexModuleFactory = null;
      
      private var _wordWrap:*;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var preferredWidth:Number = 100;
      
      private var _itemRenderer:IFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var colNum:Number;
      
      private var _dataField:String;
      
      private var _minWidth:Number = 20;
      
      private var _labelFunction:Function;
      
      private var hasFontContextBeenSaved:Boolean = false;
      
      [Inspectable(category="General")]
      public var sortable:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitWidth:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var editorXOffset:Number = 0;
      
      public function AdvancedDataGridColumn(columnName:String = null)
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
      
      [Inspectable(category="Other")]
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         _imeMode = value;
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
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addStyleToProtoChain(chain:Object, target:DisplayObject, filterMap:Object = null) : Object
      {
         var s:Object = null;
         var headerStyleName:Object = null;
         var parentGrid:AdvancedDataGridBaseEx = owner;
         var item:IListItemRenderer = IListItemRenderer(target);
         chain = super.addStyleToProtoChain(chain,target);
         if(Boolean(item.data) && item.data is AdvancedDataGridColumn)
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
      
      public function set styleFunction(value:Function) : void
      {
         _styleFunction = value;
         if(Boolean(owner))
         {
            owner.invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("headerTextChanged")]
      public function get headerText() : String
      {
         return _headerText != null ? _headerText : dataField;
      }
      
      public function clone() : AdvancedDataGridColumn
      {
         var col:AdvancedDataGridColumn = new AdvancedDataGridColumn();
         copyProperties(col);
         return col;
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("sortCompareFunctionChanged")]
      public function get sortCompareFunction() : Function
      {
         return _sortCompareFunction;
      }
      
      private function itemToLabelWithoutFormatting(data:Object) : String
      {
         var headerInfo:AdvancedDataGridHeaderInfo = owner.getHeaderInfo(this);
         if(headerInfo.internalLabelFunction != null)
         {
            data = headerInfo.internalLabelFunction(data,this);
         }
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
               data = data[dataField];
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasFontContextChanged(flexModuleFactory:IFlexModuleFactory) : Boolean
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
         super.setStyle(styleProp,value);
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
      [Bindable("dataFieldChanged")]
      public function get dataField() : String
      {
         return _dataField;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      private function applyFormatting(data:String) : String
      {
         var label:String = null;
         if(formatter != null && data != null)
         {
            label = formatter.format(data);
            if(Boolean(formatter.error))
            {
               return null;
            }
            return label;
         }
         return data;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setWidth(value:Number) : void
      {
         _width = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getEmbeddedFont(fontName:String, bold:Boolean, italic:Boolean) : EmbeddedFont
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
      
      protected function copyProperties(col:AdvancedDataGridColumn) : void
      {
         col.defaultFactory = this.defaultFactory;
         col.editable = this.editable;
         col.editorDataField = this.editorDataField;
         col.editorHeightOffset = this.editorHeightOffset;
         col.editorUsesEnterKey = this.editorUsesEnterKey;
         col.editorWidthOffset = this.editorWidthOffset;
         col.editorXOffset = this.editorXOffset;
         col.editorYOffset = this.editorYOffset;
         col.factory = this.factory;
         col.itemEditor = this.itemEditor;
         col.rendererIsEditor = this.rendererIsEditor;
         col.resizable = this.resizable;
         col.sortable = this.sortable;
         col.sortDescending = this.sortDescending;
         col.dataField = this.dataField;
         col.dataTipField = this.dataTipField;
         col.dataTipFunction = this.dataTipFunction;
         col.formatter = this.formatter;
         col.headerRenderer = this.headerRenderer;
         col.headerText = this.headerText;
         col.headerWordWrap = this.headerWordWrap;
         col.imeMode = this.imeMode;
         col.itemRenderer = this.itemRenderer;
         col.labelFunction = this.labelFunction;
         col.minWidth = this.minWidth;
         col.showDataTips = this.showDataTips;
         col.sortCompareFunction = this.sortCompareFunction;
         col.styleFunction = this.styleFunction;
         col.visible = this.visible;
         col.width = this.width;
         col.wordWrap = this.wordWrap;
         col.setStyle("backgroundColor",this.getStyle("backgroundColor"));
         col.setStyle("headerStyleName",this.getStyle("headerStyleName"));
         col.setStyle("paddingLeft",this.getStyle("paddingLeft"));
         col.setStyle("paddingRight",this.getStyle("paddingRight"));
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
      
      public function set formatter(value:Formatter) : void
      {
         _formatter = value;
         if(Boolean(owner))
         {
            owner.invalidateDisplayList();
         }
      }
      
      public function get styleFunction() : Function
      {
         return _styleFunction;
      }
      
      public function itemToLabel(data:Object, withFormatting:Boolean = true) : String
      {
         var label:String = itemToLabelWithoutFormatting(data);
         if(withFormatting)
         {
            return applyFormatting(label);
         }
         return label;
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
         if(data is AdvancedDataGridColumn)
         {
            return AdvancedDataGridColumn(data).headerText;
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
      
      public function get formatter() : Formatter
      {
         return _formatter;
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
         if(Boolean(owner))
         {
            owner.invalidateList();
         }
         dispatchEvent(new Event("dataFieldChanged"));
      }
      
      public function set visible(value:Boolean) : void
      {
         if(_visible != value)
         {
            _visible = value;
            if(Boolean(owner))
            {
               owner.columnsInvalid = true;
               owner.invalidateProperties();
               owner.invalidateSize();
               owner.invalidateList();
            }
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

