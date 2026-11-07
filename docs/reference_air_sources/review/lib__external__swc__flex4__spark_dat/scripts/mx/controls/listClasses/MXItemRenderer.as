package mx.controls.listClasses
{
   import mx.managers.IFocusManagerComponent;
   import spark.components.supportClasses.ItemRenderer;
   
   public class MXItemRenderer extends ItemRenderer implements IListItemRenderer, IDropInListItemRenderer
   {
      
      private var rendererStateChanged:Boolean;
      
      private var _listData:BaseListData;
      
      public var editor:IFocusManagerComponent;
      
      public function MXItemRenderer()
      {
         super();
         focusEnabled = false;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
         invalidateProperties();
      }
      
      public function get text() : String
      {
         if(Boolean(this.editor) && "text" in this.editor)
         {
            return this.editor["text"];
         }
         return null;
      }
      
      override public function invalidateDisplayList() : void
      {
         var listBase:ListBase = null;
         if(Boolean(this.listData))
         {
            listBase = ListBase(this.listData.owner);
            if(Boolean(listBase))
            {
               if(showsCaret != listBase.isItemShowingCaret(data) || selected != listBase.isItemSelected(data) || super.hovered != listBase.isItemHighlighted(data))
               {
                  this.rendererStateChanged = true;
                  invalidateProperties();
               }
            }
         }
         super.invalidateDisplayList();
      }
      
      override protected function set hovered(value:Boolean) : void
      {
         var listBase:ListBase = null;
         if(Boolean(this.listData))
         {
            listBase = ListBase(this.listData.owner);
            if(Boolean(listBase))
            {
               selected = listBase.isItemSelected(data);
               value = Boolean(listBase.isItemHighlighted(data));
            }
         }
         super.hovered = value;
      }
      
      override protected function commitProperties() : void
      {
         var listBase:ListBase = null;
         if(Boolean(this.listData))
         {
            listBase = ListBase(this.listData.owner);
            itemIndex = this.listData.rowIndex + listBase.verticalScrollPosition;
         }
         if(this.rendererStateChanged && Boolean(listBase))
         {
            this.rendererStateChanged = false;
            showsCaret = listBase.isItemShowingCaret(data);
            selected = listBase.isItemSelected(data);
            super.hovered = listBase.isItemHighlighted(data);
         }
         super.commitProperties();
      }
      
      override public function setFocus() : void
      {
         if(Boolean(this.editor))
         {
            this.editor.setFocus();
            return;
         }
         super.setFocus();
      }
   }
}

