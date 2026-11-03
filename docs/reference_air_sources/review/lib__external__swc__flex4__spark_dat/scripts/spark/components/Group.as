package spark.components
{
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import mx.core.FlexVersion;
   import mx.core.IFlexModule;
   import mx.core.IFontContextComponent;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.graphics.shaderClasses.ColorBurnShader;
   import mx.graphics.shaderClasses.ColorDodgeShader;
   import mx.graphics.shaderClasses.ColorShader;
   import mx.graphics.shaderClasses.ExclusionShader;
   import mx.graphics.shaderClasses.HueShader;
   import mx.graphics.shaderClasses.LuminosityShader;
   import mx.graphics.shaderClasses.SaturationShader;
   import mx.graphics.shaderClasses.SoftLightShader;
   import mx.styles.IAdvancedStyleClient;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.StyleProtoChain;
   import spark.components.supportClasses.GroupBase;
   import spark.core.DisplayObjectSharingMode;
   import spark.core.IGraphicElement;
   import spark.core.IGraphicElementContainer;
   import spark.core.ISharedDisplayObject;
   import spark.events.ElementExistenceEvent;
   
   [IconFile("Group.png")]
   [DefaultProperty("mxmlContent")]
   [ResourceBundle("components")]
   [Exclude(name="getChildIndex",kind="method")]
   [Exclude(name="getChildAt",kind="method")]
   [Exclude(name="numChildren",kind="property")]
   [Exclude(name="swapChildrenAt",kind="method")]
   [Exclude(name="swapChildren",kind="method")]
   [Exclude(name="setChildIndex",kind="method")]
   [Exclude(name="removeChildAt",kind="method")]
   [Exclude(name="removeChild",kind="method")]
   [Exclude(name="addChildAt",kind="method")]
   [Exclude(name="addChild",kind="method")]
   [Style(name="textShadowAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0",theme="mobile")]
   [Style(name="textShadowColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Event(name="elementRemove",type="spark.events.ElementExistenceEvent")]
   [Event(name="elementAdd",type="spark.events.ElementExistenceEvent")]
   public class Group extends GroupBase implements IVisualElementContainer, IGraphicElementContainer, ISharedDisplayObject
   {
      
      private static const ITEM_ORDERED_LAYERING:uint = 0;
      
      private static const SPARSE_LAYERING:uint = 1;
      
      private var needsDisplayObjectAssignment:Boolean = false;
      
      private var layeringMode:uint = 0;
      
      private var numGraphicElements:uint = 0;
      
      private var _baselinePositionElement:IVisualElement;
      
      private var _blendMode:String = "auto";
      
      private var blendModeChanged:Boolean;
      
      private var blendShaderChanged:Boolean;
      
      private var mxmlContentChanged:Boolean = false;
      
      private var _mxmlContent:Array;
      
      private var scaleGridChanged:Boolean = false;
      
      private var scaleGridStorageVariable:Rectangle;
      
      private var createChildrenCalled:Boolean = false;
      
      private var _redrawRequested:Boolean = false;
      
      public function Group()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         var i:int = 0;
         var elt:IVisualElement = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_5)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var bElement:IVisualElement = this.baselinePositionElement;
         if(bElement == null)
         {
            for(i = 0; i < this.numElements; i++)
            {
               elt = this.getElementAt(i);
               if(elt.includeInLayout)
               {
                  bElement = elt;
                  break;
               }
            }
         }
         if(Boolean(bElement))
         {
            return bElement.baselinePosition + bElement.y;
         }
         return super.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="noScale,scale",defaultValue="noScale")]
      override public function set resizeMode(value:String) : void
      {
         if(this.isValidScaleGrid())
         {
            value = ResizeMode.SCALE;
         }
         super.resizeMode = value;
      }
      
      override public function set scrollRect(value:Rectangle) : void
      {
         var previous:Boolean = this.canShareDisplayObject;
         super.scrollRect = value;
         if(this.numGraphicElements > 0 && previous != this.canShareDisplayObject)
         {
            this.invalidateDisplayObjectOrdering();
         }
         if(mouseEnabledWhereTransparent && hasMouseListeners)
         {
            this.redrawRequested = true;
            super.$invalidateDisplayList();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set hasMouseListeners(value:Boolean) : void
      {
         if(mouseEnabledWhereTransparent)
         {
            this.redrawRequested = true;
         }
         super.hasMouseListeners = value;
      }
      
      override public function set width(value:Number) : void
      {
         if(_width != value)
         {
            if(mouseEnabledWhereTransparent && hasMouseListeners)
            {
               this.redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
         super.width = value;
      }
      
      override public function set height(value:Number) : void
      {
         if(_height != value)
         {
            if(mouseEnabledWhereTransparent && hasMouseListeners)
            {
               this.redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
         super.height = value;
      }
      
      [Inspectable(defaultValue="1.0",category="General",verbose="1")]
      override public function set alpha(value:Number) : void
      {
         if(super.alpha == value)
         {
            return;
         }
         if(this._blendMode == "auto")
         {
            if(value > 0 && value < 1 && (super.alpha == 0 || super.alpha == 1) || (value == 0 || value == 1) && (super.alpha > 0 && super.alpha < 1))
            {
               this.blendModeChanged = true;
               this.invalidateDisplayObjectOrdering();
               invalidateProperties();
            }
         }
         super.alpha = value;
      }
      
      public function get baselinePositionElement() : IVisualElement
      {
         return this._baselinePositionElement;
      }
      
      public function set baselinePositionElement(value:IVisualElement) : void
      {
         if(value === this._baselinePositionElement)
         {
            return;
         }
         this._baselinePositionElement = value;
         invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity",defaultValue="auto")]
      override public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      override public function set blendMode(value:String) : void
      {
         var oldValue:String = null;
         if(value == this._blendMode)
         {
            return;
         }
         invalidateProperties();
         this.blendModeChanged = true;
         if(value == "auto")
         {
            this._blendMode = value;
            if(alpha > 0 && alpha < 1 && super.$blendMode != BlendMode.LAYER || (alpha == 1 || alpha == 0) && super.$blendMode != BlendMode.NORMAL)
            {
               this.invalidateDisplayObjectOrdering();
            }
         }
         else
         {
            oldValue = this._blendMode;
            this._blendMode = value;
            if(this.isAIMBlendMode(value))
            {
               this.blendShaderChanged = true;
            }
            if((oldValue == BlendMode.NORMAL || value == BlendMode.NORMAL) && !(oldValue == BlendMode.NORMAL && value == BlendMode.NORMAL))
            {
               this.invalidateDisplayObjectOrdering();
            }
         }
      }
      
      [ArrayElementType("mx.core.IVisualElement")]
      public function set mxmlContent(value:Array) : void
      {
         if(this.createChildrenCalled)
         {
            this.setMXMLContent(value);
         }
         else
         {
            this.mxmlContentChanged = true;
            this._mxmlContent = value;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMXMLContent() : Array
      {
         if(Boolean(this._mxmlContent))
         {
            return this._mxmlContent.concat();
         }
         return null;
      }
      
      private function setMXMLContent(value:Array) : void
      {
         var i:int = 0;
         var n:int = 0;
         var elt:IVisualElement = null;
         if(this._mxmlContent != null && this._mxmlContent != value)
         {
            for(i = this._mxmlContent.length - 1; i >= 0; i--)
            {
               this.elementRemoved(this._mxmlContent[i],i);
            }
         }
         this._mxmlContent = Boolean(value) ? value.concat() : null;
         if(this._mxmlContent != null)
         {
            n = int(this._mxmlContent.length);
            for(i = 0; i < n; i++)
            {
               elt = this._mxmlContent[i];
               if(Boolean(elt.parent) && elt.parent != this)
               {
                  throw new Error(resourceManager.getString("components","mxmlElementNoMultipleParents",[elt]));
               }
               this.elementAdded(elt,i);
            }
         }
      }
      
      override public function set scale9Grid(value:Rectangle) : void
      {
         if(value != null)
         {
            this.scaleGridTop = value.top;
            this.scaleGridBottom = value.bottom;
            this.scaleGridLeft = value.left;
            this.scaleGridRight = value.right;
         }
         else
         {
            this.scaleGridTop = NaN;
            this.scaleGridBottom = NaN;
            this.scaleGridLeft = NaN;
            this.scaleGridRight = NaN;
         }
      }
      
      [Inspectable(category="General")]
      public function get scaleGridBottom() : Number
      {
         if(Boolean(this.scaleGridStorageVariable))
         {
            return this.scaleGridStorageVariable.height;
         }
         return NaN;
      }
      
      public function set scaleGridBottom(value:Number) : void
      {
         if(!this.scaleGridStorageVariable)
         {
            this.scaleGridStorageVariable = new Rectangle(NaN,NaN,NaN,NaN);
         }
         if(value != this.scaleGridStorageVariable.height)
         {
            this.scaleGridStorageVariable.height = value;
            this.scaleGridChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get scaleGridLeft() : Number
      {
         if(Boolean(this.scaleGridStorageVariable))
         {
            return this.scaleGridStorageVariable.x;
         }
         return NaN;
      }
      
      public function set scaleGridLeft(value:Number) : void
      {
         if(!this.scaleGridStorageVariable)
         {
            this.scaleGridStorageVariable = new Rectangle(NaN,NaN,NaN,NaN);
         }
         if(value != this.scaleGridStorageVariable.x)
         {
            this.scaleGridStorageVariable.x = value;
            this.scaleGridChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get scaleGridRight() : Number
      {
         if(Boolean(this.scaleGridStorageVariable))
         {
            return this.scaleGridStorageVariable.width;
         }
         return NaN;
      }
      
      public function set scaleGridRight(value:Number) : void
      {
         if(!this.scaleGridStorageVariable)
         {
            this.scaleGridStorageVariable = new Rectangle(NaN,NaN,NaN,NaN);
         }
         if(value != this.scaleGridStorageVariable.width)
         {
            this.scaleGridStorageVariable.width = value;
            this.scaleGridChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get scaleGridTop() : Number
      {
         if(Boolean(this.scaleGridStorageVariable))
         {
            return this.scaleGridStorageVariable.y;
         }
         return NaN;
      }
      
      public function set scaleGridTop(value:Number) : void
      {
         if(!this.scaleGridStorageVariable)
         {
            this.scaleGridStorageVariable = new Rectangle(NaN,NaN,NaN,NaN);
         }
         if(value != this.scaleGridStorageVariable.y)
         {
            this.scaleGridStorageVariable.y = value;
            this.scaleGridChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      private function isValidScaleGrid() : Boolean
      {
         return !isNaN(this.scaleGridLeft) && !isNaN(this.scaleGridTop) && !isNaN(this.scaleGridRight) && !isNaN(this.scaleGridBottom);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createChildrenCalled = true;
         if(this.mxmlContentChanged)
         {
            this.mxmlContentChanged = false;
            this.setMXMLContent(this._mxmlContent);
         }
      }
      
      override public function validateProperties() : void
      {
         var length:int = 0;
         var i:int = 0;
         var element:IGraphicElement = null;
         super.validateProperties();
         if(this.numGraphicElements > 0)
         {
            length = this.numElements;
            for(i = 0; i < length; i++)
            {
               element = this.getElementAt(i) as IGraphicElement;
               if(Boolean(element))
               {
                  element.validateProperties();
               }
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         invalidatePropertiesFlag = false;
         if(this.blendModeChanged)
         {
            this.blendModeChanged = false;
            if(this._blendMode == "auto")
            {
               if(alpha == 0 || alpha == 1)
               {
                  super.$blendMode = BlendMode.NORMAL;
               }
               else
               {
                  super.$blendMode = BlendMode.LAYER;
               }
            }
            else if(!this.isAIMBlendMode(this._blendMode))
            {
               super.$blendMode = this._blendMode;
            }
            if(this.blendShaderChanged)
            {
               this.blendShaderChanged = false;
               switch(this._blendMode)
               {
                  case "color":
                     super.blendShader = new ColorShader();
                     break;
                  case "colordodge":
                     super.blendShader = new ColorDodgeShader();
                     break;
                  case "colorburn":
                     super.blendShader = new ColorBurnShader();
                     break;
                  case "exclusion":
                     super.blendShader = new ExclusionShader();
                     break;
                  case "hue":
                     super.blendShader = new HueShader();
                     break;
                  case "luminosity":
                     super.blendShader = new LuminosityShader();
                     break;
                  case "saturation":
                     super.blendShader = new SaturationShader();
                     break;
                  case "softlight":
                     super.blendShader = new SoftLightShader();
               }
            }
         }
         if(invalidatePropertiesFlag)
         {
            super.commitProperties();
            invalidatePropertiesFlag = false;
         }
         if(this.needsDisplayObjectAssignment)
         {
            this.needsDisplayObjectAssignment = false;
            this.assignDisplayObjects();
         }
         if(this.scaleGridChanged)
         {
            if(this.isValidScaleGrid())
            {
               this.resizeMode = ResizeMode.SCALE;
            }
         }
      }
      
      override public function validateSize(recursive:Boolean = false) : void
      {
         var length:int = 0;
         var i:int = 0;
         var element:IGraphicElement = null;
         if(this.numGraphicElements > 0)
         {
            length = this.numElements;
            for(i = 0; i < length; i++)
            {
               element = this.getElementAt(i) as IGraphicElement;
               if(Boolean(element))
               {
                  element.validateSize();
               }
            }
         }
         super.validateSize(recursive);
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         if(_width != w || _height != h)
         {
            if(mouseEnabledWhereTransparent && hasMouseListeners)
            {
               this.redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
         super.setActualSize(w,h);
      }
      
      override public function validateDisplayList() : void
      {
         var length:int = 0;
         var i:int = 0;
         var element:IGraphicElement = null;
         var elementDisplayObject:ISharedDisplayObject = null;
         super.validateDisplayList();
         if(this.needsDisplayObjectAssignment && Boolean(invalidatePropertiesFlag))
         {
            return;
         }
         var sharedDisplayObject:ISharedDisplayObject = this;
         if(this.numGraphicElements > 0)
         {
            length = this.numElements;
            for(i = 0; i < length; i++)
            {
               element = this.getElementAt(i) as IGraphicElement;
               if(element)
               {
                  if(element.depth == 0)
                  {
                     if(element.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT)
                     {
                        if(Boolean(sharedDisplayObject))
                        {
                           sharedDisplayObject.redrawRequested = false;
                        }
                        sharedDisplayObject = element.displayObject as ISharedDisplayObject;
                     }
                     if(!sharedDisplayObject || sharedDisplayObject.redrawRequested)
                     {
                        element.validateDisplayList();
                     }
                  }
                  else
                  {
                     elementDisplayObject = element.displayObject as ISharedDisplayObject;
                     if(!elementDisplayObject || elementDisplayObject.redrawRequested)
                     {
                        element.validateDisplayList();
                        if(Boolean(elementDisplayObject))
                        {
                           elementDisplayObject.redrawRequested = false;
                        }
                     }
                  }
               }
            }
         }
         if(Boolean(sharedDisplayObject))
         {
            sharedDisplayObject.redrawRequested = false;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var overlayCount:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var sharedDisplayObject:ISharedDisplayObject = this;
         if(sharedDisplayObject.redrawRequested)
         {
            graphics.clear();
            drawBackground();
            if(this.isValidScaleGrid() && resizeMode == ResizeMode.SCALE)
            {
               graphics.lineStyle();
               graphics.beginFill(0,0);
               graphics.drawRect(0,0,1,1);
               graphics.drawRect(measuredWidth - 1,measuredHeight - 1,1,1);
               graphics.endFill();
            }
         }
         if(this.scaleGridChanged)
         {
            this.scaleGridChanged = false;
            if(this.isValidScaleGrid())
            {
               overlayCount = Boolean(_overlay) ? _overlay.numDisplayObjects : 0;
               if(numChildren - overlayCount > 0)
               {
                  throw new Error(resourceManager.getString("components","scaleGridGroupError"));
               }
               super.scale9Grid = new Rectangle(this.scaleGridLeft,this.scaleGridTop,this.scaleGridRight - this.scaleGridLeft,this.scaleGridBottom - this.scaleGridTop);
            }
            else
            {
               super.scale9Grid = null;
            }
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         var child:ISimpleStyleClient = null;
         var styleClient:Object = null;
         var iAdvanceStyleClientChild:IAdvancedStyleClient = null;
         if(this.mxmlContentChanged || !recursive)
         {
            return;
         }
         var n:int = this.numElements;
         for(var i:int = 0; i < n; i++)
         {
            child = this.getElementAt(i) as ISimpleStyleClient;
            if(Boolean(child))
            {
               child.styleChanged(styleProp);
               if(child is IStyleClient)
               {
                  IStyleClient(child).notifyStyleChangeInChildren(styleProp,recursive);
               }
            }
         }
         if(advanceStyleClientChildren != null)
         {
            for(styleClient in advanceStyleClientChildren)
            {
               iAdvanceStyleClientChild = styleClient as IAdvancedStyleClient;
               if(Boolean(iAdvanceStyleClientChild))
               {
                  iAdvanceStyleClientChild.styleChanged(styleProp);
               }
            }
         }
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         var child:IVisualElement = null;
         var styleClient:Object = null;
         var iAdvanceStyleClientChild:IAdvancedStyleClient = null;
         initProtoChain();
         var n:int = this.numElements;
         for(var i:int = 0; i < n; i++)
         {
            child = this.getElementAt(i);
            if(child is IStyleClient)
            {
               if(IStyleClient(child).inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED)
               {
                  IStyleClient(child).regenerateStyleCache(recursive);
               }
            }
            else if(child is IUITextField)
            {
               if(Boolean(IUITextField(child).inheritingStyles))
               {
                  StyleProtoChain.initTextField(IUITextField(child));
               }
            }
         }
         if(advanceStyleClientChildren != null)
         {
            for(styleClient in advanceStyleClientChildren)
            {
               iAdvanceStyleClientChild = styleClient as IAdvancedStyleClient;
               if(Boolean(iAdvanceStyleClientChild) && iAdvanceStyleClientChild.inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED)
               {
                  iAdvanceStyleClientChild.regenerateStyleCache(recursive);
               }
            }
         }
      }
      
      override public function get numElements() : int
      {
         if(this._mxmlContent == null)
         {
            return 0;
         }
         return this._mxmlContent.length;
      }
      
      override public function getElementAt(index:int) : IVisualElement
      {
         this.checkForRangeError(index);
         return this._mxmlContent[index];
      }
      
      private function checkForRangeError(index:int, addingElement:Boolean = false) : void
      {
         var maxIndex:int = this._mxmlContent == null ? -1 : int(this._mxmlContent.length - 1);
         if(addingElement)
         {
            maxIndex++;
         }
         if(index < 0 || index > maxIndex)
         {
            throw new RangeError(resourceManager.getString("components","indexOutOfRange",[index]));
         }
      }
      
      private function isAIMBlendMode(value:String) : Boolean
      {
         if(value == "colordodge" || value == "colorburn" || value == "exclusion" || value == "softlight" || value == "hue" || value == "saturation" || value == "color" || value == "luminosity")
         {
            return true;
         }
         return false;
      }
      
      public function addElement(element:IVisualElement) : IVisualElement
      {
         var index:int = this.numElements;
         if(element.parent == this)
         {
            index = this.numElements - 1;
         }
         return this.addElementAt(element,index);
      }
      
      public function addElementAt(element:IVisualElement, index:int) : IVisualElement
      {
         if(element == this)
         {
            throw new ArgumentError(resourceManager.getString("components","cannotAddYourselfAsYourChild"));
         }
         this.checkForRangeError(index,true);
         var host:DisplayObject = element.parent;
         if(host == this)
         {
            this.setElementIndex(element,index);
            return element;
         }
         if(host is IVisualElementContainer)
         {
            IVisualElementContainer(host).removeElement(element);
         }
         if(this._mxmlContent == null)
         {
            this._mxmlContent = [];
         }
         this._mxmlContent.splice(index,0,element);
         if(!this.mxmlContentChanged)
         {
            this.elementAdded(element,index);
         }
         this.scaleGridChanged = true;
         return element;
      }
      
      public function removeElement(element:IVisualElement) : IVisualElement
      {
         return this.removeElementAt(this.getElementIndex(element));
      }
      
      public function removeElementAt(index:int) : IVisualElement
      {
         this.checkForRangeError(index);
         var element:IVisualElement = this._mxmlContent[index];
         if(!this.mxmlContentChanged)
         {
            this.elementRemoved(element,index);
         }
         this._mxmlContent.splice(index,1);
         return element;
      }
      
      public function removeAllElements() : void
      {
         for(var i:int = this.numElements - 1; i >= 0; i--)
         {
            this.removeElementAt(i);
         }
      }
      
      override public function getElementIndex(element:IVisualElement) : int
      {
         var index:int = Boolean(this._mxmlContent) ? this._mxmlContent.indexOf(element) : -1;
         if(index == -1)
         {
            throw ArgumentError(resourceManager.getString("components","elementNotFoundInGroup",[element]));
         }
         return index;
      }
      
      public function setElementIndex(element:IVisualElement, index:int) : void
      {
         this.checkForRangeError(index);
         if(this.getElementIndex(element) == index)
         {
            return;
         }
         this.removeElement(element);
         this.addElementAt(element,index);
      }
      
      public function swapElements(element1:IVisualElement, element2:IVisualElement) : void
      {
         this.swapElementsAt(this.getElementIndex(element1),this.getElementIndex(element2));
      }
      
      public function swapElementsAt(index1:int, index2:int) : void
      {
         var temp:int = 0;
         this.checkForRangeError(index1);
         this.checkForRangeError(index2);
         if(index1 > index2)
         {
            temp = index2;
            index2 = index1;
            index1 = temp;
         }
         else if(index1 == index2)
         {
            return;
         }
         var element1:IVisualElement = this._mxmlContent[index1];
         var element2:IVisualElement = this._mxmlContent[index2];
         if(!this.mxmlContentChanged)
         {
            this.elementRemoved(element1,index1,false);
            this.elementRemoved(element2,index2,false);
         }
         this._mxmlContent.splice(index2,1);
         this._mxmlContent.splice(index1,1);
         this._mxmlContent.splice(index1,0,element2);
         this._mxmlContent.splice(index2,0,element1);
         if(!this.mxmlContentChanged)
         {
            this.elementAdded(element2,index1,false);
            this.elementAdded(element1,index2,false);
         }
      }
      
      override public function invalidateLayering() : void
      {
         if(this.layeringMode == ITEM_ORDERED_LAYERING)
         {
            this.layeringMode = SPARSE_LAYERING;
         }
         this.invalidateDisplayObjectOrdering();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean = true) : void
      {
         if(Boolean(layout))
         {
            layout.elementAdded(index);
         }
         if(element.depth != 0)
         {
            this.invalidateLayering();
         }
         if(element is IFlexModule && IFlexModule(element).moduleFactory == null)
         {
            if(moduleFactory != null)
            {
               IFlexModule(element).moduleFactory = moduleFactory;
            }
            else if(document is IFlexModule && document.moduleFactory != null)
            {
               IFlexModule(element).moduleFactory = document.moduleFactory;
            }
            else if(parent is IFlexModule && IFlexModule(element).moduleFactory != null)
            {
               IFlexModule(element).moduleFactory = IFlexModule(parent).moduleFactory;
            }
         }
         if(element is IFontContextComponent && !(element is UIComponent) && IFontContextComponent(element).fontContext == null)
         {
            IFontContextComponent(element).fontContext = moduleFactory;
         }
         if(element is IGraphicElement)
         {
            ++this.numGraphicElements;
            this.addingGraphicElementChild(element as IGraphicElement);
            this.invalidateDisplayObjectOrdering();
         }
         else if(this.invalidateDisplayObjectOrdering())
         {
            this.addDisplayObjectToDisplayList(DisplayObject(element));
         }
         else
         {
            this.addDisplayObjectToDisplayList(DisplayObject(element),index);
         }
         if(notifyListeners)
         {
            if(hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
            {
               dispatchEvent(new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_ADD,false,false,element,index));
            }
            if(element is IUIComponent && Boolean(element.hasEventListener(FlexEvent.ADD)))
            {
               element.dispatchEvent(new FlexEvent(FlexEvent.ADD));
            }
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean = true) : void
      {
         var childDO:DisplayObject = element as DisplayObject;
         if(notifyListeners)
         {
            if(hasEventListener(ElementExistenceEvent.ELEMENT_REMOVE))
            {
               dispatchEvent(new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_REMOVE,false,false,element,index));
            }
            if(element is IUIComponent && Boolean(element.hasEventListener(FlexEvent.REMOVE)))
            {
               element.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
            }
         }
         if(Boolean(element) && element is IGraphicElement)
         {
            --this.numGraphicElements;
            this.removingGraphicElementChild(element as IGraphicElement);
         }
         else if(Boolean(childDO) && childDO.parent == this)
         {
            super.removeChild(childDO);
         }
         this.invalidateDisplayObjectOrdering();
         invalidateSize();
         invalidateDisplayList();
         if(Boolean(layout))
         {
            layout.elementRemoved(index);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addingGraphicElementChild(child:IGraphicElement) : void
      {
         if(Boolean(child.displayObject) && child.displayObjectSharingMode == DisplayObjectSharingMode.USES_SHARED_OBJECT)
         {
            this.invalidateGraphicElementDisplayList(child);
         }
         child.parentChanged(this);
         if(child is IStyleClient)
         {
            IStyleClient(child).regenerateStyleCache(true);
         }
         if(child is ISimpleStyleClient)
         {
            ISimpleStyleClient(child).styleChanged(null);
         }
         if(child is IStyleClient)
         {
            IStyleClient(child).notifyStyleChangeInChildren(null,true);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removingGraphicElementChild(child:IGraphicElement) : void
      {
         this.discardDisplayObject(child);
         child.parentChanged(null);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function discardDisplayObject(element:IGraphicElement) : void
      {
         var oldDisplayObject:DisplayObject = element.displayObject;
         if(!oldDisplayObject)
         {
            return;
         }
         if(element.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT && oldDisplayObject.parent == this)
         {
            super.removeChild(oldDisplayObject);
            this.invalidateDisplayObjectOrdering();
         }
         else if(oldDisplayObject is ISharedDisplayObject)
         {
            ISharedDisplayObject(oldDisplayObject).redrawRequested = true;
            super.$invalidateDisplayList();
         }
      }
      
      private function get canShareDisplayObject() : Boolean
      {
         if(Boolean(scrollRect))
         {
            return false;
         }
         return (this._blendMode == "normal" || this._blendMode == "auto" && (alpha == 0 || alpha == 1)) && this.layeringMode == ITEM_ORDERED_LAYERING;
      }
      
      private function invalidateDisplayObjectOrdering() : Boolean
      {
         if(this.layeringMode == SPARSE_LAYERING || this.numGraphicElements > 0)
         {
            this.needsDisplayObjectAssignment = true;
            invalidateProperties();
            return true;
         }
         return false;
      }
      
      private function assignDisplayObjects() : void
      {
         var topLayerItems:Vector.<IVisualElement> = null;
         var bottomLayerItems:Vector.<IVisualElement> = null;
         var prevItem:IVisualElement = null;
         var item:IVisualElement = null;
         var layer:Number = NaN;
         var keepLayeringEnabled:Boolean = false;
         var insertIndex:int = 0;
         if(this.canShareDisplayObject)
         {
            prevItem = this;
         }
         var len:int = this.numElements;
         for(var i:int = 0; i < len; i++)
         {
            item = this.getElementAt(i);
            if(this.layeringMode != ITEM_ORDERED_LAYERING)
            {
               layer = Number(item.depth);
               if(layer != 0)
               {
                  if(layer > 0)
                  {
                     if(topLayerItems == null)
                     {
                        topLayerItems = new Vector.<IVisualElement>();
                     }
                     topLayerItems.push(item);
                  }
                  else
                  {
                     if(bottomLayerItems == null)
                     {
                        bottomLayerItems = new Vector.<IVisualElement>();
                     }
                     bottomLayerItems.push(item);
                  }
                  continue;
               }
            }
            insertIndex = this.assignDisplayObjectTo(item,prevItem,insertIndex);
            prevItem = item;
         }
         if(topLayerItems != null)
         {
            keepLayeringEnabled = true;
            GroupBase.sortOnLayer(topLayerItems);
            len = int(topLayerItems.length);
            for(i = 0; i < len; i++)
            {
               insertIndex = this.assignDisplayObjectTo(topLayerItems[i],null,insertIndex);
            }
         }
         if(bottomLayerItems != null)
         {
            keepLayeringEnabled = true;
            insertIndex = 0;
            GroupBase.sortOnLayer(bottomLayerItems);
            len = int(bottomLayerItems.length);
            for(i = 0; i < len; i++)
            {
               insertIndex = this.assignDisplayObjectTo(bottomLayerItems[i],null,insertIndex);
            }
         }
         if(keepLayeringEnabled == false)
         {
            this.layeringMode = ITEM_ORDERED_LAYERING;
         }
         super.$invalidateDisplayList();
      }
      
      private function assignDisplayObjectTo(curElement:IVisualElement, prevElement:IVisualElement, insertIndex:int) : int
      {
         var current:IGraphicElement = null;
         var previous:IGraphicElement = null;
         var oldDisplayObject:DisplayObject = null;
         var oldSharingMode:String = null;
         var ownsDisplayObject:Boolean = false;
         var displayObject:DisplayObject = null;
         if(curElement is DisplayObject)
         {
            super.setChildIndex(curElement as DisplayObject,insertIndex++);
         }
         else if(curElement is IGraphicElement)
         {
            current = IGraphicElement(curElement);
            previous = prevElement as IGraphicElement;
            oldDisplayObject = current.displayObject;
            oldSharingMode = current.displayObjectSharingMode;
            if(Boolean(previous && previous.canShareWithNext(current)) && Boolean(current.canShareWithPrevious(previous)) && current.setSharedDisplayObject(previous.displayObject))
            {
               if(previous.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
               {
                  previous.displayObjectSharingMode = DisplayObjectSharingMode.OWNS_SHARED_OBJECT;
               }
               current.displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
            }
            else if(prevElement == this && current.setSharedDisplayObject(this))
            {
               current.displayObjectSharingMode = DisplayObjectSharingMode.USES_SHARED_OBJECT;
            }
            else
            {
               ownsDisplayObject = oldSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT;
               displayObject = oldDisplayObject;
               if(!ownsDisplayObject || !displayObject)
               {
                  displayObject = current.createDisplayObject();
               }
               if(Boolean(displayObject))
               {
                  this.addDisplayObjectToDisplayList(displayObject,insertIndex++);
               }
               current.displayObjectSharingMode = DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT;
            }
            this.invalidateAfterAssignment(current,oldSharingMode,oldDisplayObject);
         }
         return insertIndex;
      }
      
      private function invalidateAfterAssignment(element:IGraphicElement, oldSharingMode:String, oldDisplayObject:DisplayObject) : void
      {
         var displayObject:DisplayObject = element.displayObject;
         var sharingMode:String = element.displayObjectSharingMode;
         if(oldDisplayObject == displayObject && sharingMode == oldSharingMode)
         {
            return;
         }
         if(displayObject is ISharedDisplayObject)
         {
            ISharedDisplayObject(displayObject).redrawRequested = true;
         }
         if(oldDisplayObject is ISharedDisplayObject)
         {
            ISharedDisplayObject(oldDisplayObject).redrawRequested = true;
         }
         if(Boolean(oldDisplayObject && oldDisplayObject.parent == this) && Boolean(oldDisplayObject != displayObject) && oldSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT)
         {
            super.removeChild(oldDisplayObject);
         }
      }
      
      private function addDisplayObjectToDisplayList(child:DisplayObject, index:int = -1) : void
      {
         var overlayCount:int = Boolean(_overlay) ? _overlay.numDisplayObjects : 0;
         if(child.parent == this)
         {
            super.setChildIndex(child,index != -1 ? index : int(super.numChildren - 1 - overlayCount));
         }
         else
         {
            super.addChildAt(child,index != -1 ? index : int(super.numChildren - overlayCount));
         }
      }
      
      public function invalidateGraphicElementDisplayList(element:IGraphicElement) : void
      {
         if(element.displayObject is ISharedDisplayObject)
         {
            ISharedDisplayObject(element.displayObject).redrawRequested = true;
         }
         super.$invalidateDisplayList();
      }
      
      public function invalidateGraphicElementProperties(element:IGraphicElement) : void
      {
         invalidateProperties();
      }
      
      public function invalidateGraphicElementSize(element:IGraphicElement) : void
      {
         super.$invalidateSize();
      }
      
      public function invalidateGraphicElementSharing(element:IGraphicElement) : void
      {
         this.invalidateDisplayObjectOrdering();
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildError"));
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildAtError"));
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildError"));
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildAtError"));
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         throw new Error(resourceManager.getString("components","setChildIndexError"));
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenError"));
      }
      
      override public function swapChildrenAt(index1:int, index2:int) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenAtError"));
      }
      
      override public function set mouseEnabledWhereTransparent(value:Boolean) : void
      {
         if(value == mouseEnabledWhereTransparent)
         {
            return;
         }
         super.mouseEnabledWhereTransparent = value;
         this.redrawRequested = true;
      }
      
      public function get redrawRequested() : Boolean
      {
         return this._redrawRequested;
      }
      
      public function set redrawRequested(value:Boolean) : void
      {
         this._redrawRequested = value;
      }
   }
}

