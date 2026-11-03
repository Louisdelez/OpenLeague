package mx.utils
{
   import flash.filesystem.File;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   [ExcludeClass]
   public class DirectoryEnumeration
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private var _source:Array;
      
      private var _enumerationMode:String = DirectoryEnumerationMode.DIRECTORIES_FIRST;
      
      private var _filterFunction:Function;
      
      private var _nameCompareFunction:Function;
      
      private var extensionsSet:Object;
      
      private var _extensions:Array;
      
      private var _showHidden:Boolean = false;
      
      private var _collection:ArrayCollection;
      
      public function DirectoryEnumeration(source:Array = null)
      {
         super();
         this.source = source;
      }
      
      public function get showHidden() : Boolean
      {
         return _showHidden;
      }
      
      public function fileCompareFunction(file1:File, file2:File, fields:Array = null) : int
      {
         if(Boolean(file1.isDirectory) && !file2.isDirectory)
         {
            if(enumerationMode == DirectoryEnumerationMode.DIRECTORIES_FIRST)
            {
               return -1;
            }
            if(enumerationMode == DirectoryEnumerationMode.FILES_FIRST)
            {
               return 1;
            }
         }
         if(!file1.isDirectory && Boolean(file2.isDirectory))
         {
            if(enumerationMode == DirectoryEnumerationMode.DIRECTORIES_FIRST)
            {
               return 1;
            }
            if(enumerationMode == DirectoryEnumerationMode.FILES_FIRST)
            {
               return -1;
            }
         }
         return nameCompareFunction != null ? int(nameCompareFunction(file1.name,file2.name)) : defaultNameCompareFunction(file1.name,file2.name);
      }
      
      public function get enumerationMode() : String
      {
         return _enumerationMode;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         _showHidden = value;
      }
      
      protected function defaultNameCompareFunction(name1:String, name2:String) : int
      {
         name1 = name1.toLocaleLowerCase();
         name2 = name2.toLocaleLowerCase();
         if(name1 < name2)
         {
            return -1;
         }
         if(name1 > name2)
         {
            return 1;
         }
         return 0;
      }
      
      public function get nameCompareFunction() : Function
      {
         return _nameCompareFunction;
      }
      
      public function set enumerationMode(value:String) : void
      {
         _enumerationMode = value;
      }
      
      public function get extensions() : Array
      {
         return _extensions;
      }
      
      public function set filterFunction(value:Function) : void
      {
         _filterFunction = value;
      }
      
      public function get source() : Array
      {
         return _source;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         _nameCompareFunction = value;
      }
      
      public function get collection() : ArrayCollection
      {
         return _collection;
      }
      
      public function set extensions(value:Array) : void
      {
         var s:String = null;
         _extensions = value;
         extensionsSet = {};
         for each(s in extensions)
         {
            if(s.charAt(0) == ".")
            {
               s = s.substr(1);
            }
            extensionsSet[s.toLowerCase()] = true;
         }
      }
      
      public function refresh() : void
      {
         _collection.refresh();
      }
      
      public function get filterFunction() : Function
      {
         return _filterFunction;
      }
      
      public function set source(value:Array) : void
      {
         _source = value;
         _collection = new ArrayCollection(source);
         _collection.filterFunction = fileFilterFunction;
         _collection.sort = new Sort();
         _collection.sort.compareFunction = fileCompareFunction;
         _collection.refresh();
      }
      
      public function fileFilterFunction(file:File) : Boolean
      {
         var extension:String = null;
         if(!file.exists)
         {
            return false;
         }
         if(!showHidden && Boolean(file.isHidden) && Boolean(file.parent))
         {
            return false;
         }
         if(enumerationMode == DirectoryEnumerationMode.FILES_ONLY && Boolean(file.isDirectory) || enumerationMode == DirectoryEnumerationMode.DIRECTORIES_ONLY && !file.isDirectory)
         {
            return false;
         }
         if(Boolean(extensions) && !file.isDirectory)
         {
            extension = file.extension;
            if(!extension || !extensionsSet[extension.toLowerCase()])
            {
               return false;
            }
         }
         return Boolean(filterFunction != null ? filterFunction(file) : true);
      }
   }
}

