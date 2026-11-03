package flexlib.controls
{
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.core.EdgeMetrics;
   import mx.core.IContainer;
   import mx.core.IFlexDisplayObject;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponentDescriptor;
   
   public class CanvasButton extends Button implements IContainer
   {
      
      protected var _creatingContentPane:Boolean;
      
      protected var _viewMetrics:EdgeMetrics;
      
      private var canvas:Canvas;
      
      private var _childrenCreated:Boolean = false;
      
      private var _childDescriptors:Array;
      
      protected var _defaultButton:IFlexDisplayObject;
      
      protected var _verticalScrollPosition:Number;
      
      protected var _horizontalScrollPosition:Number;
      
      private var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;
      
      private var _verticalScrollPolicy:String = ScrollPolicy.AUTO;
      
      public function CanvasButton()
      {
         super();
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         setChildIndex(canvas,numChildren - 1);
      }
      
      public function set childDescriptors(value:Array) : void
      {
         _childDescriptors = value;
      }
      
      public function get horizontalScrollPolicy() : String
      {
         return _horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         this._horizontalScrollPosition = value;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         this._verticalScrollPosition = value;
      }
      
      public function get verticalScrollPolicy() : String
      {
         return _verticalScrollPolicy;
      }
      
      public function get defaultButton() : IFlexDisplayObject
      {
         return this._defaultButton;
      }
      
      public function set viewMetrics(value:EdgeMetrics) : void
      {
         this._viewMetrics = value;
      }
      
      private function createComponents() : void
      {
         var desc:UIComponentDescriptor = null;
         for each(desc in _childDescriptors)
         {
            canvas.createComponentFromDescriptor(desc,true);
         }
      }
      
      public function set horizontalScrollPolicy(value:String) : void
      {
         _horizontalScrollPolicy = value;
         if(Boolean(canvas))
         {
            canvas.horizontalScrollPolicy = value;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredHeight = canvas.getExplicitOrMeasuredHeight();
         measuredWidth = canvas.getExplicitOrMeasuredWidth();
      }
      
      public function set defaultButton(value:IFlexDisplayObject) : void
      {
         this._defaultButton = value;
      }
      
      override public function get mouseChildren() : Boolean
      {
         return super.mouseChildren;
      }
      
      public function set verticalScrollPolicy(value:String) : void
      {
         _verticalScrollPolicy = value;
         if(Boolean(canvas))
         {
            canvas.verticalScrollPolicy = value;
         }
      }
      
      public function set creatingContentPane(value:Boolean) : void
      {
         this._creatingContentPane = value;
      }
      
      public function get viewMetrics() : EdgeMetrics
      {
         return this._viewMetrics;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDocumentDescriptor(desc:UIComponentDescriptor) : void
      {
         if(Boolean(_documentDescriptor) && Boolean(_documentDescriptor.properties.childDescriptors))
         {
            if(Boolean(desc.properties.childDescriptors))
            {
               throw new Error("Multiple sets of visual children have been specified for this component (base component definition and derived component definition).");
            }
         }
         else
         {
            _documentDescriptor = desc;
            _documentDescriptor.document = this;
         }
         if(Boolean(desc.properties.childDescriptors))
         {
            this.childDescriptors = desc.properties.childDescriptors;
         }
      }
      
      public function get creatingContentPane() : Boolean
      {
         return this._creatingContentPane;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         canvas = new Canvas();
         canvas.verticalScrollPolicy = _verticalScrollPolicy;
         canvas.horizontalScrollPolicy = _horizontalScrollPolicy;
         canvas.mouseChildren = super.mouseChildren;
         canvas.buttonMode = super.buttonMode;
         super.addChild(canvas);
         canvas.initializeRepeaterArrays(this);
         createComponents();
         _childrenCreated = true;
      }
      
      override public function set mouseChildren(enable:Boolean) : void
      {
         super.mouseChildren = enable;
         if(Boolean(canvas))
         {
            canvas.mouseChildren = enable;
         }
      }
      
      override public function set buttonMode(value:Boolean) : void
      {
         super.buttonMode = value;
         if(Boolean(canvas))
         {
            canvas.buttonMode = value;
         }
      }
      
      override public function get buttonMode() : Boolean
      {
         return super.buttonMode;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         canvas.setActualSize(unscaledWidth,unscaledHeight);
      }
   }
}

