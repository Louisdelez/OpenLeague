package mx.controls.fileSystemClasses
{
   import flash.filesystem.File;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   
   [ExcludeClass]
   public class FileSystemTreeDataDescriptor extends DefaultDataDescriptor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var parentToChildrenMap:Object = {};
      
      public function FileSystemTreeDataDescriptor()
      {
         super();
      }
      
      override public function getChildren(node:Object, model:Object = null) : ICollectionView
      {
         return this.parentToChildrenMap[node.nativePath];
      }
      
      override public function isBranch(node:Object, model:Object = null) : Boolean
      {
         return File(node).isDirectory;
      }
      
      override public function hasChildren(node:Object, model:Object = null) : Boolean
      {
         var childCollection:ArrayCollection = this.parentToChildrenMap[node.nativePath];
         return childCollection != null && childCollection.length > 0;
      }
      
      public function reset() : void
      {
         this.parentToChildrenMap = {};
      }
      
      public function setChildren(node:Object, children:ArrayCollection) : void
      {
         this.parentToChildrenMap[node.nativePath] = children;
      }
   }
}

