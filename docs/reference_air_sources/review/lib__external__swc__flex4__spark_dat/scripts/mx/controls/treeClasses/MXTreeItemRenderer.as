package mx.controls.treeClasses
{
   import flash.events.MouseEvent;
   import mx.controls.Tree;
   import mx.controls.listClasses.MXItemRenderer;
   import mx.events.TreeEvent;
   import spark.components.Group;
   
   [Exclude(name="listData",kind="property")]
   public class MXTreeItemRenderer extends MXItemRenderer
   {
      
      private var _disclosureGroup:Group;
      
      public function MXTreeItemRenderer()
      {
         super();
      }
      
      public function get disclosureGroup() : Group
      {
         return this._disclosureGroup;
      }
      
      public function set disclosureGroup(value:Group) : void
      {
         if(value != this._disclosureGroup)
         {
            if(Boolean(this._disclosureGroup))
            {
               this._disclosureGroup.removeEventListener(MouseEvent.MOUSE_DOWN,this.disclosureGroup_mouseDownHandler);
               this._disclosureGroup.removeEventListener(MouseEvent.CLICK,this.disclosureGroup_clickHandler);
            }
            this._disclosureGroup = value;
            if(Boolean(this._disclosureGroup))
            {
               this._disclosureGroup.addEventListener(MouseEvent.MOUSE_DOWN,this.disclosureGroup_mouseDownHandler);
               this._disclosureGroup.addEventListener(MouseEvent.CLICK,this.disclosureGroup_clickHandler);
            }
         }
      }
      
      [Bindable("dataChange")]
      public function get treeListData() : TreeListData
      {
         return listData as TreeListData;
      }
      
      protected function disclosureGroup_mouseDownHandler(event:MouseEvent) : void
      {
         event.stopPropagation();
         if(Boolean(Tree(listData.owner).isOpening) || !listData.owner.enabled)
         {
            return;
         }
         this.treeListData.open = !this.treeListData.open;
         Tree(listData.owner).dispatchTreeEvent(TreeEvent.ITEM_OPENING,data,this,event,this.treeListData.open,true,true);
      }
      
      protected function disclosureGroup_clickHandler(event:MouseEvent) : void
      {
         event.stopPropagation();
      }
   }
}

