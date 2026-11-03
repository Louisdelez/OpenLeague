package blix.components.scroll
{
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   
   public class ScrollArea extends ScrollAreaBase
   {
      
      protected var _contents:LayoutContainerView;
      
      public function ScrollArea(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this._contents == null)
         {
            this._contents = new LayoutContainerView(this);
            setTimelineChildByName("contents",this._contents);
         }
         this._contents.getLayoutInvalidated().add(invalidateLayout);
         _viewArea = this._contents;
      }
      
      public function getContents() : LayoutContainerView
      {
         return this._contents;
      }
   }
}

