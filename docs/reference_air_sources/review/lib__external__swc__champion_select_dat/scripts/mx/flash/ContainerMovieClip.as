package mx.flash
{
   import flash.display.DisplayObjectContainer;
   import flash.events.FocusEvent;
   import mx.core.IUIComponent;
   
   [DefaultProperty("content")]
   public dynamic class ContainerMovieClip extends UIMovieClip
   {
      
      private var _contentHolder:*;
      
      private var _content:IUIComponent;
      
      public function ContainerMovieClip()
      {
         super();
      }
      
      public function set content(value:IUIComponent) : void
      {
         if(Boolean(contentHolderObj))
         {
            contentHolderObj.content = value;
         }
         else
         {
            _content = value;
         }
      }
      
      protected function get contentHolderObj() : FlexContentHolder
      {
         var i:int = 0;
         var child:FlexContentHolder = null;
         if(_contentHolder === undefined)
         {
            for(i = 0; i < numChildren; i++)
            {
               child = getChildAt(i) as FlexContentHolder;
               if(Boolean(child))
               {
                  _contentHolder = child;
                  break;
               }
            }
         }
         return _contentHolder;
      }
      
      public function get content() : IUIComponent
      {
         return Boolean(contentHolderObj) ? contentHolderObj.content : _content;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
      }
      
      override protected function findFocusCandidates(obj:DisplayObjectContainer) : void
      {
      }
   }
}

