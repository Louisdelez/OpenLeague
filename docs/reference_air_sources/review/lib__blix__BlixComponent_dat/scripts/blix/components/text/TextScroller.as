package blix.components.text
{
   import blix.components.scroll.ScrollAreaBase;
   import blix.context.IContext;
   import flash.geom.Rectangle;
   
   public class TextScroller extends ScrollAreaBase
   {
      
      protected var _textView:Text;
      
      public function TextScroller(param1:IContext)
      {
         super(param1);
         setMouseWheelEnabled(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._textView = new Text(this);
         setTimelineChildByName("textField",this._textView);
         this._textView.setHorizontalScrollModel(_hScrollModel);
         this._textView.setVerticalScrollModel(_vScrollModel);
         _viewArea = this._textView;
      }
      
      public function getTextView() : Text
      {
         return this._textView;
      }
      
      public function getText() : String
      {
         return this._textView.getText();
      }
      
      public function setText(param1:String) : void
      {
         this._textView.setText(param1);
      }
      
      public function getHtmlText() : String
      {
         return this._textView.getHtmlText();
      }
      
      public function setHtmlText(param1:String) : void
      {
         this._textView.setHtmlText(param1);
      }
      
      override protected function getNeedsHScrollBar() : Boolean
      {
         return this._textView.getMaxScrollH() > 0;
      }
      
      override protected function getNeedsVScrollBar() : Boolean
      {
         return this._textView.getMaxScrollV() > 1;
      }
      
      override protected function updateScrollModel(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            _hScrollModel.setMax(this._textView.getMaxScrollH());
         }
         else
         {
            _hScrollModel.setMax(0);
         }
         _vScrollModel.setMin(1);
         if(param2)
         {
            _vScrollModel.setMax(this._textView.getMaxScrollV());
         }
         else
         {
            _vScrollModel.setMax(1);
         }
      }
      
      override protected function updateScrollBars(param1:Boolean, param2:Boolean, param3:Rectangle) : void
      {
         if(param1)
         {
            hScrollBar.modelToPixels = 30;
         }
         if(param2)
         {
            vScrollBar.modelToPixels = this._textView.getTextHeight() / this._textView.getNumLines() || 30;
         }
         super.updateScrollBars(param1,param2,param3);
      }
      
      override protected function setVisibleArea(param1:Rectangle) : void
      {
      }
   }
}

