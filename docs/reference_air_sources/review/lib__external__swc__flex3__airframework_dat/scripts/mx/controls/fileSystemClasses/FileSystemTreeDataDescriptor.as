package mx.controls.fileSystemClasses
{
   import flash.filesystem.File;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   
   [ExcludeClass]
   public class FileSystemTreeDataDescriptor extends DefaultDataDescriptor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var parentToChildrenMap:Object = {};
      
      public function FileSystemTreeDataDescriptor()
      {
         super();
      }
      
      public function setChildren(node:Object, children:ArrayCollection) : void
      {
         parentToChildrenMap[node.nativePath] = children;
      }
      
      public function reset() : void
      {
         parentToChildrenMap = {};
      }
      
      override public function getChildren(node:Object, model:Object = null) : ICollectionView
      {
         return parentToChildrenMap[node.nativePath];
      }
      
      override public function hasChildren(node:Object, model:Object = null) : Boolean
      {
         var childCollection:ArrayCollection = parentToChildrenMap[node.nativePath];
         return childCollection != null && childCollection.length > 0;
      }
      
      override public function isBranch(node:Object, model:Object = null) : Boolean
      {
         return File(node).isDirectory;
      }
   }
}

