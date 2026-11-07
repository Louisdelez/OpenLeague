package spark.components
{
   import mx.core.ContainerCreationPolicy;
   import mx.core.IDeferredContentOwner;
   import mx.core.IDeferredInstance;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.SkinnableContainerBase;
   import spark.events.ElementExistenceEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   [DefaultProperty("mxmlContentFactory")]
   [IconFile("SkinnableContainer.png")]
   [Style(name="textShadowAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0",theme="mobile")]
   [Style(name="textShadowColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="touchDelay",type="Number",format="Time",inherit="yes",minValue="0.0")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="downColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark, mobile")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="spark, mobile")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="spark, mobile")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="unfocusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="inactiveTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="wordSpacing",type="Object",inherit="yes")]
   [Style(name="whiteSpaceCollapse",type="String",enumeration="collapse,preserve",inherit="yes")]
   [Style(name="textRotation",type="String",enumeration="auto,rotate0,rotate90,rotate180,rotate270",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes",minValue="0.0")]
   [Style(name="tabStops",type="String",inherit="yes")]
   [Style(name="paragraphStartIndent",type="Number",format="length",inherit="yes")]
   [Style(name="paragraphSpaceBefore",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphSpaceAfter",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphEndIndent",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="listStyleType",type="String",enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerGreek,lowerLatin,upperGreek,upperLatin",inherit="yes")]
   [Style(name="listStylePosition",type="String",enumeration="inside,outside",inherit="yes")]
   [Style(name="listAutoPadding",type="Number",format="length",inherit="yes",minValue="-1000",maxValue="1000")]
   [Style(name="leadingModel",type="String",enumeration="auto,romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,ascentDescentUp,box",inherit="yes")]
   [Style(name="firstBaselineOffset",type="Object",inherit="yes")]
   [Style(name="clearFloats",type="String",enumeration="start,end,left,right,both,none",inherit="yes")]
   [Style(name="breakOpportunity",type="String",enumeration="auto,all,any,none",inherit="yes")]
   [Style(name="blockProgression",type="String",enumeration="tb,rl",inherit="yes")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Event(name="elementRemove",type="spark.events.ElementExistenceEvent")]
   [Event(name="elementAdd",type="spark.events.ElementExistenceEvent")]
   [Event(name="contentCreationComplete",type="mx.events.FlexEvent")]
   public class SkinnableContainer extends SkinnableContainerBase implements IDeferredContentOwner, IVisualElementContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _809612678contentGroup:Group;
      
      private var contentGroupProperties:Object = {};
      
      private var _placeHolderGroup:Group;
      
      private var creationPolicyNone:Boolean = false;
      
      private var _mxmlContent:Array;
      
      private var _contentModified:Boolean = false;
      
      private var _mxmlContentFactory:IDeferredInstance;
      
      private var mxmlContentCreated:Boolean = false;
      
      private var _deferredContentCreated:Boolean;
      
      public function SkinnableContainer()
      {
         super();
      }
      
      override public function set moduleFactory(moduleFactory:IFlexModuleFactory) : void
      {
         super.moduleFactory = moduleFactory;
         styleManager.registerInheritingStyle("_creationPolicy");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get currentContentGroup() : Group
      {
         this.createContentIfNeeded();
         if(!this.contentGroup)
         {
            if(!this._placeHolderGroup)
            {
               this._placeHolderGroup = new Group();
               if(Boolean(this._mxmlContent))
               {
                  this._placeHolderGroup.mxmlContent = this._mxmlContent;
                  this._mxmlContent = null;
               }
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            }
            return this._placeHolderGroup;
         }
         return this.contentGroup;
      }
      
      [Inspectable(enumeration="auto,all,none",defaultValue="auto")]
      public function get creationPolicy() : String
      {
         var result:String = getStyle("_creationPolicy");
         if(result == null)
         {
            result = ContainerCreationPolicy.AUTO;
         }
         if(this.creationPolicyNone)
         {
            result = ContainerCreationPolicy.NONE;
         }
         return result;
      }
      
      public function set creationPolicy(value:String) : void
      {
         if(value == ContainerCreationPolicy.NONE)
         {
            this.creationPolicyNone = true;
            value = ContainerCreationPolicy.AUTO;
         }
         else
         {
            this.creationPolicyNone = false;
         }
         setStyle("_creationPolicy",value);
      }
      
      [Inspectable(defaultValue="true")]
      public function get autoLayout() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.contentGroup))
         {
            return this.contentGroup.autoLayout;
         }
         v = this.contentGroupProperties.autoLayout;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoLayout(value:Boolean) : void
      {
         if(Boolean(this.contentGroup))
         {
            this.contentGroup.autoLayout = value;
            this.contentGroupProperties = BitFlagUtil.update(this.contentGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties.autoLayout = value;
         }
      }
      
      [Inspectable(category="General")]
      public function get layout() : LayoutBase
      {
         return Boolean(this.contentGroup) ? this.contentGroup.layout : this.contentGroupProperties.layout;
      }
      
      public function set layout(value:LayoutBase) : void
      {
         if(Boolean(this.contentGroup))
         {
            this.contentGroup.layout = value;
            this.contentGroupProperties = BitFlagUtil.update(this.contentGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties.layout = value;
         }
      }
      
      [ArrayElementType("mx.core.IVisualElement")]
      public function set mxmlContent(value:Array) : void
      {
         if(Boolean(this.contentGroup))
         {
            this.contentGroup.mxmlContent = value;
         }
         else if(Boolean(this._placeHolderGroup))
         {
            this._placeHolderGroup.mxmlContent = value;
         }
         else
         {
            this._mxmlContent = value;
         }
         if(value != null)
         {
            this._contentModified = true;
         }
      }
      
      [ArrayElementType("mx.core.IVisualElement")]
      [InstanceType("Array")]
      public function set mxmlContentFactory(value:IDeferredInstance) : void
      {
         if(value == this._mxmlContentFactory)
         {
            return;
         }
         this._mxmlContentFactory = value;
         this.mxmlContentCreated = false;
      }
      
      public function get numElements() : int
      {
         return this.currentContentGroup.numElements;
      }
      
      public function getElementAt(index:int) : IVisualElement
      {
         return this.currentContentGroup.getElementAt(index);
      }
      
      public function getElementIndex(element:IVisualElement) : int
      {
         return this.currentContentGroup.getElementIndex(element);
      }
      
      public function addElement(element:IVisualElement) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.addElement(element);
      }
      
      public function addElementAt(element:IVisualElement, index:int) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.addElementAt(element,index);
      }
      
      public function removeElement(element:IVisualElement) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.removeElement(element);
      }
      
      public function removeElementAt(index:int) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.removeElementAt(index);
      }
      
      public function removeAllElements() : void
      {
         this._contentModified = true;
         this.currentContentGroup.removeAllElements();
      }
      
      public function setElementIndex(element:IVisualElement, index:int) : void
      {
         this._contentModified = true;
         this.currentContentGroup.setElementIndex(element,index);
      }
      
      public function swapElements(element1:IVisualElement, element2:IVisualElement) : void
      {
         this._contentModified = true;
         this.currentContentGroup.swapElements(element1,element2);
      }
      
      public function swapElementsAt(index1:int, index2:int) : void
      {
         this._contentModified = true;
         this.currentContentGroup.swapElementsAt(index1,index2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createContentIfNeeded();
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newContentGroupProperties:uint = 0;
         var sourceContent:Array = null;
         var i:int = 0;
         super.partAdded(partName,instance);
         if(instance == this.contentGroup)
         {
            if(this._contentModified)
            {
               if(this._placeHolderGroup != null)
               {
                  sourceContent = this._placeHolderGroup.getMXMLContent();
                  this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
                  for(i = this._placeHolderGroup.numElements; i > 0; i--)
                  {
                     this._placeHolderGroup.removeElementAt(0);
                  }
                  this.contentGroup.mxmlContent = Boolean(sourceContent) ? sourceContent.slice() : null;
               }
               else if(this._mxmlContent != null)
               {
                  this.contentGroup.mxmlContent = this._mxmlContent;
                  this._mxmlContent = null;
               }
            }
            newContentGroupProperties = 0;
            if(this.contentGroupProperties.autoLayout !== undefined)
            {
               this.contentGroup.autoLayout = this.contentGroupProperties.autoLayout;
               newContentGroupProperties = uint(BitFlagUtil.update(newContentGroupProperties,AUTO_LAYOUT_PROPERTY_FLAG,true));
            }
            if(this.contentGroupProperties.layout !== undefined)
            {
               this.contentGroup.layout = this.contentGroupProperties.layout;
               newContentGroupProperties = uint(BitFlagUtil.update(newContentGroupProperties,LAYOUT_PROPERTY_FLAG,true));
            }
            this.contentGroupProperties = newContentGroupProperties;
            this.contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
            this.contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            if(Boolean(this._placeHolderGroup))
            {
               this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
               this._placeHolderGroup = null;
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newContentGroupProperties:Object = null;
         var myMxmlContent:Array = null;
         super.partRemoved(partName,instance);
         if(instance == this.contentGroup)
         {
            this.contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
            this.contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            newContentGroupProperties = {};
            if(BitFlagUtil.isSet(this.contentGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG))
            {
               newContentGroupProperties.autoLayout = this.contentGroup.autoLayout;
            }
            if(BitFlagUtil.isSet(this.contentGroupProperties as uint,LAYOUT_PROPERTY_FLAG))
            {
               newContentGroupProperties.layout = this.contentGroup.layout;
            }
            this.contentGroupProperties = newContentGroupProperties;
            myMxmlContent = this.contentGroup.getMXMLContent();
            if(this._contentModified && Boolean(myMxmlContent))
            {
               this._placeHolderGroup = new Group();
               this._placeHolderGroup.mxmlContent = myMxmlContent;
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            }
            this.contentGroup.mxmlContent = null;
            this.contentGroup.layout = null;
         }
      }
      
      public function createDeferredContent() : void
      {
         var deferredContent:Object = null;
         if(!this.mxmlContentCreated)
         {
            this.mxmlContentCreated = true;
            if(Boolean(this._mxmlContentFactory))
            {
               deferredContent = this._mxmlContentFactory.getInstance();
               this.mxmlContent = deferredContent as Array;
               this._deferredContentCreated = true;
               dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
            }
         }
      }
      
      public function get deferredContentCreated() : Boolean
      {
         return this._deferredContentCreated;
      }
      
      private function createContentIfNeeded() : void
      {
         if(!this.mxmlContentCreated && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createDeferredContent();
         }
      }
      
      private function contentGroup_elementAddedHandler(event:ElementExistenceEvent) : void
      {
         event.element.owner = this;
         dispatchEvent(event);
      }
      
      private function contentGroup_elementRemovedHandler(event:ElementExistenceEvent) : void
      {
         event.element.owner = null;
         dispatchEvent(event);
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
   }
}

