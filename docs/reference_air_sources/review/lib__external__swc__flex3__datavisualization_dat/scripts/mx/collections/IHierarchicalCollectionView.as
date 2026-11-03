package mx.collections
{
   public interface IHierarchicalCollectionView extends ICollectionView
   {
      
      function get source() : IHierarchicalData;
      
      function get openNodes() : Object;
      
      function removeChildAt(param1:Object, param2:int) : Boolean;
      
      function openNode(param1:Object) : void;
      
      function addChildAt(param1:Object, param2:Object, param3:int) : Boolean;
      
      function getNodeDepth(param1:Object) : int;
      
      function getParentItem(param1:Object) : *;
      
      function getChildren(param1:Object) : ICollectionView;
      
      function set source(param1:IHierarchicalData) : void;
      
      function removeChild(param1:Object, param2:Object) : Boolean;
      
      function closeNode(param1:Object) : void;
      
      function addChild(param1:Object, param2:Object) : Boolean;
      
      function get hasRoot() : Boolean;
      
      function set openNodes(param1:Object) : void;
      
      function set showRoot(param1:Boolean) : void;
      
      function get showRoot() : Boolean;
   }
}

