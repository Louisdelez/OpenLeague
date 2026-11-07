package blix.components.renderer
{
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SelectableRenderer extends LabelButtonX implements ISelectableRenderer
   {
      
      protected var _selectionRequested:Signal = new Signal();
      
      protected var _index:uint;
      
      protected var _labelField:String;
      
      protected var _labelFunction:Function;
      
      protected var _margin:Padding = new Padding();
      
      protected var background:StatefulView;
      
      public function SelectableRenderer(param1:IContext)
      {
         super(param1);
         addEventListener(MouseEvent.CLICK,this.rendererClickHandler);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new StatefulView(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
      }
      
      protected function rendererClickHandler(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getLabelField() : String
      {
         return this._labelField;
      }
      
      public function setLabelField(param1:String) : void
      {
         this._labelField = param1;
         this.refreshText();
      }
      
      public function getLabelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function setLabelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.refreshText();
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this.refreshText();
      }
      
      public function getMargin() : Padding
      {
         return this._margin;
      }
      
      public function setMargin(param1:Padding) : void
      {
         this._margin = param1;
         invalidateLayout();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this.background.setCurrentState(param1);
      }
      
      protected function refreshText() : void
      {
         var _loc1_:String = null;
         if(_data == null)
         {
            setText("");
         }
         else if(this._labelFunction != null)
         {
            _loc1_ = this._labelFunction(_data);
            setText(_loc1_);
         }
         else if(this._labelField != null)
         {
            setText(_data[this._labelField]);
         }
         else
         {
            setText(_data.toString());
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = textField.setExplicitSize(param1 - this._margin.left - this._margin.right,param2 - this._margin.top - this._margin.bottom);
         textField.setExplicitPosition(this._margin.left,this._margin.top);
         this.background.setExplicitSize(_loc3_.x + this._margin.left + this._margin.right,_loc3_.y + this._margin.top + this._margin.bottom);
         return _asset.getBounds(null);
      }
   }
}

